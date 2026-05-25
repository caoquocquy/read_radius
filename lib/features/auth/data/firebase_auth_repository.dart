import 'package:book_radius/features/auth/domain/auth_failure.dart';
import 'package:book_radius/features/auth/domain/auth_repository.dart';
import 'package:book_radius/features/auth/domain/auth_session_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth, this._facebookAuth);

  factory FirebaseAuthRepository.create() {
    return FirebaseAuthRepository(FirebaseAuth.instance, FacebookAuth.instance);
  }

  final FirebaseAuth _firebaseAuth;
  final FacebookAuth _facebookAuth;

  @override
  Stream<AuthSessionState> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return AuthSessionState.guest;
      return AuthSessionState.authenticated;
    });
  }

  @override
  Future<void> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();

    if (result.status == LoginStatus.cancelled) {
      throw const AuthFailure('Facebook sign in cancelled.');
    }

    if (result.status == LoginStatus.failed) {
      throw AuthFailure(result.message ?? 'Facebook sign in failed.');
    }

    if (result.status == LoginStatus.operationInProgress) {
      throw const AuthFailure('Facebook sign in already in progress.');
    }

    final AccessToken? accessToken = result.accessToken;
    if (accessToken == null) {
      throw const AuthFailure('Missing Facebook access token.');
    }

    final OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _facebookAuth.logOut();
  }
}
