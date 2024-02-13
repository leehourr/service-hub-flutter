import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/screen/auth/signup_screen.dart';
import 'package:service_hub/screen/chat_screen.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:service_hub/widget/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var logger = Logger();
  bool _isLoading = false;
  late int count = 0;
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // print('Sign Up button pressed');
    // BuildContext currentContext = context;
    try {
      setState(() {
        _isLoading = true;
        count++;
      });

      //test if the session correctly saved in local storage
      // if (count > 1) {
      //   final String? getToken = await _getSavedToken();
      //   logger.e('access token $getToken');
      //   return;
      // }
      final response = await apiService.login(
        account: _accountController.text,
        password: _passwordController.text,
      );
      // print(response.body);
      final Map<String, dynamic> body = json.decode(response.body);
      if (response.statusCode == 200) {
        final String accessToken = body['access_token'];
        await _saveTokenToSharedPreferences(accessToken);
        logger.e('Login successful $accessToken');
        logger.e('Login successful');
        _navigateToChatScreen();
      } else {
        // logger.e(response.body);

        showErrorMessage(body['errMessage']);
      }
    } catch (e, stackTrace) {
      // showErrorMessage('An error occurred: $e');
      logger.e('An error occurred: $e');
      logger.e(stackTrace);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToChatScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  void showErrorMessage(String errorMessage) {
    BuildContext currentContext = context;

    ScaffoldMessenger.of(currentContext).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveTokenToSharedPreferences(String accessToken) async {
    try {
      final SharedPreferences prefs = await _prefs;
      logger.e('passed token: $accessToken');
      await prefs.setString('jwt_token', accessToken);
    } catch (e) {
      logger.e('Error saving token to SharedPreferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Service Hub',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _accountController,
                          decoration: const InputDecoration(
                            labelText: 'Phone or username',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Placeholder color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone or username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black, // Placeholder color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            // Check if the password is 8 characters or longer
                            if (value.length < 8) {
                              return 'Password must be 8 characters or longer';
                            }
                            // Check if the password includes at least one numeric character
                            if (!RegExp(r'\d').hasMatch(value)) {
                              return 'Password must include at least one numeric character';
                            }
                            return null;
                          },
                        ),
                        // const SizedBox(height: 4.0),
                        // const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forget password action
                              // print('Forget Password clicked');
                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                            minimumSize: const Size.fromHeight(45),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _login();
                                  }
                                },
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),

                        const SizedBox(height: 16.0),
                        const Align(
                            alignment: Alignment.center, child: Text('Or')),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue, // Set your desired background color here
                                borderRadius: BorderRadius.circular(
                                    25.0), // Adjust the radius as needed
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.phone),
                                color: Colors.white,
                                // padding: const EdgeInsets.all(2.0),
                                tooltip: 'Phone',
                                onPressed: () {
                                  // print('Phone authentication clicked');
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFFEA4335), // Set your desired background color here
                                borderRadius: BorderRadius.circular(
                                    25.0), // Adjust the radius as needed
                              ),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.google),
                                color: Colors.white,
                                // padding: const EdgeInsets.all(2.0),
                                tooltip: 'Google',
                                onPressed: () {
                                  // print('Google authentication clicked');
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New user?',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()),
                                ); // print('Signup clicked');
                              },
                              child: const Text(
                                ' Signup',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
