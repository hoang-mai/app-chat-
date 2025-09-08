import 'package:appchat/models/token_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AccountService{
  static final AccountService _instance = AccountService._internal();
  static AccountService get instance => _instance;
  AccountService._internal();

  Future<void> saveToken(String token,TokenType tokenType) async {
    final prefs = await SharedPreferences.getInstance();
    if(tokenType == TokenType.accessToken){
      await prefs.setString(TokenType.accessToken.key, token);
    } else if(tokenType == TokenType.refreshToken){
      await prefs.setString(TokenType.refreshToken.key, token);
    }
  }

  Future<String?> getToken({TokenType tokenType = TokenType.accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenType.key);
  }
}