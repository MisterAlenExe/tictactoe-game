import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_game/features/auth/logic/auth_bloc/auth_bloc.dart';
import 'package:tictactoe_game/features/global/widgets/custom_button.dart';
import 'package:tictactoe_game/features/global/widgets/custom_text_button.dart';
import 'package:tictactoe_game/features/global/widgets/custom_text_field.dart';

class AuthorizationScreen extends StatefulWidget {
  static const routeName = '/authorization';

  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AuthError) {
          setState(() {
            _isButtonEnabled = true;
          });

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                key: const Key('auth_error_snackbar'),
                content: Text(state.message),
              ),
            );
        }
      },
      child: Scaffold(
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
                _isLogin
                    ? _buildLoginForm(context)
                    : _buildRegisterForm(context),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            const Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _loginEmailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _loginPasswordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  setState(() {
                    _isButtonEnabled = false;
                  });

                  context.read<AuthBloc>().add(
                        SignInEvent(
                          email: _loginEmailController.text,
                          password: _loginPasswordController.text,
                        ),
                      );
                },
                text: 'Login',
                isEnabled: _isButtonEnabled,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              onPressed: () {
                setState(() {
                  _isLogin = false;
                });
              },
              text: 'Don\'t have an account? Register',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          children: [
            const Text(
              'Please register to continue',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _registerEmailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _registerPasswordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _registerConfirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  setState(() {
                    _isButtonEnabled = false;
                  });

                  if (_loginPasswordController.text ==
                      _registerConfirmPasswordController.text) {
                    context.read<AuthBloc>().add(
                          SignUpEvent(
                            email: _loginEmailController.text,
                            password: _loginPasswordController.text,
                          ),
                        );
                  } else {
                    setState(() {
                      _isButtonEnabled = true;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
                      ),
                    );
                  }
                },
                text: 'Register',
                isEnabled: _isButtonEnabled,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextButton(
              onPressed: () {
                setState(() {
                  _isLogin = true;
                });
              },
              text: 'Already have an account? Login',
            ),
          ],
        ),
      ),
    );
  }
}
