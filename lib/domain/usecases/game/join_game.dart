import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class JoinGameUseCase {
  final GameRepository gameRepository;

  JoinGameUseCase({required this.gameRepository});

  Future<Either<Failure, void>> execute({
    required GameModel game,
    required UserModel player,
  }) {
    return gameRepository.joinGame(game: game, player: player);
  }
}
