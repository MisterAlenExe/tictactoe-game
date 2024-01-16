import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class GetGamesUseCase {
  final GameRepository gameRepository;

  GetGamesUseCase({required this.gameRepository});

  Stream<Either<Failure, List<GameModel>>> execute() {
    return gameRepository.getGamesStream();
  }
}
