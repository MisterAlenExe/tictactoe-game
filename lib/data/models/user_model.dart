import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tictactoe_game/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
  }) : super(uid: uid, email: email);

  factory UserModel.fromFirebaseUser(auth.User? firebaseUser) {
    return UserModel(
      uid: firebaseUser?.uid ?? '',
      email: firebaseUser?.email ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
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

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      uid: userEntity.uid,
      email: userEntity.email,
    );
  }
}
