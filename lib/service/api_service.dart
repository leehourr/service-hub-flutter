import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // ApiService({required this.baseUrl});
  // final String baseUrl;
  final baseUrl = '10.0.2.2:8000';

  Future<http.Response> signUp({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.http(baseUrl, '/api/v1/signup');
    // print('Name: $name');
    // print('Phone Number: $phoneNumber');
    // print('Password: $password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name.trim(),
          'phone_number': phoneNumber.trim(),
          'account_type': 'client',
          'password': password.trim(),
        }),
      );
      return response;
    } catch (e) {
      // Handle errors or exceptions as needed
      print('Error: $e');
      throw Exception(e);
    }
  }

  Future<http.Response> login({
    required String account,
    required String password,
  }) async {
    final url = Uri.http(baseUrl, '/api/v1/login');
    // print('Name: $name');
    // print('Phone Number: $phoneNumber');
    // print('Password: $password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'account': account.trim(),
          'password': password.trim(),
        }),
      );
      return response;
    } catch (e) {
      // Handle errors or exceptions as needed
      print('Error: $e');
      throw Exception(e);
    }
  }
}
