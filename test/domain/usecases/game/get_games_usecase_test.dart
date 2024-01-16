import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/get_games.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late GetGamesUseCase getGamesUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    getGamesUseCase = GetGamesUseCase(gameRepository: mockGameRepository);
  });

  const gamesList = [
    GameModel(
      uid: 'test-uid',
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
    ),
  ];

  test(
    'should get games list',
    () async {
      // arrange
      when(
        () => mockGameRepository.getGamesStream(),
      ).thenAnswer(
        (_) => Stream.value(
          right<Failure, List<GameModel>>(gamesList),
        ),
      );

      // act
      final result = getGamesUseCase.execute();

      // assert
      expect(
        result,
        emitsInOrder(
          [
            right<Failure, List<GameModel>>(gamesList),
          ],
        ),
      );
    },
  );
}
