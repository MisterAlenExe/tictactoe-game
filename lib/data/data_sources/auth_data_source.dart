import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tictactoe_game/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
  Future<UserModel> signUp({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Stream<UserModel> getUser();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firebaseFirestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(UserModel.fromFirebaseUser(userCredential.user!).toJson());
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserModel> getUser() {
    return firebaseAuth.authStateChanges().map(UserModel.fromFirebaseUser);
  }
}
