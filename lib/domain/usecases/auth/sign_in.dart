import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<Either<Failure, UserModel>> execute({
    required String email,
    required String password,
  }) async {
    return await authRepository.signIn(
      email: email,
      password: password,
    );
  }
}
