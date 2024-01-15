import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository authRepository;

  GetUserUseCase({required this.authRepository});

  Either<Failure, Stream<UserModel>> execute() {
    return authRepository.getUser();
  }
}
