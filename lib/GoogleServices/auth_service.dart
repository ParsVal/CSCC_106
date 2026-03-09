import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _googleSignInInitialized = false;

  // correct named constructor
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;

    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }

  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: <String>['email'],
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;

    } on GoogleSignInException catch (e, st) {
      developer.log(
        'GoogleSignInException: code=${e.code} description=${e.description} details=${e.details}',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'FirebaseAuthException: code=${e.code} message=${e.message}',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      developer.log('Error: $e', name: 'AuthService', stackTrace: st);
      return null;
    }
  }

  Future<User?> registerWithEmailPassword(String email, String password, String? displayName) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (displayName != null && displayName.trim().isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName.trim());
        await userCredential.user?.reload();
      }

      final User? updatedUser = _auth.currentUser;

      developer.log(
        'Email registration success: ${updatedUser?.email} name=${updatedUser?.displayName}',
        name: 'AuthService',
      );

      return updatedUser;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'FirebaseAuthException (registration): code=${e.code} message=${e.message}',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      developer.log(
        'Error (registration): $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      developer.log(
        'Email login success: ${userCredential.user?.email}',
        name: 'AuthService',
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'FirebaseAuthException (email login): code=${e.code} message=${e.message}',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      developer.log(
        'Error (email login): $e',
        name: 'AuthService',
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> signOut() async {
    await _ensureGoogleSignInInitialized();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}