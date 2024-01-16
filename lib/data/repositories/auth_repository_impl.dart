import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/data/data_sources/auth_data_source.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Stream<Either<Failure, UserModel>> getUser() async* {
    try {
      yield* authDataSource.getUser().map(
            (user) => right<Failure, UserModel>(user),
          );
    } on FirebaseAuthException catch (e) {
      yield left<Failure, UserModel>(
        AuthFailure(message: e.message ?? ''),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authDataSource.signUp(
        email: email,
        password: password,
      );
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? ''));
    }
  }
}
