import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/core/utils.dart';
import 'package:tictactoe_game/data/data_sources/game_data_source.dart';
import 'package:tictactoe_game/data/models/game_model.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/repositories/game_repository.dart';

class GameRepositoryImpl extends GameRepository {
  final GameDataSource gameDataSource;

  GameRepositoryImpl({required this.gameDataSource});

  @override
  Either<Failure, Stream<List<GameEntity>>> getGamesStream() {
    try {
      final result = gameDataSource.getGames();
      return Right(
        result.map(
          (event) => event.map((e) => e.toEntity()).toList(),
        ),
      );
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    }
  }

  @override
  Either<Failure, Stream<GameEntity>> getGameStreamById({
    required String uid,
  }) {
    try {
      final result = gameDataSource.getGameById(uid: uid);
      return Right(result.map((event) => event.toEntity()));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> createGame({
    required UserEntity player,
  }) async {
    try {
      final GameEntity game = GameEntity(
        uid: '',
        firstPlayer: player,
        secondPlayer: const UserEntity.empty(),
        currentTurn: null,
        winner: null,
        status: GameStatus.waiting,
        board: List.generate(9, (index) => ''),
      );

      await gameDataSource.createGame(game: GameModel.fromEntity(game));

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> joinGame({
    required GameEntity game,
    required UserEntity player,
  }) async {
    try {
      final updatedGame = game.copyWith(
        secondPlayer: player,
        currentTurn: game.firstPlayer!.uid,
        status: GameStatus.playing,
      );

      gameDataSource.updateGame(game: GameModel.fromEntity(updatedGame));

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> makeMove({
    required GameEntity game,
    required int index,
  }) async {
    try {
      List<String> boardData = List.generate(9, (i) {
        if (i == index) {
          return game.firstPlayer!.uid == game.currentTurn ? 'X' : 'O';
        } else {
          return game.board[i];
        }
      });
      final updatedGame = game.copyWith(
        currentTurn: game.firstPlayer!.uid == game.currentTurn
            ? game.secondPlayer!.uid
            : game.firstPlayer!.uid,
        board: boardData,
      );

      await gameDataSource.updateGame(game: GameModel.fromEntity(updatedGame));

      bool winner = checkWinner(boardData);
      if (winner) {
        await gameDataSource.updateGame(
          game: GameModel.fromEntity(
            updatedGame.copyWith(
              winner: game.firstPlayer!.uid == game.currentTurn
                  ? game.secondPlayer!.uid
                  : game.firstPlayer!.uid,
              status: GameStatus.finished,
            ),
          ),
        );
      }

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    }
  }
}
