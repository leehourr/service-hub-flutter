import 'package:flutter/material.dart';
import 'package:service_hub/screen/chat_screen.dart';
import 'package:service_hub/service/api_service.dart';

class ServiceDetailWidget extends StatefulWidget {
  const ServiceDetailWidget(
      {super.key,
      required this.imageUrl,
      required this.serviceId,
      required this.senderId,
      required this.serviceName,
      required this.serviceProviderName,
      required this.description,
      required this.isLogin,
      required this.navigateToAccount});

  final String imageUrl;
  final String serviceName;
  final String serviceProviderName;
  final int senderId;
  final int serviceId;
  final String description;
  final bool isLogin;
  final VoidCallback navigateToAccount;
  @override
  State<ServiceDetailWidget> createState() => _ServiceDetailWidgetState();
}

class _ServiceDetailWidgetState extends State<ServiceDetailWidget> {
  bool isLoading = false;

  void _showBookNowModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await ApiService().bookService(
                      providerId: widget.senderId, serviceId: widget.serviceId);
                  setState(() {
                    isLoading = false;
                  });
                  showMessage();
                  // Close the modal
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal on 'Cancel'
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showMessage() {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have booked the service'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
                image: NetworkImage(widget.imageUrl),
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
                    if (!widget.isLogin) {
                      widget.navigateToAccount();
                      Navigator.pop(context);
                      return;
                    }
                    _showBookNowModal(context);
                  },
                  child: const Text('Book now'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!widget.isLogin) {
                      widget.navigateToAccount();
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                senderName: widget.serviceProviderName,
                                senderId: widget.senderId,
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
              widget.serviceName,
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
              'Provider: ${widget.serviceProviderName}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.description,
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
