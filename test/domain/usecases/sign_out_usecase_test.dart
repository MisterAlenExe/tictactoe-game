import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/domain/usecases/sign_out.dart';

import '../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignOutUseCase signInUseCase;

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignOutUseCase(authRepository: mockAuthRepository);
  });

  test(
    'should sign out',
    () async {
      // arrange
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final result = await signInUseCase.execute();

      // assert
      expect(result, const Right(null));
    },
  );
}
