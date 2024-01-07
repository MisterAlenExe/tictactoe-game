import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String uid;
  final String? email;

  User({
    required this.uid,
    this.email,
  });

  bool get isEmpty => uid.isEmpty;

  factory User.empty() {
    return User(
      uid: '',
      email: '',
    );
  }

  factory User.fromFirestore(auth.User? firestore) {
    if (firestore == null) {
      return User.empty();
    }
    return User(
      uid: firestore.uid,
      email: firestore.email,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  @override
  String toString() => 'User(uid: $uid, email: $email)';
}
