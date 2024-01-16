import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';

class SessionProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  late final StreamSubscription<Either<Failure, UserModel>> _subscription;

  UserModel _user = const UserModel.empty();

  UserModel get user => _user;
  bool get isLoggedIn => !_user.isEmpty;

  SessionProvider({required this.authRepository}) {
    final result = authRepository.getUser();

    _subscription = result.listen(
      (event) {
        event.fold(
          (failure) => _user = const UserModel.empty(),
          (user) => _user = user,
        );
        notifyListeners();
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
