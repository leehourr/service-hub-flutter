import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTabView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black, // Set the background color
        fixedColor: Colors.black, // Set the selected tab text and icon color
        unselectedItemColor:
            Colors.black, // Set the selected tab text and icon color
        items: [
          _buildBottomNavItem('Home', Icons.home),
          _buildBottomNavItem('Search', Icons.search),
          _buildBottomNavItem('Bookings', Icons.book),
          _buildBottomNavItem('Appointments', Icons.event),
          _buildBottomNavItem('Account', Icons.account_circle),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    switch (_currentIndex) {
      case 0:
        return const Center(
            child: Text('Home Content', style: TextStyle(color: Colors.black)));
      case 1:
        return const Center(
            child:
                Text('Search Content', style: TextStyle(color: Colors.black)));
      case 2:
        return const Center(
            child:
                Text('Books Content', style: TextStyle(color: Colors.black)));
      case 3:
        return const Center(
            child: Text('Appointment Content',
                style: TextStyle(color: Colors.black)));
      case 4:
        return const Center(
            child:
                Text('Account Content', style: TextStyle(color: Colors.black)));
      default:
        return Container();
    }
  }

  BottomNavigationBarItem _buildBottomNavItem(String label, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
