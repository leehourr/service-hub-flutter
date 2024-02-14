import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/chat/chat_list.dart';
import 'package:service_hub/widget/service_card.dart';

final List<String> categories = [
  'Education',
  'Technology',
  'Home Improvement',
  'HVAC',
  'Landscaping',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userName,
    required this.isLogin,
    required this.navigateToAccount,
  });

  final String userName;
  final bool isLogin;
  final VoidCallback navigateToAccount;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> serviceList = [];
  var logger = Logger();
  @override
  void initState() {
    super.initState();
    _fetchServiceList();
  }

  Future<void> _fetchServiceList() async {
    try {
      ApiService apiService = ApiService();
      final response = await apiService
          .getServiceList(); // Replace 1 with the actual user ID
      final data = json.decode(response.body);
      setState(() {
        serviceList = data['data'];
      });
      logger.e("is login ${widget.isLogin} response ${data['data']} ");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome${widget.isLogin ? ", ${widget.userName}" : ""}'),
        actions: [
          if (widget.isLogin)
            IconButton(
              icon: const Icon(Icons.chat), // Use your preferred chat icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatList()),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 200,
            width: double.infinity,
            child: Image(
              image: NetworkImage(
                "https://i.pinimg.com/originals/4a/6b/0e/4a6b0e66a81dcd9f6faba731e04f2652.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 15.0,
                runSpacing: 8.0,
                children: categories.map((category) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: serviceList
                  .length, // Replace with the actual number of services
              itemBuilder: (context, index) {
                final service = serviceList[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ServiceCard(
                        // key: Key(service['id'].toString()),
                        key: UniqueKey(),
                        isLogin: widget.isLogin,
                        serviceId: service['id'],
                        imageUrl: service['image'],
                        serviceName: service['service_name'],
                        serviceProviderName: service['name'],
                        providerId: service['service_provider_id'],
                        description: service['service_description'],
                        navigateToAccount: widget.navigateToAccount));
              },
            ),
          ),
        ],
      ),
    );
  }
}
