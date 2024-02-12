import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.message,
    required this.senderName,
    required this.isYou,
  });

  final String message;
  final bool isYou;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    final messageText = message;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                    // width: 30.0, // Set the width
                    // height: 30.0, // Set the height
                    // decoration: BoxDecoration(
                    //   color: Colors.black,
                    //   borderRadius: BorderRadius.circular(40.0),
                    // ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment:
                    isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: _buildMessageText(messageText, isYou),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageText(dynamic messageText, bool isYou) {
    if (messageText is String) {
      // If it's a string, return a Text widget
      return Align(
        alignment: isYou ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            color: isYou ? Colors.black : null,
            borderRadius: BorderRadius.circular(12.0),
            border: isYou
                ? null
                : Border.all(
                    color: Colors.black,
                  ),
          ),
          child: Text(
            messageText,
            style: TextStyle(
              color: isYou ? Colors.white : Colors.black,
            ),
            textAlign: isYou ? TextAlign.end : TextAlign.start,
          ),
        ),
      );
    } else if (messageText is List<String>) {
      // If it's a list of strings, display each string in a column
      return Column(
        crossAxisAlignment:
            isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: messageText
            .map(
              (text) => Align(
                alignment: isYou ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: isYou ? Colors.black : null,
                    borderRadius: BorderRadius.circular(12.0),
                    border: isYou
                        ? null
                        : Border.all(
                            color: Colors.black,
                          ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isYou ? Colors.white : Colors.black,
                    ),
                    textAlign: isYou ? TextAlign.end : TextAlign.start,
                  ),
                ),
              ),
            )
            .toList(),
      );
    } else {
      // Handle other types or return an empty container
      return Container();
    }
  }
}
