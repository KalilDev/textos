import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future<void> logout() async {
    final void result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  // wrapping the firebase calls
  Future<void> createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty)
      throw Exception('Preencha todos os campos');

    final FirebaseUser u = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final UserUpdateInfo info = UserUpdateInfo();
    info.displayName = '$firstName $lastName';
    return await u.updateProfile(info);
  }

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<FirebaseUser> loginUser({String email, String password}) async {
    if (email.isEmpty || password.isEmpty)
      throw Exception('Preencha todos os campos');

    try {
      final FirebaseUser result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result;
    } catch (e) {
      throw AuthException(e.code, e.message);
    }
  }

  Future<FirebaseUser> anonymouslyLogin() async {
    try {
      final FirebaseUser result =
          await FirebaseAuth.instance.signInAnonymously();
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result;
    } catch (e) {
      throw AuthException(e.code, e.message);
    }
  }

  Future<FirebaseUser> googleLogin() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser result = await _auth.signInWithCredential(credential);
      notifyListeners();
      return result;
    } catch (e) {
      throw AuthException(e.code, e.message);
    }
  }
}
