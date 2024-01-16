import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';

abstract class GameRepository {
  Stream<Either<Failure, List<GameModel>>> getGamesStream();

  Stream<Either<Failure, GameModel>> getGameStreamById({
    required String uid,
  });

  Future<Either<Failure, void>> createGame({
    required UserModel player,
  });

  Future<Either<Failure, void>> joinGame({
    required GameModel game,
    required UserModel player,
  });

  Future<Either<Failure, void>> makeMove({
    required GameModel game,
    required int index,
  });
}
