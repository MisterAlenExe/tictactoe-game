import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/entities/user.dart';

abstract class GameRepository {
  Either<Failure, Stream<List<GameEntity>>> getGamesStream();

  Either<Failure, Stream<GameEntity>> getGameStreamById({
    required String uid,
  });

  Future<Either<Failure, void>> createGame({
    required UserEntity player,
  });

  Future<Either<Failure, void>> joinGame({
    required GameEntity game,
    required UserEntity player,
  });

  Future<Either<Failure, void>> makeMove({
    required GameEntity game,
    required int index,
  });
}
