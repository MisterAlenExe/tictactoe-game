import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/models/user_model.dart';
import 'package:tictactoe_game/presentation/pages/home_page.dart';
import 'package:tictactoe_game/presentation/pages/login_page.dart';
import 'package:tictactoe_game/services/auth_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: authService.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final User user = snapshot.data!;

              return user.isEmpty ? const LoginPage() : const HomePage();
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
