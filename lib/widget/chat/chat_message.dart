import 'package:flutter/material.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.isYou});
  final String text;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isYou
              ? const CircleAvatar(
                  child:
                      Text('U'), // You can replace this with user profile image
                )
              : Container(), // Show profile image for other users
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment:
                    isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isYou ? 'You' : 'Other User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
