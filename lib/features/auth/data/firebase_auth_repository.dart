import 'dart:convert';
import 'dart:math';

import 'package:read_radius/features/auth/domain/auth_failure.dart';
import 'package:read_radius/features/auth/domain/auth_repository.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  Stream<String?> userPhotoUrlChanges() {
    return _firebaseAuth.userChanges().map((user) => user?.photoURL);
  }

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<void> signInWithFacebook() async {
    final String rawNonce = _generateRawNonce();
    final String loginNonce = _sha256OfString(rawNonce);

    final LoginResult result;
    try {
      result = await _facebookAuth.login(
        permissions: const ['public_profile'],
        loginTracking: LoginTracking.enabled,
        nonce: loginNonce,
      );
    } catch (error, stackTrace) {
      debugPrint('Facebook login start failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      throw const AuthFailure(
        'Could not start Facebook sign in. Please try again.',
      );
    }

    debugPrint('Facebook login status: ${result.status}');

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

    try {
      await _signInWithFirebaseFacebookCredential(accessToken, rawNonce);
      await _syncProfilePhotoFromFacebook();
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'Firebase Facebook sign-in failed [${error.code}]: ${error.message}',
      );
      throw AuthFailure(_mapFirebaseSignInError(error));
    } catch (error, stackTrace) {
      debugPrint('Facebook sign-in unexpected failure: $error');
      debugPrintStack(stackTrace: stackTrace);
      throw const AuthFailure(
        'Facebook sign in failed. Please try again in a moment.',
      );
    }
  }

  Future<void> _signInWithFirebaseFacebookCredential(
    AccessToken accessToken,
    String rawNonce,
  ) async {
    final OAuthCredential credential = _buildFacebookCredential(
      accessToken,
      rawNonce,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  OAuthCredential _buildFacebookCredential(
    AccessToken accessToken,
    String rawNonce,
  ) {
    if (accessToken.type == AccessTokenType.limited) {
      final LimitedToken limitedToken = accessToken as LimitedToken;
      return OAuthProvider(
        'facebook.com',
      ).credential(idToken: limitedToken.tokenString, rawNonce: rawNonce);
    }

    return FacebookAuthProvider.credential(accessToken.tokenString);
  }

  String _generateRawNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _syncProfilePhotoFromFacebook() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }

    final Map<String, dynamic> data;
    try {
      data = await _facebookAuth.getUserData(fields: 'picture.width(200)');
    } catch (_) {
      return;
    }

    final Object? picture = data['picture'];
    if (picture is! Map<String, dynamic>) {
      return;
    }

    final Object? pictureData = picture['data'];
    if (pictureData is! Map<String, dynamic>) {
      return;
    }

    final Object? urlValue = pictureData['url'];
    if (urlValue is! String || urlValue.trim().isEmpty) {
      return;
    }

    final String photoUrl = urlValue.trim();
    if (user.photoURL == photoUrl) {
      return;
    }

    await user.updatePhotoURL(photoUrl);
    await user.reload();
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
      case 'missing-or-invalid-nonce':
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
