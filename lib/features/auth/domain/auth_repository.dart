import 'package:read_radius/features/auth/domain/auth_session_state.dart';

abstract class AuthRepository {
  Stream<AuthSessionState> authStateChanges();
  Stream<String?> userPhotoUrlChanges();
  Future<void> signInWithFacebook();
  Future<void> signOut();
}
