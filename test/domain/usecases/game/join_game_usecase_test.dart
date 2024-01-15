import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/models/game.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/join_game.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late JoinGameUseCase joinGameUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    joinGameUseCase = JoinGameUseCase(gameRepository: mockGameRepository);
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

  const player = UserModel(
    uid: 'test-player2-uid',
    email: 'test-player2-email',
  );

  test(
    'should join game',
    () async {
      // arrange
      when(
        () => mockGameRepository.joinGame(
          game: game,
          player: player,
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final result = await joinGameUseCase.execute(
        game: game,
        player: player,
      );

      // assert
      expect(result, const Right(null));
    },
  );
}
