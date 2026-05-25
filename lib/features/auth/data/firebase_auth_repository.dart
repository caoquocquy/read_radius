import 'package:read_radius/features/auth/domain/auth_failure.dart';
import 'package:read_radius/features/auth/domain/auth_repository.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
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
    final LoginResult result;
    try {
      result = await _facebookAuth.login(
        permissions: const ['public_profile'],
        loginTracking: LoginTracking.enabled,
      );
    } catch (_) {
      throw const AuthFailure(
        'Could not start Facebook sign in. Please try again.',
      );
    }

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

    final OAuthCredential credential = _buildFacebookCredential(accessToken);
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_mapFirebaseSignInError(error));
    } catch (_) {
      throw const AuthFailure(
        'Facebook sign in failed. Please try again in a moment.',
      );
    }
  }

  OAuthCredential _buildFacebookCredential(AccessToken accessToken) {
    if (accessToken.type == AccessTokenType.limited) {
      final LimitedToken limitedToken = accessToken as LimitedToken;
      return OAuthProvider('facebook.com').credential(
        idToken: limitedToken.tokenString,
        rawNonce: limitedToken.nonce,
      );
    }

    return FacebookAuthProvider.credential(accessToken.tokenString);
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _facebookAuth.logOut();
    } catch (_) {
      throw const AuthFailure('Sign out failed. Please try again.');
    }
  }

  String _mapFirebaseSignInError(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'This email is already linked to another sign-in method.';
      case 'invalid-credential':
      case 'invalid-oauth-credential':
      case 'invalid-verification-code':
        return 'Facebook credential is invalid. Please try signing in again.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support for help.';
      case 'operation-not-allowed':
        return 'Facebook login is not enabled in Firebase Auth settings.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again later.';
      default:
        return error.message ??
            'Authentication failed (${error.code}). Please try again.';
    }
  }
}
