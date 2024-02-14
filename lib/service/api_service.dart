import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/widget/chat/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  ApiService({this.token});
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String? token;
  final baseUrl = '10.0.2.2:8000';
  var logger = Logger();

  Future<String?> _getSavedToken() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('jwt_token');
      logger.e("Token: $token");

      return token;
    } catch (e) {
      logger.e("error getting token $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTokenData() async {
    String? token = await _getSavedToken();
    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        Map<String, dynamic> userData = decodedToken['data'];
        return {
          'userId': userData['id'],
          'name': userData['name'],
          // 'token': token,
        };
      } catch (e) {
        logger.e("Error decoding token: $e");
        return null;
      }
    }
    return null;
  }

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
      // print('Error: $e');
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
      // print('Error: $e');
      throw Exception(e);
    }
  }

  Future<http.Response> viewChat({
    required int senderId,
    required int userId,
  }) async {
    final url = Uri.http(baseUrl, '/api/v1/view-chat/$senderId/$userId');
    // print('Name: $name');
    // print('Phone Number: $phoneNumber');
    // print('Password: $password');
    try {
      String? token = await _getSavedToken();

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<ChatMessage>> getChatStream({
    required int senderId,
    required int userId,
  }) async* {
    while (true) {
      try {
        final response = await viewChat(senderId: senderId, userId: userId);
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<Map<String, dynamic>> messagesData =
            List<Map<String, dynamic>>.from(responseData['messages']);

        final List<ChatMessage> messages = messagesData.map((messageData) {
          return ChatMessage(
            message: messageData['message_text'],
            senderName: messageData['sender_name'],
            // chatId: int.parse(messagesData['chat_id']),
            isYou: messageData['isYou'] ?? false,
          );
        }).toList();

        yield messages;
        await Future.delayed(
            const Duration(seconds: 3)); // You can adjust the delay as needed
      } catch (e) {
        logger.e('Error loading chat: $e');
        yield []; // You can handle errors as needed
        await Future.delayed(const Duration(seconds: 5)); // Retry after a delay
      }
    }
  }

  Future<http.Response> sendMessage({
    required String messageText,
    required int senderId,
    // required int chatId,
    required int userId,
  }) async {
    final url = Uri.http(baseUrl, 'api/v1/send-chat/$userId');
    try {
      String? token = await _getSavedToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'message_text': messageText.trim(),
          'sender_id': senderId,
          // 'chat_id': chatId,
        }),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> getChatList({required int userId}) async {
    // logger.e('token in api class $token');
    String? token = await _getSavedToken();
    final url = Uri.http(baseUrl, 'api/v1/chat-list/$userId');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> deleteChat({required int chatId}) async {
    // logger.e('token in api class $token');
    String? token = await _getSavedToken();
    final url = Uri.http(baseUrl, 'api/v1/removechat/$chatId');
    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      logger.e('error deleting chat ${response.body}');

      return response;
    } catch (e) {
      logger.e('error deleting chat $e');
      throw Exception(e);
    }
  }

  Future<http.Response> getServiceList() async {
    // logger.e('token in api class $token');
    String? token = await _getSavedToken();
    final url = Uri.http(baseUrl, 'api/v1/service');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> searchService({required String search}) async {
    // logger.e('token in api class $token');
    String? token = await _getSavedToken();
    final url = Uri.http(baseUrl, 'api/v1/search-service/$search');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
