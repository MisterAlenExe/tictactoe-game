import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/domain/usecases/sign_in.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInUseCase signInUseCase;

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(authRepository: mockAuthRepository);
  });

  const email = "test@email.com";
  const password = "test!password";

  const user = UserEntity(
    uid: "test-uid",
    email: "test@email.com",
  );

  test(
    'should sign up with email and password',
    () async {
      // arrange
      when(
        () => mockAuthRepository.signIn(
          email: email,
          password: password,
        ),
      ).thenAnswer(
        (_) async => const Right(user),
      );

      // act
      final result = await signInUseCase.execute(
        email: email,
        password: password,
      );

      // assert
      expect(result, const Right(user));
    },
  );
}
