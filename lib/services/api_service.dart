import 'dart:convert';

import 'package:appchat/services/account_service.dart';
import 'package:http/http.dart' as http;

import '../models/base_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  static ApiService get instance => _instance;

  ApiService._internal();

  final http.Client httpClient = http.Client();
  final String baseUrl = 'http://localhost:8080/api/v1';

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
      String? token = await AccountService.instance.getToken();
      if (token != null) {
        headers['Authorization'] = token;
      } else {
        headers.remove('Authorization');
      }
    }
    try {
      final uri = Uri.parse('$baseUrl$url').replace(queryParameters: params);
      final response = await httpClient.get(uri, headers: headers);

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<BaseResponse<T>> postApi<T>(
    String url,
    Object body,
    T Function(Map<String, dynamic> json) fromJsonT, {
    bool isToken = true,
  }) async {
    if (isToken) {
      String? token = await AccountService.instance.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        headers.remove('Authorization');
      }
    }

    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl$url'),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  Future<BaseResponse<T>> patchApi<T>(
    String url,
    Object body,
    T Function(Map<String, dynamic> json) fromJsonT, {
    bool isToken = true,
  }) async {
    if (isToken) {
      String? token = await AccountService.instance.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        headers.remove('Authorization');
      }
    }

    try {
      final response = await httpClient.patch(
        Uri.parse('$baseUrl$url'),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      return BaseResponse<T>.fromJson(json, fromJsonT);
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}
