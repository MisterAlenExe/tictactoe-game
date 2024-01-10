import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_game/firebase_options.dart';
import 'package:tictactoe_game/injection_container.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/session_cubit/session_cubit.dart';
import 'package:tictactoe_game/features/game/screens/home_screen.dart';
import 'package:tictactoe_game/features/nav/auth_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>(
          create: (_) => locator<SessionCubit>()..fetchUser(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AuthNavigator.routeName,
        routes: {
          AuthNavigator.routeName: (_) => const AuthNavigator(),
          HomeScreen.routeName: (_) => const HomeScreen(),
        },
      ),
    );
  }
}
