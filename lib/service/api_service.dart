import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:service_hub/widget/chat/chat_message.dart';

class ApiService {
  ApiService({this.token});
  final String? token;
  final baseUrl = '10.0.2.2:8000';
  var logger = Logger();

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
      // print('Error: $e');
      throw Exception(e);
    }
  }

  Future<http.Response> viewChat(
      {required int chatId, required int userId, required String token}) async {
    final url = Uri.http(baseUrl, '/api/v1/view-chat/$chatId/$userId');
    // print('Name: $name');
    // print('Phone Number: $phoneNumber');
    // print('Password: $password');
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

  Stream<List<ChatMessage>> getChatStream({
    required int chatId,
    required int userId,
    required String token,
  }) async* {
    while (true) {
      try {
        final response =
            await viewChat(chatId: chatId, userId: userId, token: token);
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<Map<String, dynamic>> messagesData =
            List<Map<String, dynamic>>.from(responseData['messages']);

        final List<ChatMessage> messages = messagesData.map((messageData) {
          return ChatMessage(
            message: messageData['message_text'],
            senderName: messageData['sender_name'],
            isYou: messageData['isYou'] ?? false,
          );
        }).toList();

        yield messages;
        await Future.delayed(
            const Duration(seconds: 5)); // You can adjust the delay as needed
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
    required int chatId,
    required int userId,
  }) async {
    final url = Uri.http(baseUrl, 'api/v1/send-chat/$userId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'message_text': messageText.trim(),
          'sender_id': senderId,
          'chat_id': chatId,
        }),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
