import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.message,
    required this.senderName,
    // required this.chatId,
    required this.isYou,
  });

  final String message;
  // final int chatId;
  final bool isYou;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    final messageText = message;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isYou)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: Text(
                      senderName.isNotEmpty ? senderName[0].toUpperCase() : '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment:
                    isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // margin: const EdgeInsets.only(top: 8.0),
                    child: _buildMessage(messageText, isYou),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isYou) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 250.0, // Set your preferred maximum width
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        color: isYou ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        children: [
          Text(
            message,
            style: TextStyle(
              color: isYou ? Colors.white : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
