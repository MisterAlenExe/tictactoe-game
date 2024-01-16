import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/get_game_by_id.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late GetGameByIdUseCase getGameByIdUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    getGameByIdUseCase = GetGameByIdUseCase(gameRepository: mockGameRepository);
  });

  const game = GameModel(
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
  );

  test(
    'should get game by id',
    () async {
      // arrange
      when(
        () => mockGameRepository.getGameStreamById(uid: 'test-uid'),
      ).thenAnswer(
        (_) => Stream.value(
          right<Failure, GameModel>(game),
        ),
      );

      // act
      final result = getGameByIdUseCase.execute(uid: 'test-uid');

      // assert
      expect(
        result,
        emitsInOrder(
          [
            right<Failure, GameModel>(game),
          ],
        ),
      );
    },
  );
}
