import 'package:flutter/material.dart';
import 'package:tictactoe_game/features/global/widgets/loading_indicator.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Button border radius
        ),
      ),
      child: isEnabled
          ? Text(
              text,
              style: const TextStyle(fontSize: 16),
            )
          : const SizedBox(
              height: 24,
              width: 24,
              child: LoadingIndicator(),
            ),
    );
  }
}
