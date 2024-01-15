import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/data/repositories/game_repository_impl.dart';
import 'package:tictactoe_game/domain/models/user.dart';

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
      final gameModel = GameModel(
        uid: '',
        firstPlayer: const UserModel(
          uid: 'test-uid',
          email: 'test@email.com',
        ),
        secondPlayer: const UserModel.empty(),
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
              game: gameModel,
            ),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.createGame(
            player: gameModel.firstPlayer!,
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
              game: gameModel,
            ),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.createGame(
            player: gameModel.firstPlayer!,
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
      GameModel gameModel = GameModel(
        uid: '',
        firstPlayer: const UserModel(
          uid: 'test-uid-1',
          email: 'test-email-1',
        ),
        secondPlayer: const UserModel(
          uid: 'test-uid-2',
          email: 'test-email-2',
        ),
        currentTurn: 'test-uid-1',
        winner: null,
        status: GameStatus.playing,
        board: List.generate(9, (index) => ''),
      );
      const secondPlayer = UserModel(
        uid: 'test-uid-2',
        email: 'test-email-2',
      );

      test(
        'should return void when the call to gameDataSource is successful',
        () async {
          // arrange
          when(
            () => mockGameDataSource.updateGame(game: gameModel),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.joinGame(
            game: gameModel,
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
            () => mockGameDataSource.updateGame(game: gameModel),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.joinGame(
            game: gameModel,
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
      const gameModel = GameModel(
        uid: '',
        firstPlayer: UserModel(
          uid: 'test-uid-1',
          email: 'test-email-1',
        ),
        secondPlayer: UserModel(
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
              game: gameModel.copyWith(currentTurn: 'test-uid-2'),
            ),
          ).thenAnswer(
            (_) async => Future.value(),
          );

          // act
          final result = await gameRepositoryImpl.makeMove(
            game: gameModel,
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
              game: gameModel.copyWith(currentTurn: 'test-uid-2'),
            ),
          ).thenThrow(FirebaseException(
            plugin: 'test',
            message: 'test',
            code: 'test',
          ));

          // act
          final result = await gameRepositoryImpl.makeMove(
            game: gameModel,
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
