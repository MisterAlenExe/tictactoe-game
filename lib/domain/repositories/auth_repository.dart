import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';

abstract class AuthRepository {
  Stream<Either<Failure, UserModel>> getUser();

  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();
}
