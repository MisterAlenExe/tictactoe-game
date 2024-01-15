import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/data/models/game_model.dart';
import 'package:tictactoe_game/data/repositories/game_repository_impl.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/entities/user.dart';

import '../../utils/mocks/mocks.dart';

void main() {
  late MockGameDataSource mockGameDataSource;
  late GameRepositoryImpl gameRepositoryImpl;

  setUp(() {
    mockGameDataSource = MockGameDataSource();
    gameRepositoryImpl = GameRepositoryImpl(
      gameDataSource: mockGameDataSource,
    );
  });

  // TODO: add tests for getGamesStream and getGameStreamById

  group(
    'createGame',
    () {
      final gameEntity = GameEntity(
        uid: '',
        firstPlayer: const UserEntity(
          uid: 'test-uid',
          email: 'test@email.com',
        ),
        secondPlayer: const UserEntity.empty(),
        currentTurn: null,
        winner: null,
        status: GameStatus.waiting,
        board: List.generate(9, (index) => ''),
      );

      test(
        'should return void when the call to gameDataSource is successful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.createGame(
              game: GameModel.fromEntity(gameEntity),
            ),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.createGame(
            player: gameEntity.firstPlayer!,
          );

          // assert
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should return a FirestoreFailure when the call to gameDataSource is unsuccessful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.createGame(
              game: GameModel.fromEntity(gameEntity),
            ),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.createGame(
            player: gameEntity.firstPlayer!,
          );

          // assert
          expect(
            result,
            equals(
              const Left(
                FirestoreFailure(message: 'test'),
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'joinGame',
    () {
      GameEntity gameEntity = GameEntity(
        uid: '',
        firstPlayer: const UserEntity(
          uid: 'test-uid-1',
          email: 'test-email-1',
        ),
        secondPlayer: const UserEntity(
          uid: 'test-uid-2',
          email: 'test-email-2',
        ),
        currentTurn: 'test-uid-1',
        winner: null,
        status: GameStatus.playing,
        board: List.generate(9, (index) => ''),
      );
      const secondPlayer = UserEntity(
        uid: 'test-uid-2',
        email: 'test-email-2',
      );

      test(
        'should return void when the call to gameDataSource is successful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.updateGame(
              game: GameModel.fromEntity(gameEntity),
            ),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.joinGame(
            game: gameEntity,
            player: secondPlayer,
          );

          // assert
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should return a FirestoreFailure when the call to gameDataSource is unsuccessful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.updateGame(
              game: GameModel.fromEntity(gameEntity),
            ),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.joinGame(
            game: gameEntity,
            player: secondPlayer,
          );

          // assert
          expect(
            result,
            equals(
              const Left(
                FirestoreFailure(message: 'test'),
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'makeMove',
    () {
      const gameEntity = GameEntity(
        uid: '',
        firstPlayer: UserEntity(
          uid: 'test-uid-1',
          email: 'test-email-1',
        ),
        secondPlayer: UserEntity(
          uid: 'test-uid-2',
          email: 'test-email-2',
        ),
        currentTurn: 'test-uid-1',
        winner: null,
        status: GameStatus.playing,
        board: ['X', '', '', '', '', '', '', '', ''],
      );

      test(
        'should return void when the call to gameDataSource is successful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.updateGame(
              game: GameModel.fromEntity(
                gameEntity.copyWith(currentTurn: 'test-uid-2'),
              ),
            ),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.makeMove(
            game: gameEntity,
            index: 0,
          );

          // assert
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should return a FirestoreFailure when the call to gameDataSource is unsuccessful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.updateGame(
              game: GameModel.fromEntity(
                gameEntity.copyWith(currentTurn: 'test-uid-2'),
              ),
            ),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.makeMove(
            game: gameEntity,
            index: 0,
          );

          // assert
          expect(
            result,
            equals(
              const Left(
                FirestoreFailure(message: 'test'),
              ),
            ),
          );
        },
      );
    },
  );
}
