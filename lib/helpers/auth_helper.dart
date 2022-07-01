import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user?.uid;
  }

  Future<String?> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user?.uid;
  }

  Future<User?> getCurrentUser() async {
    User user = _firebaseAuth.currentUser!;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
