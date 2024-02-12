import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/chat/chat_item.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late List<dynamic> _chatList = [];
  late int userId;
  ApiService apiService = ApiService();
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    await _loadTokenData();
    await _loadChatList();
    // _loadChat(); // Call your API to load chat messages
  }

  Future<void> _loadChatList() async {
    try {
      final response = await apiService.getChatList(userId: userId);
      final data = json.decode(response.body);
      logger.e('data: $data');

      setState(() {
        _chatList = List<dynamic>.from(data['chats']);
      });
    } catch (e) {
      // Handle error
      logger.e('Error loading chat list: $e');
    }
  }

  Future<void> _loadTokenData() async {
    try {
      final tokenData = await apiService.getTokenData();
      if (tokenData != null) {
        logger.e("token data ${tokenData['userId']}");

        setState(() {
          userId = tokenData['userId'];
        });
      }
    } catch (e) {
      // Handle error
      print('Error loading token data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          final chat = _chatList[index];
          return ChatItem(
            name: chat['name'],
            lastText: chat['last_text'],
            chatId: chat['chat_id'],
            senderId: chat['user_id'],
            firstLetter:
                chat['name'] != null ? chat['name'][0].toUpperCase() : '',
          );
        },
      ),
    );
  }
}
