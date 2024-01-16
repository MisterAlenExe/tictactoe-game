import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/core/error/failure.dart';
import 'package:tictactoe_game/domain/models/user.dart';
import 'package:tictactoe_game/data/repositories/auth_repository_impl.dart';

import '../../utils/mocks/mocks.dart';

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    authRepositoryImpl = AuthRepositoryImpl(
      authDataSource: mockAuthDataSource,
    );
  });

  const email = 'test@email.com';
  const password = 'test!password';

  const userModel = UserModel(
    uid: 'test-uid',
    email: email,
  );

  const errorCode = 'fdafafdafadf';

  group('getUser', () {
    test(
      'should return user when the call to authDataSource is successful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.getUser(),
        ).thenAnswer(
          (_) => Stream.value(userModel),
        );

        // act
        final result = authRepositoryImpl.getUser();

        // assert
        expect(
          result,
          emitsInOrder(
            [
              const Right(userModel),
            ],
          ),
        );
      },
    );

    test(
      'should return AuthFailure when the call to authDataSource is unsuccessful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.getUser(),
        ).thenThrow(
          FirebaseAuthException(
            message: errorCode,
            code: errorCode,
          ),
        );

        // act
        final result = authRepositoryImpl.getUser();

        // assert
        expect(
          result,
          emitsInOrder(
            [
              const Left(AuthFailure(message: errorCode)),
            ],
          ),
        );
      },
    );
  });

  group('signIn', () {
    test(
      'should return user when the call to authDataSource is successful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userModel);

        // act
        final result = await authRepositoryImpl.signIn(
          email: email,
          password: password,
        );

        // assert
        expect(result, equals(const Right(userModel)));
      },
    );

    test(
      'should return AuthFailure when the call to authDataSource is unsuccessful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(
          message: errorCode,
          code: errorCode,
        ));

        // act
        final result = await authRepositoryImpl.signIn(
          email: email,
          password: password,
        );

        // assert
        expect(
          result,
          equals(const Left(AuthFailure(message: errorCode))),
        );
      },
    );
  });

  group('signUp', () {
    test(
      'should return user when the call to authDataSource is successful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userModel);

        // act
        final result = await authRepositoryImpl.signUp(
          email: email,
          password: password,
        );

        // assert
        expect(result, equals(const Right(userModel)));
      },
    );

    test(
      'should return AuthFailure when the call to authDataSource is unsuccessful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(
          message: errorCode,
          code: errorCode,
        ));

        // act
        final result = await authRepositoryImpl.signUp(
          email: email,
          password: password,
        );

        // assert
        expect(
          result,
          equals(const Left(AuthFailure(message: errorCode))),
        );
      },
    );
  });

  group('signOut', () {
    test(
      'should return null when the call to authDataSource is successful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signOut(),
        ).thenAnswer((_) async {});

        // act
        final result = await authRepositoryImpl.signOut();

        // assert
        expect(result, equals(const Right(null)));
      },
    );

    test(
      'should return AuthFailure when the call to authDataSource is unsuccessful',
      () async {
        // arrange
        when(
          () => mockAuthDataSource.signOut(),
        ).thenThrow(FirebaseAuthException(
          message: errorCode,
          code: errorCode,
        ));

        // act
        final result = await authRepositoryImpl.signOut();

        // assert
        expect(
          result,
          equals(const Left(AuthFailure(message: errorCode))),
        );
      },
    );
  });
}
