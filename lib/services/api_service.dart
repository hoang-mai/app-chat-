import 'dart:convert';

import 'package:appchat/exceptions/expired_exception.dart';
import 'package:appchat/models/refresh_response.dart';
import 'package:appchat/models/token_type.dart';
import 'package:appchat/services/account_service.dart';
import 'package:appchat/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../utils/base_response.dart';
import '../models/login_response.dart';
import '../screens/login_screen.dart';
import 'navigator_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  static ApiService get instance => _instance;

  ApiService._internal();

  final http.Client httpClient = http.Client();
  final String baseUrl = FlutterConfig.get('BASE_URL');

  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<BaseResponse<T>> getApi<T>(
    String url,
    Map<String, String> params,
    T Function(Map<String, dynamic> json) fromJsonT, {
    bool isToken = true,
  }) async {
    if (isToken) {
      headers['Authorization'] = 'Bearer ${await _getToken()}';
    }
    try {
      final uri = Uri.parse('$baseUrl$url').replace(queryParameters: params);
      final response = await httpClient.get(uri, headers: headers);

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } on ExpiredException catch (e) {
      _handleExpiredException(e);
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': e.message,
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    } catch (e) {
      _showErrorDialog('Có lỗi xảy ra, vui lòng thử lại sau.');
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': 'Có lỗi xảy ra, vui lòng thử lại sau.',
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    }
  }

  Future<BaseResponse<T>> postApi<T>(
    String url,
    Object body,
    T Function(Map<String, dynamic> json) fromJsonT, {
    bool isToken = true,
  }) async {
    if (isToken) {
      headers['Authorization'] = 'Bearer ${await _getToken()}';
    }

    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl$url'),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } on ExpiredException catch (e) {
      _handleExpiredException(e);
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': e.message,
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    } catch (e) {
      _showErrorDialog('Có lỗi xảy ra, vui lòng thử lại sau.');
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': 'Có lỗi xảy ra, vui lòng thử lại sau.',
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    }
  }

  Future<BaseResponse<T>> patchApi<T>(
    String url,
    Object body,
    T Function(Map<String, dynamic> json) fromJsonT, {
    bool isToken = true,
  }) async {
    try {
      if (isToken) {
        headers['Authorization'] = 'Bearer ${await _getToken()}';
      }
      final response = await httpClient.patch(
        Uri.parse('$baseUrl$url'),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } on ExpiredException catch (e) {
      _handleExpiredException(e);
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': e.message,
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    } catch (e) {
      _showErrorDialog('Có lỗi xảy ra, vui lòng thử lại sau.');
      return BaseResponse<T>.fromJson({
        'statusCode': 500,
        'message': 'Có lỗi xảy ra, vui lòng thử lại sau.',
        'data': null,
        'timestamp': DateTime.now().toIso8601String(),
      }, fromJsonT);
    }
  }

  Future<String> _getToken() async {
    String? token = await AccountService.instance.getToken();
    if (await AccountService.instance
            .isTokenExpired(tokenType: TokenType.accessToken) ||
        token == null) {
      String? refreshToken = await AccountService.instance
          .getToken(tokenType: TokenType.refreshToken);
      if (await AccountService.instance
              .isTokenExpired(tokenType: TokenType.refreshToken) ||
          refreshToken == null) {
        throw ExpiredException(
            'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.');
      } else {
        BaseResponse<RefreshResponse> baseResponse = await postApi(
            ApiEndpoint.refresh, {refreshToken}, RefreshResponse.fromJson,
            isToken: false);
        if (baseResponse.statusCode == 200) {
          await AccountService.instance.saveLogin(LoginResponse(
            accessToken: baseResponse.data!.accessToken,
            expiresIn: baseResponse.data!.expiresIn,
            refreshToken: baseResponse.data!.refreshToken,
            refreshExpiresIn: baseResponse.data!.refreshExpiresIn,
            tokenType: baseResponse.data!.tokenType,
            sessionState: baseResponse.data!.sessionState,
            scope: baseResponse.data!.scope,
          ));
          token = baseResponse.data!.accessToken;
        } else {
          throw ExpiredException('Có lỗi xảy ra, vui lòng đăng nhập lại.');
        }
      }
    }
    return token;
  }

  void _showErrorDialog(String message) {
    final context = NavigatorService.navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _handleExpiredException(ExpiredException e) {
    final context = NavigatorService.navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Phiên đăng nhập hết hạn"),
        content: Text(e.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Đăng nhập lại"),
          ),
        ],
      ),
    );
  }
}
