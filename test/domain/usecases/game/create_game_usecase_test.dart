import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/game/create_game.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGameRepository mockGameRepository;
  late CreateGameUseCase createGameUseCase;

  setUp(() {
    mockGameRepository = MockGameRepository();
    createGameUseCase = CreateGameUseCase(gameRepository: mockGameRepository);
  });

  const player = UserModel(
    uid: 'test-uid',
    email: 'test@email.com',
  );

  test(
    'should create game',
    () async {
      // arrange
      when(
        () => mockGameRepository.createGame(player: player),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final result = await createGameUseCase.execute(player: player);

      // assert
      expect(result, const Right(null));
    },
  );
}
