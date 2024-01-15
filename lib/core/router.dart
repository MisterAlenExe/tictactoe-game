import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_game/core/constants/routes.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/auth/screens/authorization_screen.dart';
import 'package:tictactoe_game/features/game/logic/games_bloc/game_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_provider.dart';
import 'package:tictactoe_game/features/game/screens/game_screen.dart';
import 'package:tictactoe_game/features/game/screens/home_screen.dart';
import 'package:tictactoe_game/injection_container.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Routes.homeNamedPage,
    navigatorKey: _rootNavigatorKey,
    routes: <GoRoute>[
      GoRoute(
        path: Routes.authNamedPage,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider<AuthBloc>(
            create: (context) => locator<AuthBloc>(),
            child: const AuthorizationScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.homeNamedPage,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider<GameBloc>(
            create: (_) => locator<GameBloc>(),
            child: const HomeScreen(),
          ),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: Routes.homeGameNamedPage,
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider<GameBloc>(
                create: (_) => locator<GameBloc>(),
                child: GameScreen(
                  gameUid: state.pathParameters['uid']!,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Routes.errorWidget(context, state),
    refreshListenable: locator<SessionProvider>(),
    redirect: (context, state) {
      final bool isLoggedIn = context.read<SessionProvider>().isLoggedIn;
      final bool isAuthScreen = state.matchedLocation == Routes.authNamedPage;

      if (isLoggedIn && isAuthScreen) {
        return Routes.homeNamedPage;
      } else if (!isLoggedIn && !isAuthScreen) {
        return Routes.authNamedPage;
      }

      return null;
    },
  );

  static GoRouter get router => _router;
}
