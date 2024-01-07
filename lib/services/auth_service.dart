import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tictactoe_game/models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map(User.fromFirestore);
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth.UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return User.fromFirestore(userCredential.user);
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth.UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(User.fromFirestore(userCredential.user!).toFirestore());
    return User.fromFirestore(userCredential.user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
