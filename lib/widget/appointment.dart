import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/screen/chat_screen.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:service_hub/widget/chat/chat_message.dart';

class AppointmentWidget extends StatefulWidget {
  const AppointmentWidget({
    super.key,
    required this.isLogin,
    required this.navigateToAccount,
    required this.isClient,
  });

  final bool isClient;
  final bool isLogin;
  final VoidCallback navigateToAccount;

  @override
  State<AppointmentWidget> createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentWidget> {
  List<dynamic> appointments = [];

  Future<void> getAppointments() async {
    final result = await ApiService().appointmentList();
    final List<dynamic> data = jsonDecode(result.body)['data'];
    Logger().e("appointment data  $data isclient ${widget.isClient}");
    setState(() {
      appointments = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 221, 221, 221),
            height: .5,
          ),
        ),
      ),
      body: widget.isLogin ? _buildAppointmentsListView() : _buildLoginPrompt(),
    );
  }

  Widget _buildAppointmentsListView() {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(
          appointment: appointment,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        senderName: appointment['name'],
                        senderId: appointment['user_id'],
                      )),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Log in to your account to view your appointments',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: widget.navigateToAccount,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              minimumSize: const Size(double.infinity, 48.0),
            ),
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat.yMMMMd().add_jms().format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            appointment['provider_name'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment['service_name'],
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Client: ${appointment['name']}'),
            Text(
                'Book Date: ${formatDate(appointment['created_at']).toString()}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
