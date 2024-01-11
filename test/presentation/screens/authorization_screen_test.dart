import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/auth/screens/authorization_screen.dart';
import 'package:tictactoe_game/features/global/widgets/custom_button.dart';
import 'package:tictactoe_game/features/global/widgets/custom_text_button.dart';
import 'package:tictactoe_game/features/global/widgets/custom_text_field.dart';
import 'package:tictactoe_game/features/global/widgets/loading_indicator.dart';

import '../../utils/mocks/mocks.dart';
import '../../utils/test_material_app.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
  });

  Widget makeTestableWidget() {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: const TestMaterialApp(
        child: AuthorizationScreen(),
      ),
    );
  }

  group(
    'AuthorizationScreen',
    () {
      testWidgets(
        'renders correctly',
        (tester) async {
          // act
          await tester.pumpWidget(makeTestableWidget());

          // assert
          expect(find.byType(CustomTextField), findsNWidgets(2));
          expect(find.byType(CustomTextButton), findsOneWidget);
        },
      );

      testWidgets(
        'toggles between login and register forms',
        (tester) async {
          // act
          await tester.pumpWidget(makeTestableWidget());
          await tester.pump();
          await tester.tap(find.byType(CustomTextButton));
          await tester.pump();

          // assert
          expect(find.byType(CustomTextField), findsNWidgets(3));
          expect(find.byType(CustomTextButton), findsOneWidget);
        },
      );

      testWidgets(
        'shows failure snackbar when AuthError is emitted',
        (tester) async {
          // arrange
          whenListen(
            mockAuthBloc,
            Stream.fromIterable(
              [
                const AuthError(message: 'ERROR_MESSAGE'),
              ],
            ),
          );
          final snackbar = find.byKey(const Key('auth_error_snackbar'));

          // act
          await tester.pumpWidget(makeTestableWidget());
          await tester.pump();

          // assert
          expect(snackbar, findsOneWidget);
        },
      );

      testWidgets(
        'draws a loading indicator when button is pressed',
        (tester) async {
          // arrange
          when(() => mockAuthBloc.state).thenReturn(const AuthLoading());
          final loadingIndicator = find.byType(LoadingIndicator);

          // act
          await tester.pumpWidget(makeTestableWidget());
          await tester.tap(find.byType(CustomButton));
          await tester.pump();

          // assert
          expect(loadingIndicator, findsOneWidget);
        },
      );
    },
  );
}
