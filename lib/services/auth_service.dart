import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/user.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final http.Client _client = http.Client();

  Future<User> login({required String email, required String password}) async {
    final response = await _client
        .post(
          Uri.parse('${AppConfig.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(AppConfig.requestTimeout);
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw AuthException('Login failed. Check your email and password.');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = data['access_token']?.toString();
    final refreshToken = data['refresh_token']?.toString();
    if (accessToken == null || accessToken.isEmpty) {
      throw AuthException('The API did not return an access token.');
    }
    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
    return fetchProfile(accessToken: accessToken);
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client
        .post(
          Uri.parse('${AppConfig.baseUrl}/users/'),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'avatar': AppConfig.defaultAvatar,
          }),
        )
        .timeout(AppConfig.requestTimeout);
    if (response.statusCode != 201) {
      throw AuthException('Account creation failed (HTTP ${response.statusCode}).');
    }
    return login(email: email, password: password);
  }

  Future<User> fetchProfile({String? accessToken}) async {
    final token = accessToken ?? await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) throw AuthException('Please log in again.');
    final response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/auth/profile'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    ).timeout(AppConfig.requestTimeout);
    if (response.statusCode != 200) {
      throw AuthException('Could not verify your session. Please log in again.');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return User(
      name: (data['name'] ?? data['email'] ?? 'E-Shop User').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<String?> get accessToken => _storage.read(key: 'access_token');
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
