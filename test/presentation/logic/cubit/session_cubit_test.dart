import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/entities/user.dart';
import 'package:tictactoe_game/features/auth/logic/session_cubit/session_cubit.dart';

import '../../../utils/mocks/mocks.dart';

void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late SessionCubit sessionCubit;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    sessionCubit = SessionCubit(
      getUserUseCase: mockGetUserUseCase,
      signOutUseCase: mockSignOutUseCase,
    );
  });

  const userEntity = UserEntity(
    uid: 'test-uid',
    email: 'test@email.com',
  );

  test(
    'Initial state should be UnknownSessionState',
    () {
      expect(sessionCubit.state, equals(UnknownSessionState()));
    },
  );

  group(
    'GetUser event',
    () {
      blocTest<SessionCubit, SessionState>(
        'emits [AuthenticatedSessionState] when GetUserEvent is added',
        build: () {
          when(() => mockGetUserUseCase.execute()).thenAnswer(
            (_) => Right(Stream.value(userEntity)),
          );
          return sessionCubit;
        },
        act: (cubit) => cubit.fetchUser(),
        expect: () => [
          const Authenticated(user: userEntity),
        ],
      );

      blocTest<SessionCubit, SessionState>(
        'emits [UnauthenticatedSessionState] when GetUserEvent is added',
        build: () {
          when(() => mockGetUserUseCase.execute()).thenAnswer(
            (_) => Right(Stream.value(const UserEntity.empty())),
          );
          return sessionCubit;
        },
        act: (cubit) => cubit.fetchUser(),
        expect: () => [
          Unauthenticated(),
        ],
      );
    },
  );

  group(
    'SignOut event',
    () {
      blocTest<SessionCubit, SessionState>(
        'emits [UnauthenticatedSessionState] when SignOutEvent is added',
        build: () {
          when(() => mockSignOutUseCase.execute()).thenAnswer(
            (_) async => const Right(null),
          );
          return sessionCubit;
        },
        act: (cubit) => cubit.signOut(),
        expect: () => [
          Unauthenticated(),
        ],
      );

      blocTest<SessionCubit, SessionState>(
        'emits [AuthenticatedSessionState] when SignOutEvent is added and fails',
        build: () {
          when(() => mockSignOutUseCase.execute()).thenAnswer(
            (_) async => const Left(AuthFailure(message: 'error')),
          );
          return sessionCubit;
        },
        act: (cubit) => cubit.signOut(),
        expect: () => [
          Unauthenticated(),
        ],
      );
    },
  );
}
