import 'package:flutter/material.dart';
import 'package:service_hub/screen/chat_screen.dart';

class ServiceDetailWidget extends StatelessWidget {
  final String imageUrl;
  final String serviceName;
  final String serviceProviderName;
  final int senderId;
  final String description;

  const ServiceDetailWidget({
    super.key,
    required this.imageUrl,
    required this.senderId,
    required this.serviceName,
    required this.serviceProviderName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image at the top
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Row of buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement book button logic
                  },
                  child: const Text('Book'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                senderName: serviceProviderName,
                                senderId: senderId,
                              )),
                    );
                  },
                  child: const Text('Contact'),
                ),
              ],
            ),
          ),
          // Service name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              serviceName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Service provider name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Provider: $serviceProviderName',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
