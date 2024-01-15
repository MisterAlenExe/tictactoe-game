import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    authBloc = AuthBloc(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
    );
  });

  const email = 'test@email.com';
  const password = 'test!password';

  const userEntity = UserModel(
    uid: 'test-uid',
    email: 'test@email.com',
  );

  const errorCode = 'ERROR_MESSAGE';

  test(
    'Initial state should be AuthInitial',
    () {
      expect(authBloc.state, equals(const AuthInitial()));
    },
  );

  group(
    'SignIn event',
    () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when SignInEvent is added',
        build: () {
          when(() => mockSignInUseCase.execute(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Right(userEntity),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignInEvent(
            email: email,
            password: password,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => const <AuthState>[
          AuthLoading(),
          AuthSuccess(user: userEntity),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when SignInEvent is added and fails',
        build: () {
          when(() => mockSignInUseCase.execute(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Left(
              AuthFailure(message: errorCode),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignInEvent(
            email: email,
            password: password,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => const <AuthState>[
          AuthLoading(),
          AuthError(message: errorCode),
        ],
      );
    },
  );

  group(
    'SignUp event',
    () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when SignUpEvent is added',
        build: () {
          when(() => mockSignUpUseCase.execute(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Right(userEntity),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignUpEvent(
            email: email,
            password: password,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => const <AuthState>[
          AuthLoading(),
          AuthSuccess(user: userEntity),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when SignUpEvent is added and fails',
        build: () {
          when(() => mockSignUpUseCase.execute(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Left(
              AuthFailure(message: errorCode),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignUpEvent(
            email: email,
            password: password,
          ),
        ),
        wait: const Duration(milliseconds: 500),
        expect: () => const <AuthState>[
          AuthLoading(),
          AuthError(message: errorCode),
        ],
      );
    },
  );
}
