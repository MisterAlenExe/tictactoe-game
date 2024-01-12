import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class GetGamesUseCase {
  final GameRepository gameRepository;

  GetGamesUseCase({required this.gameRepository});

  Either<Failure, Stream<List<GameEntity>>> execute() {
    return gameRepository.getGamesStream();
  }
}
