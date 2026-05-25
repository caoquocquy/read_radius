import 'package:book_radius/features/auth/domain/auth_session_state.dart';

abstract class AuthRepository {
  Stream<AuthSessionState> authStateChanges();
  Future<void> signInWithFacebook();
  Future<void> signOut();
}
