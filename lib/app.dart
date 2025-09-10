import 'package:appchat/screens/home_screen.dart';
import 'package:appchat/screens/login_screen.dart';
import 'package:appchat/services/account_service.dart';
import 'package:appchat/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/token_type.dart';

class AppChat extends StatelessWidget {
  const AppChat({super.key});

  Future<Widget> _decideStartScreen(BuildContext context) async {
    final accountService = Provider.of<AccountService>(context, listen: false);
    if (await accountService.isTokenExpired() &&
        await accountService.isTokenExpired(
            tokenType: TokenType.refreshToken)) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhắn tin',
      navigatorKey: NavigatorService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _decideStartScreen(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
    );
  }
}