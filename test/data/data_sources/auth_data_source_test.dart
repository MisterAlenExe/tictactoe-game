import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/data/data_sources/auth_data_source.dart';
import 'package:tictactoe_game/data/models/user_model.dart';

import '../../utils/mocks/mocks.dart';

void main() {
  late AuthDataSourceImpl authDataSourceImpl;

  late MockFirebaseUserCredential mockUserCredential;
  late MockFirebaseUser mockUser;

  setUp(() {
    authDataSourceImpl = AuthDataSourceImpl(
      firebaseAuth: MockFirebaseAuth(),
      firebaseFirestore: MockFirebaseFirestore(),
    );

    mockUserCredential = MockFirebaseUserCredential();
    mockUser = MockFirebaseUser();
  });

  group("authDataSource", () {
    test("should return a user when the signIn is successful", () async {
      // arrange
      when(
        () => authDataSourceImpl.firebaseAuth.signInWithEmailAndPassword(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenAnswer(
        (_) async => mockUserCredential,
      );

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn("uid");
      when(() => mockUser.email).thenReturn("email");

      // act
      final result = await authDataSourceImpl.signIn(
        email: "email",
        password: "password",
      );

      // assert
      expect(
        result,
        const UserModel(
          uid: "uid",
          email: "email",
        ),
      );
    });

    test("should throw a FirebaseException when the signIn is unsuccessful",
        () async {
      // arrange
      when(
        () => authDataSourceImpl.firebaseAuth.signInWithEmailAndPassword(
          email: any(named: "email"),
          password: any(named: "password"),
        ),
      ).thenThrow(
        FirebaseException(
          plugin: "plugin",
          code: "code",
          message: "message",
        ),
      );

      // act
      final result = authDataSourceImpl.signIn(
        email: "email",
        password: "password",
      );

      // assert
      expect(
        result,
        throwsA(
          isA<FirebaseException>(),
        ),
      );
    });
  });
}
