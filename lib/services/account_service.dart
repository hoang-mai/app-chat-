import 'package:appchat/models/token_type.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
class AccountService extends ChangeNotifier{
  static final AccountService _instance = AccountService._internal();
  static AccountService get instance => _instance;
  AccountService._internal();

  Future<void> saveLogin(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TokenType.accessToken.key, loginResponse.accessToken);
    await prefs.setString(TokenType.refreshToken.key, loginResponse.refreshToken);
    await prefs.setString('expiresAt ', DateTime.now().add(Duration(seconds: loginResponse.expiresIn)).toIso8601String());
    await prefs.setString('refreshExpiresAt', DateTime.now().add(Duration(seconds: loginResponse.refreshExpiresIn)).toIso8601String());
  }

  Future<String?> getToken({TokenType tokenType = TokenType.accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenType.key);
  }

  Future<bool> isTokenExpired({TokenType tokenType = TokenType.accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtString = prefs.getString(tokenType == TokenType.accessToken ? 'expiresAt ' : 'refreshExpiresAt');

    if (expiresAtString == null) return true;

    final expiresAt = DateTime.parse(expiresAtString);
    return DateTime.now().isAfter(expiresAt);
  }

}