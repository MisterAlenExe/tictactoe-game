import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/data/models/user_model.dart';

import '../../mocks/mocks.dart';

void main() {
  const testUserModel = UserModel(
    uid: 'uid',
    email: 'email',
  );
  const expectedFirebaseMap = {
    'uid': 'uid',
    'email': 'email',
  };

  test("should be a subclass of User entity", () async {
    expect(testUserModel, isA<UserModel>());
  });

  test(
    "should return a valid model from Firestore",
    () {
      // arrange
      final firestoreUser = MockFirebaseUser();
      when(() => firestoreUser.uid).thenReturn('uid');
      when(() => firestoreUser.email).thenReturn('email');

      // act
      final result = UserModel.fromFirebase(firestoreUser);

      // assert
      expect(result, testUserModel);
    },
  );

  test(
    "should return a valid model to Firestore",
    () {
      // act
      final result = testUserModel.toFirebase();

      // assert
      expect(result, expectedFirebaseMap);
    },
  );
}
