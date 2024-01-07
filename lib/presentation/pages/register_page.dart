import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe_game/presentation/widgets/custom_button.dart';
import 'package:tictactoe_game/presentation/widgets/custom_text_button.dart';
import 'package:tictactoe_game/presentation/widgets/custom_text_field.dart';
import 'package:tictactoe_game/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                'Please register to continue',
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
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () async {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Password and Confirm Password do not match'),
                      ),
                    );
                    return;
                  }

                  try {
                    await authService
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    )
                        .then((user) {
                      if (user.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error registering user',
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/login');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'User registered successfully. Please login',
                            ),
                          ),
                        );
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                text: 'Register',
              ),
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              text: 'Already have an account? Login',
            ),
          ],
        ),
      ),
    );
  }
}
