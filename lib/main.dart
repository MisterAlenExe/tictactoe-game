import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/firebase_options.dart';
import 'package:tictactoe_game/models/user_model.dart';
import 'package:tictactoe_game/presentation/pages/home_page.dart';
import 'package:tictactoe_game/presentation/pages/login_page.dart';
import 'package:tictactoe_game/presentation/pages/register_page.dart';
import 'package:tictactoe_game/presentation/pages/splash_page.dart';
import 'package:tictactoe_game/services/auth_service.dart';
import 'package:tictactoe_game/services/game_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<GameService>(
          create: (_) => GameService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().user,
          initialData: User.empty(),
        ),
      ],
      child: MaterialApp(
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
