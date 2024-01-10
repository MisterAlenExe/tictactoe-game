import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/usecases/auth/get_user.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetUserUseCase getUserUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getUserUseCase = GetUserUseCase(authRepository: mockAuthRepository);
  });

  final user = Stream.value(
    const UserEntity(
      uid: 'test-uid',
      email: 'test-email',
    ),
  );

  test(
    'should get user',
    () async {
      // arrange
      when(
        () => mockAuthRepository.getUser(),
      ).thenAnswer(
        (_) => Right(user),
      );

      // act
      final result = getUserUseCase.execute();

      // assert
      expect(result, Right(user));
    },
  );
}
