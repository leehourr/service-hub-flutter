import 'package:flutter/material.dart';
import 'package:service_hub/screen/auth/login_screen.dart';
import 'package:service_hub/screen/auth/signup_screen.dart';
import 'package:service_hub/screen/chat_screen.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/chat/chat_list.dart';
import 'package:service_hub/widget/home.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
