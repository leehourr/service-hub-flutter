import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/widget/chat/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:service_hub/service/pusher_channel.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late int userId;
  bool _isButtonDisabled = true;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    // _initFirebaseMessaging();
  }

  // void _requestPermissionsAndConfigure() async {
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     logger.e('User granted permission');
  //   } else {
  //     logger.e('User declined or has not yet granted permission');
  //   }
  // }

  // void _initFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Handle foreground messages
  //     logger.e("Received foreground message: $message");
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     // Handle messages opened from the app's closed state
  //     logger.e("Opened app from terminated state: $message");
  //   });

  //   // You can also handle other events like onBackgroundMessage, etc.

  //   // _requestPermissionsAndConfigure();
  // }

  void _handleNewMessage(String messageText, bool isYou) async {
    ChatMessage message = ChatMessage(
      text: messageText,
      // For simplicity, we'll use a boolean to determine whether the message is from the user or not.
      isYou: isYou,
    );
    setState(() {
      _messages.insert(0, message);
      _isButtonDisabled = true;
    });
  }

  void _sendMessage(String messageText) {
    // _logDecodedToken();
    if (messageText == "" || messageText.isEmpty) {
      return;
    }
    _handleNewMessage(messageText, true);
    // _initFirebaseMessaging();
    // Clear the text field
    _textController.clear();
  }

  // Future<void> _logDecodedToken() async {
  //   String? token = await _getSavedToken();
  //   if (token != null) {
  //     try {
  //       final Map<String, dynamic> decodedToken =
  //           json.decode(utf8.decode(base64.decode(token.split(".")[1])));

  //       logger.e("Decoded Token: ${decodedToken['data']['username']}");
  //     } catch (e) {
  //       logger.e("Error decoding token: $e");
  //     }
  //   }
  // }

  Future<String?> _getSavedToken() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('jwt_token');
      return token;
    } catch (e) {
      logger.e("error getting token $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                return false;
              },
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
          ),
          // const Divider(height: 1.0),
          Container(
            // decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return
        // IconTheme(
        //   data: const IconThemeData(color: Colors.black),
        Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color
          width: 1.0, // Set the border width
        ),
        borderRadius: BorderRadius.circular(12.0), // Set the border radius
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.fromLTRB(9.0, 8.0, 9.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isButtonDisabled = text.isEmpty;
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Message...'),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonDisabled ? Colors.grey : Colors.black,
              padding: const EdgeInsets.all(8.0),
              shape: const CircleBorder(),
            ),
            onPressed: _isButtonDisabled
                ? null
                : () => _sendMessage(_textController.text),
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  // );
  // }
}
