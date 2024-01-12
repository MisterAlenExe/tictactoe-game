import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;

  const UserEntity({
    required this.uid,
    required this.email,
  });

  const UserEntity.empty()
      : uid = '',
        email = '';

  bool get isEmpty => uid.isEmpty || email.isEmpty;

  @override
  List<Object?> get props => [uid, email];

  toJson() {}
}
