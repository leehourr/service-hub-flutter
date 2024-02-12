import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/chat/chat_item.dart';
import 'package:service_hub/widget/chat/chat_list.dart';
import 'package:service_hub/widget/chat/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:service_hub/service/pusher_channel.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decode/jwt_decode.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.senderName,
      required this.senderId,
      required this.chatId});

  final String senderName;
  final int senderId;
  final int chatId;

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late int userId;
  late String _token;
  late String _name;

  bool _isButtonDisabled = true;
  var logger = Logger();

  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    // _apiService = ApiService(token: _token);
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    await _getUserId();
    _apiService = ApiService(token: _token);
    await _loadChat();
    // _loadChat(); // Call your API to load chat messages
  }

  Future<void> _getUserId() async {
    String? token = await _getSavedToken();
    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        Map<String, dynamic> userData = decodedToken['data'];
        setState(() {
          userId = userData['id'];
          _name = userData['name'];
          _token = token;
        });
      } catch (e) {
        logger.e("Error decoding token: $e");
      }
    }
  }

  Future<void> _loadChat() async {
    _apiService
        .getChatStream(chatId: 18, userId: userId, token: _token)
        .listen((List<ChatMessage> messages) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages.reversed);
      });
    });
  }

  void _handleNewMessage(List<String> messages, bool isYou) async {
    setState(() {
      for (var message in messages) {
        _messages.insert(
          0,
          ChatMessage(
            message: message,
            senderName: _name,
            isYou: true,
          ),
        );
      }
      _isButtonDisabled = true;
    });
    // Navigator.pop(context);
  }

  void _sendMessage(String messageText) async {
    if (messageText == "" || messageText.isEmpty) {
      return;
    }

    try {
      final response = await _apiService.sendMessage(
        messageText: messageText,
        senderId: userId,
        chatId: 18,
        userId: 4,
      );

      // Handle the response as needed
      // For example, you can check if the response was successful
      if (response.statusCode == 200) {
        _handleNewMessage([messageText], true);

        logger.e('Message sent successfully');
      } else {
        // Handle the case when the message sending fails
        logger.e('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions or errors
      logger.e('Error sending message: $e');
    }

    _textController.clear();
    _loadChat();
  }

  // Future<void> _logDecodedToken() async {
  //   String? token = await _getSavedToken();
  //   if (token != null) {
  //     try {
  //       Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

  //       // Accessing user data from the decoded token
  //       Map<String, dynamic> userData = decodedToken['data'];
  //       // int userId = userData['id'];
  //       // String phoneNumber = userData['phone_number'];
  //       // String accountType = userData['account_type'];

  //       // logger.e(
  //       //     "Decoded Token - Username: $userId, Phone Number: $phoneNumber, Account Type: $accountType");
  //     } catch (e) {
  //       logger.e("Error decoding token: $e");
  //     }
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context, true);
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatList(),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.senderName),
            centerTitle: true,
            // You can customize other properties of the AppBar here
          ),
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
                child: _buildTextComposer(),
              ),
            ],
          ),
        ));
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
