import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../local_storage/local_storage_repository.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(
      {required String username,
      required String email,
      required String password}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);

    try {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(email: email, password: password);
        userCredential.user!.sendEmailVerification();
        await LocalStorageShared.instance.setString("X-Firebase-Auth", await FirebaseAuth.instanceFor(app: app).currentUser!.getIdToken(true));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw Exception('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          throw Exception('The account already exists for that email.');
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      Timer(const Duration(seconds: 2), () {
        app.delete();
      });
    }
  }

  Future<bool> currentStatus() async {

    bool hasValidToken =  FirebaseAuth.instance.currentUser != null ? true : false;

    return hasValidToken;
  }

  Future<void> refreshToken() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken(true);

    await LocalStorageShared.instance.setString("X-Firebase-Auth", token);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
       await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
