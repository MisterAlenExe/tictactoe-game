import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_game/core/constants/strings.dart';
import 'package:tictactoe_game/features/auth/logic/session_cubit/session_cubit.dart';
import 'package:tictactoe_game/features/auth/screens/authorization_screen.dart';
import 'package:tictactoe_game/features/game/screens/home_screen.dart';

class AuthNavigator extends StatelessWidget {
  static const routeName = '/authNav';

  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Navigator(
          key: navigatorKey,
          pages: [
            if (state is Authenticated)
              const MaterialPage(
                child: HomeScreen(),
              ),
            if (state is Unauthenticated)
              const MaterialPage(
                child: AuthorizationScreen(),
              ),
            if (state is UnknownSessionState)
              const MaterialPage(
                child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AuthorizationScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => const AuthorizationScreen(),
                );
              case HomeScreen.routeName:
                return MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}
