import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:intl/intl.dart';

class BookingList extends StatefulWidget {
  const BookingList(
      {super.key,
      required this.isLogin,
      required this.navigateToAccount,
      required this.isClient});

  final bool isClient;
  final bool isLogin;
  final VoidCallback navigateToAccount;

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<dynamic> bookList = [];

  Future<void> getBooking() async {
    final result = await ApiService().getBookingList();
    final List<dynamic> data = jsonDecode(result.body)['data'];
    Logger().e("booking data  $data isclient ${widget.isClient}");
    setState(() {
      bookList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 221, 221, 221),
            height: .5,
          ),
        ),
      ),
      body: widget.isLogin ? _buildBookingListView() : _buildLoginPrompt(),
    );
  }

  Widget _buildBookingListView() {
    // final bool _isClient = widget.isClient;

    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (context, index) {
        final booking = bookList[index];
        return BookingCard(
            booking: booking,
            isClient: widget.isClient,
            onDismissed: () async {
              if (widget.isClient) {
                // Logger().e("booking id  ${booking['id']}");
                // Client: Call Cancel function
                bool confirm = await _showCancelBookingDialog(context);
                if (confirm) {
                  await ApiService().cancelBooking(bookingId: booking['id']);
                  await getBooking();
                }
                setState(() {});
              } else {
                // Service Provider: Call Decline function
                // ApiService().declineBooking(booking['id']);
              }
            });
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Log in to your account to view your bookings',
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

  Future<bool> _showCancelBookingDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure you want to cancel?'),
              // content: Text('This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Cancel the delete action
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Confirm the delete action
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard(
      {super.key,
      required this.booking,
      required this.isClient,
      required this.onDismissed});
  final Map<String, dynamic> booking;
  final VoidCallback onDismissed;
  final bool isClient;

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Colors.orange;
        case 'accepted':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        case 'declined':
          return Colors.red;
        default:
          return Colors.black;
      }
    }

    String formattedStatus =
        "${booking['status'][0].toUpperCase()}${booking['status'].substring(1)}";

    Color statusColor = getStatusColor(booking['status']);

    String _formatDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat.yMMMMd().add_jms().format(dateTime);
      return formattedDate;
    }

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red, // Background color when swiping
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 40.0),
        child: Text(
          isClient ? 'Cancel' : 'Decline',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart &&
            booking['status'].toString() == 'pending') {
          return true;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "This booking is already ${isClient ? 'cancelled' : 'declinded'}"),
            duration: const Duration(seconds: 2),
          ),
        );
        return false; // Prevent dismissing for other directions or when status is not pending
      },
      onDismissed: (direction) {
        onDismissed();
        // Handle dismissal (call cancel/decline function here)
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              booking['provider_name'][0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking['service_name'],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Provider: ${booking['provider_name']}'),
              Text(
                  'Book Date: ${_formatDate(booking['book_date']).toString()}'),
            ],
          ),
          trailing: Text(
            formattedStatus,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
