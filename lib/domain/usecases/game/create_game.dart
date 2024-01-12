import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class CreateGameUseCase {
  final GameRepository gameRepository;

  CreateGameUseCase({required this.gameRepository});

  Future<Either<Failure, void>> execute({required UserEntity player}) {
    return gameRepository.createGame(player: player);
  }
}
