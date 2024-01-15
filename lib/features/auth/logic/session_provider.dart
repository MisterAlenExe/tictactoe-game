import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';

class SessionProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  late final StreamSubscription<UserModel> _subscription;

  UserModel _user = const UserModel.empty();

  UserModel get user => _user;
  bool get isLoggedIn => !_user.isEmpty;

  SessionProvider({required this.authRepository}) {
    authRepository.getUser().fold(
      (failure) {
        _user = const UserModel.empty();
        notifyListeners();
      },
      (userStream) {
        _subscription = userStream.listen(
          (user) {
            if (user.isEmpty) {
              _user = const UserModel.empty();
            } else {
              _user = user;
            }
            notifyListeners();
          },
        );
      },
    );
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
