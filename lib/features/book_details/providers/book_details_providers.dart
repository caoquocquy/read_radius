import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/domain/home_repository.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_details_providers.g.dart';

// ---------------------------------------------------------------------------
// Book details – fetches a single book's full details (used by details screen)
// ---------------------------------------------------------------------------
@riverpod
Future<HomeBookDetails> bookDetails(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    throw const FormatException('Book id cannot be empty.');
  }

  final HomeRepository repo = ref.watch(homeRepositoryProvider);
  return repo.fetchBookDetails(normalizedBookId);
}

// ---------------------------------------------------------------------------
// Shelf status for a single book (used by details screen)
// ---------------------------------------------------------------------------
@riverpod
Future<ShelfStatus?> bookShelfStatus(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    return null;
  }

  final AuthSessionState authState = await ref.watch(
    authSessionProvider.future,
  );
  if (authState != AuthSessionState.authenticated) {
    return null;
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return null;
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  final Map<String, ShelfStatus> statuses = await shelvesRepo
      .fetchBookStatusesForUser(userId, <String>[normalizedBookId]);
  return statuses[normalizedBookId];
}

// ---------------------------------------------------------------------------
// Shelf book data (includes reading progress) for a single book
// ---------------------------------------------------------------------------
@riverpod
Future<ShelfBook?> bookShelfEntry(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    return null;
  }

  final AuthSessionState authState = await ref.watch(
    authSessionProvider.future,
  );
  if (authState != AuthSessionState.authenticated) {
    return null;
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return null;
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  return shelvesRepo.fetchShelfBookForUser(
    userId: userId,
    bookId: normalizedBookId,
  );
}

// ---------------------------------------------------------------------------
// Controller that sets a book's shelf status (Want to Read / Reading / Completed)
// ---------------------------------------------------------------------------
@riverpod
class BookShelfActionController extends _$BookShelfActionController {
  @override
  Future<void> build() async {}

  Future<void> setBookStatus({
    required HomeBook book,
    required ShelfStatus status,
  }) async {
    if (!ref.mounted) {
      return;
    }

    state = const AsyncLoading<void>();

    try {
      final AuthSessionState authState = await ref.read(
        authSessionProvider.future,
      );
      if (authState != AuthSessionState.authenticated) {
        throw Exception('Sign in is required to manage shelves.');
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('Could not resolve authenticated user.');
      }

      final ShelvesRepository shelvesRepo = ref.read(shelvesRepositoryProvider);
      await shelvesRepo.upsertBookStatusForUser(
        userId: userId,
        book: ShelfBookSeed(
          bookId: book.id,
          title: book.title,
          authors: book.authors,
          thumbnailUrl: book.thumbnailUrl,
        ),
        status: status,
      );

      if (!ref.mounted) {
        return;
      }

      ref.invalidate(homeBookStatusesProvider);
      ref.invalidate(bookShelfStatusProvider(book.id));
      ref.invalidate(bookShelfEntryProvider(book.id));
      ref.invalidate(shelvesByStatusProvider);
      state = const AsyncData<void>(null);
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}

// ---------------------------------------------------------------------------
// Controller that updates reading progress and transitions to Completed when at 100%
// ---------------------------------------------------------------------------
@riverpod
class BookReadingProgressController extends _$BookReadingProgressController {
  @override
  Future<void> build() async {}

  Future<ShelfStatus> updateProgress({
    required HomeBookDetails details,
    required int currentPercent,
  }) async {
    if (!ref.mounted) {
      return ShelfStatus.reading;
    }

    state = const AsyncLoading<void>();

    try {
      final AuthSessionState authState = await ref.read(
        authSessionProvider.future,
      );
      if (authState != AuthSessionState.authenticated) {
        throw Exception('Sign in is required to update reading progress.');
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('Could not resolve authenticated user.');
      }

      int normalizedPercent = currentPercent.clamp(0, 100);

      ShelfStatus targetStatus = ShelfStatus.reading;
      if (normalizedPercent >= 100) {
        targetStatus = ShelfStatus.completed;
        normalizedPercent = 100;
      }

      final ShelvesRepository shelvesRepo = ref.read(shelvesRepositoryProvider);
      await shelvesRepo.upsertReadingProgressForUser(
        userId: userId,
        book: ShelfBookSeed(
          bookId: details.id,
          title: details.title,
          authors: details.authors,
          thumbnailUrl: details.thumbnailUrl,
        ),
        status: targetStatus,
        currentPercent: normalizedPercent,
      );

      if (!ref.mounted) {
        return targetStatus;
      }

      ref.invalidate(bookShelfStatusProvider(details.id));
      ref.invalidate(homeBookStatusesProvider);
      ref.invalidate(bookShelfEntryProvider(details.id));
      ref.invalidate(shelvesByStatusProvider);
      state = const AsyncData<void>(null);
      return targetStatus;
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncError<void>(error, stackTrace);
      }
      rethrow;
    }
  }
}
