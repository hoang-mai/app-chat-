import 'package:appchat/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppChat());
}

class AppChat extends StatelessWidget {
  const AppChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhắn tin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
