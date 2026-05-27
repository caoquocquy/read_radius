import 'package:read_radius/features/auth/data/firebase_auth_repository.dart';
import 'package:read_radius/features/auth/domain/auth_repository.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository.create();
}

@riverpod
Stream<AuthSessionState> authSession(Ref ref) {
  final AuthRepository repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
}

final StreamProvider<String?> authUserPhotoUrlProvider =
    StreamProvider.autoDispose<String?>((Ref ref) {
      final AuthRepository repo = ref.watch(authRepositoryProvider);
      return repo.userPhotoUrlChanges();
    });

@riverpod
String? authUserId(Ref ref) {
  final AuthRepository repo = ref.watch(authRepositoryProvider);
  return repo.currentUserId;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {
    ref.keepAlive();
  }

  Future<void> continueWithFacebook() async {
    if (!ref.mounted) {
      return;
    }
    state = const AsyncLoading<void>();
    final AsyncValue<void> nextState = await AsyncValue.guard(() async {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      await repo.signInWithFacebook();
    });
    if (!ref.mounted) {
      return;
    }
    state = nextState;
  }

  Future<void> signOut() async {
    if (!ref.mounted) {
      return;
    }
    state = const AsyncLoading<void>();
    final AsyncValue<void> nextState = await AsyncValue.guard(() async {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      await repo.signOut();
    });
    if (!ref.mounted) {
      return;
    }
    state = nextState;
  }
}
