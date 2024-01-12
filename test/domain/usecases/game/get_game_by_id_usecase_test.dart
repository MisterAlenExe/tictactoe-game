import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/entities/game.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/usecases/game/get_game_by_id.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late GetGameByIdUseCase getGameByIdUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    getGameByIdUseCase = GetGameByIdUseCase(gameRepository: mockGameRepository);
  });

  final game = Stream.value(
    const GameEntity(
      uid: 'test-uid',
      firstPlayer: UserEntity(
        uid: 'test-player1-uid',
        email: 'test-player1-email',
      ),
      secondPlayer: UserEntity(
        uid: 'test-player2-uid',
        email: 'test-player2-email',
      ),
      board: ['', '', '', '', '', '', '', '', ''],
      currentTurn: null,
      winner: null,
      status: GameStatus.waiting,
    ),
  );

  test(
    'should get game by id',
    () async {
      // arrange
      when(
        () => mockGameRepository.getGameStreamById(uid: 'test-uid'),
      ).thenAnswer(
        (_) => Right(game),
      );

      // act
      final result = getGameByIdUseCase.execute(uid: 'test-uid');

      // assert
      expect(result, Right(game));
    },
  );
}
