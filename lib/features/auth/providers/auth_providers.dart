import 'package:book_radius/features/auth/data/firebase_auth_repository.dart';
import 'package:book_radius/features/auth/domain/auth_repository.dart';
import 'package:book_radius/features/auth/domain/auth_session_state.dart';
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

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

  Future<void> continueWithFacebook() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      await repo.signInWithFacebook();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      await repo.signOut();
    });
  }
}
