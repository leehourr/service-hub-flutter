import 'package:flutter/material.dart';
import 'package:service_hub/screen/chat_screen.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.name,
    required this.chatId,
    required this.senderId,
    required this.lastText,
    required this.firstLetter,
    required this.onDismissed,
  });

  // final Key key;
  final String? name;
  final String? lastText;
  final int? chatId;
  final int senderId;
  final String? firstLetter;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Callback when item is dismissed (swiped)
        onDismissed();
      },
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            // Navigate to ChatScreen on tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  senderName: name ?? "",
                  senderId: senderId,
                  // chatId: chatId,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      firstLetter ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        lastText ?? '',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
