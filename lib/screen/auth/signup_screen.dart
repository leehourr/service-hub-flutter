import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:service_hub/screen/auth/login_screen.dart';
import 'package:service_hub/service/api_service.dart';
import 'package:logger/logger.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var logger = Logger();
  bool _isLoading = false;

  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // print('Sign Up button pressed');
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await apiService.signUp(
        name: _nameController.text,
        phoneNumber: '0${_phoneController.text}',
        password: _passwordController.text,
      );
      // print(response.body);

      if (response.statusCode == 200) {
        logger.e('Signup successful');
      } else {
        // logger.e(response.body);
        final Map<String, dynamic> body = json.decode(response.body);

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

  void showErrorMessage(String errorMessage) {
    BuildContext currentContext = context;

    ScaffoldMessenger.of(currentContext).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          reverse: true,
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              30.0,
              30.0,
              30.0,
              MediaQuery.of(context).viewInsets.bottom,
            ),
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black, // Placeholder color
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black, // Placeholder color
                          ),
                          prefixText: '+855 ',
                          prefixStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          // Check if the entered value contains only numeric characters
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          if (!RegExp(
                                  r'^(1[^9]|3[18]|6[^2-5]|7[016-8]|8[^2]|9[^4])\d{6,7}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid phone number format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
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
                          if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$')
                              .hasMatch(value)) {
                            return 'Password must start with an uppercase with numeric';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        // controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black, // Placeholder color
                          ),
                        ),
                        validator: (value) {
                          //check if confirm passord matches
                          if (value != _passwordController.text ||
                              value == null ||
                              value.isEmpty) {
                            return 'Passwords do not match';
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
                                  _signUp();
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
                                'Sign up',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),

                      const SizedBox(height: 10.0),
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //         bottom:
                      //             MediaQuery.of(context).viewInsets.bottom)),
                      const Align(
                          alignment: Alignment.center, child: Text('Or')),
                      const SizedBox(height: 10.0),
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
                            'Already a user?',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              ' Login',
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
        ));
  }
}
