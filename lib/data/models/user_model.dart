import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tictactoe_game/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
  }) : super(uid: uid, email: email);

  factory UserModel.fromFirebase(auth.User? firebaseUser) {
    return UserModel(
      uid: firebaseUser?.uid ?? '',
      email: firebaseUser?.email ?? '',
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
    );
  }
}
