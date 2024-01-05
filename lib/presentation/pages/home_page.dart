import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/presentation/widgets/custom_button.dart';
import 'package:tictactoe_game/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to Tic Tac Toe',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  await authService.signOut();
                },
                text: 'Logout',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
