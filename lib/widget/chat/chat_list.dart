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
      // print('Error loading token data: $e');
    }
  }

  Future<bool> showDeleteConfirmationDialog(
      BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permanently delete chat for you and $name'),
              // content: Text('This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Cancel the delete action
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Confirm the delete action
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index) {
            final chat = _chatList[index];
            return ChatItem(
              key: UniqueKey(),
              name: chat['name'],
              lastText: chat['last_text'],
              chatId: chat['chat_id'],
              senderId: chat['user_id'],
              firstLetter:
                  chat['name'] != null ? chat['name'][0].toUpperCase() : '',
              onDismissed: () async {
                bool confirmDelete =
                    await showDeleteConfirmationDialog(context, chat['name']);
                final int chatId = chat['chat_id'];
                // logger.e(" chat id $chatId");
                if (confirmDelete) {
                  await apiService.deleteChat(chatId: chatId);
                  return;
                }
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
