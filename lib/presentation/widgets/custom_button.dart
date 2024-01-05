import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
