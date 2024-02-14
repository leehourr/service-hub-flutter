import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/service_details.dart';

class ServiceSearch extends StatefulWidget {
  const ServiceSearch({
    super.key,
    required this.isLogin,
    required this.navigateToAccount,
  });
  final bool isLogin;
  final VoidCallback navigateToAccount;
  @override
  State<ServiceSearch> createState() => _ServiceSearchWidgetState();
}

class _ServiceSearchWidgetState extends State<ServiceSearch> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    // Initialize searchResults with all services and providers
  }

  Future<void> _search(String query) async {
    final String search = searchController.text;
    if (search == "" || search.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    final result = await ApiService().searchService(search: search);
    final List<dynamic> data = jsonDecode(result.body)['data'];
    Logger().e("data  $data");

    setState(() {
      searchResults = data;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: _search,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Service, Service provider',
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchResults.isEmpty && searchController.text == ""
          ? const Center(
              child: Text('No result'),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> result = searchResults[index];
                return _buildServiceCard(result);
              },
            ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> result) {
    void navgiateToServiceDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailWidget(
              key: UniqueKey(),
              imageUrl: result['image'],
              serviceName: result['service_name'],
              senderId: result['service_provider_id'],
              serviceProviderName: result['name'],
              description: result['service_description'],
              navigateToAccount: widget.navigateToAccount,
              isLogin: widget.isLogin),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // if (!isLogin) {
        //   navigateToAccount();
        //   return;
        // }
        navgiateToServiceDetail();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(result['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              result['service_name'] ?? '',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Category: ${result['service_category'] ?? ''}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Provider: ${result['name'] ?? ''}',
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
