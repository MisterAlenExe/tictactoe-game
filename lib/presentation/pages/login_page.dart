import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/presentation/widgets/custom_button.dart';
import 'package:tictactoe_game/presentation/widgets/custom_text_button.dart';
import 'package:tictactoe_game/presentation/widgets/custom_text_field.dart';
import 'package:tictactoe_game/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'Please login to continue',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              _buildForm(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () async {
                  try {
                    await authService.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                text: 'Login',
              ),
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              text: 'Don\'t have an account? Register',
            ),
          ],
        ),
      ),
    );
  }
}
