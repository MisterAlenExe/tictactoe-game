import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/make_move.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late MakeMoveUseCase makeMoveUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    makeMoveUseCase = MakeMoveUseCase(gameRepository: mockGameRepository);
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
    'should make move',
    () async {
      // arrange
      when(
        () => mockGameRepository.makeMove(
          game: game,
          index: 0,
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final result = await makeMoveUseCase.execute(
        game: game,
        index: 0,
      );

      // assert
      expect(result, const Right(null));
    },
  );
}
