import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_game/data/models/game_model.dart';
import 'package:tictactoe_game/data/models/user_model.dart';
import 'package:tictactoe_game/domain/entities/game.dart';

void main() {
  const testGameModel = GameModel(
    uid: 'uid',
    firstPlayer: UserModel(
      uid: 'test-player1-uid',
      email: 'test-player1-email',
    ),
    secondPlayer: UserModel(
      uid: 'test-player2-uid',
      email: 'test-player2-email',
    ),
    board: ['', '', '', '', '', '', '', '', ''],
    currentTurn: null,
    winner: null,
    status: GameStatus.waiting,
  );

  const expectedFirebaseMap = {
    'uid': 'uid',
    'firstPlayer': {
      'uid': 'test-player1-uid',
      'email': 'test-player1-email',
    },
    'secondPlayer': {
      'uid': 'test-player2-uid',
      'email': 'test-player2-email',
    },
    'currentTurn': null,
    'winner': null,
    'status': 'waiting',
    'board': ['', '', '', '', '', '', '', '', ''],
  };

  test("should be a subclass of Game entity", () async {
    expect(testGameModel, isA<GameModel>());
  });

  test(
    "should return a valid model from Firestore",
    () {
      // arrange
      final firestoreGame = {
        'uid': 'uid',
        'firstPlayer': {
          'uid': 'test-player1-uid',
          'email': 'test-player1-email',
        },
        'secondPlayer': {
          'uid': 'test-player2-uid',
          'email': 'test-player2-email',
        },
        'currentTurn': null,
        'winner': null,
        'status': 'waiting',
        'board': ['', '', '', '', '', '', '', '', ''],
      };

      // act
      final result = GameModel.fromJson(firestoreGame);

      // assert
      expect(result, testGameModel);
    },
  );

  test(
    "should return a valid model to Firestore",
    () {
      // act
      final result = testGameModel.toJson();

      // assert
      expect(result, expectedFirebaseMap);
    },
  );
}
