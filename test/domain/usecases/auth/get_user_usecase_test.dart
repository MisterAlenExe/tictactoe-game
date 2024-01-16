import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetUserUseCase getUserUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getUserUseCase = GetUserUseCase(authRepository: mockAuthRepository);
  });

  const user = UserModel(
    uid: 'test-uid',
    email: 'test-email',
  );

  test(
    'should get user',
    () async {
      // arrange
      when(
        () => mockAuthRepository.getUser(),
      ).thenAnswer(
        (_) => Stream.value(
          right<Failure, UserModel>(user),
        ),
      );

      // act
      final result = getUserUseCase.execute();

      // assert
      expect(
        result,
        emitsInOrder(
          [
            right<Failure, UserModel>(user),
          ],
        ),
      );
    },
  );
}
