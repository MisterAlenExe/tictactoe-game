import 'package:flutter/material.dart';

class TestMaterialApp extends StatelessWidget {
  final Widget child;

  const TestMaterialApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}
