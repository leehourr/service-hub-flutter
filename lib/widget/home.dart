import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/screen/auth/login_screen.dart';
import 'package:service_hub/screen/home_screen.dart';
import 'package:service_hub/widget/auth/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();
  // void navigateToAccountTab() {
  //   navigatorKey.currentState?.pushNamed('Account');
  // }

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  int _currentIndex = 0;
  var logger = Logger();
  late String? _name = '';
  late String? _number = '';
  late bool? _isLogin = false;

  @override
  void initState() {
    super.initState();
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    await _hasToken();
    setState(() {});
  }

  Future<bool> _hasToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');
      if (token != null) {
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        final String name = decodedToken['data']['name'].toString();
        final String number = decodedToken['data']['phone_number'].toString();

        logger.e("token $token name $name $number");
        _name = name;
        _number = number;
        _isLogin = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

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
        _hasToken();
        return Center(
          child: HomeScreen(
            userName: _name!,
            isLogin: _isLogin!,
            navigateToAccount: () {
              setState(() {
                _currentIndex = 4;
              });
            },
          ),
        );

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
        return FutureBuilder<bool>(
          key: UniqueKey(),
          future: _hasToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return Center(
                    child: Profile(
                  name: _name ?? "",
                  number: _number ?? '',
                ));
              } else {
                return const Center(
                  child: LoginScreen(),
                );
              }
            }
            // Loading state
            return const Center(child: CircularProgressIndicator());
          },
        );
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
