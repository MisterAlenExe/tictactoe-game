import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class MakeMoveUseCase {
  final GameRepository gameRepository;

  MakeMoveUseCase({required this.gameRepository});

  Future<Either<Failure, void>> execute({
    required GameEntity game,
    required int index,
  }) {
    return gameRepository.makeMove(game: game, index: index);
  }
}
