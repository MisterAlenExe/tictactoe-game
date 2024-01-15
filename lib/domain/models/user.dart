import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String uid;
  final String email;

  const UserModel({
    required this.uid,
    required this.email,
  });

  const UserModel.empty()
      : uid = '',
        email = '';

  bool get isEmpty => uid.isEmpty || email.isEmpty;

  UserModel copyWith({
    String? uid,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirebaseUser(auth.User? user) {
    if (user == null) {
      return const UserModel.empty();
    }
    return UserModel(
      uid: user.uid,
      email: user.email!,
    );
  }

  @override
  List<Object?> get props => [uid, email];
}
