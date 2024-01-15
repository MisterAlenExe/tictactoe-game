import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/domain/usecases/auth/sign_up.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpUseCase signUpUseCase;

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
  });

  const email = "test@gmail.com";
  const password = "password";

  const user = UserModel(
    uid: "uid",
    email: "test@gmail.com",
  );

  test(
    'should sign up with email and password',
    () async {
      // arrange
      when(
        () => mockAuthRepository.signUp(
          email: email,
          password: password,
        ),
      ).thenAnswer(
        (_) async => const Right(user),
      );

      // act
      final result = await signUpUseCase.execute(
        email: email,
        password: password,
      );

      // assert
      expect(result, const Right(user));
    },
  );
}
