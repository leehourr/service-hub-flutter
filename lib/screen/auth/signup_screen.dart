import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
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
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black, // Placeholder color
                          ),
                          prefixText: '+855 ',
                          prefixStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          // Check if the entered value contains only numeric characters
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: passwordController,
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Validation passed, handle Signup
                            final username = usernameController.text;
                            final password = passwordController.text;

                            // Replace this with your authentication logic
                            // print('Username: $username, Password: $password');
                          }
                        },
                        child: const Text(
                          'Sign up',
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
                            'Already a user?',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle signup action
                              // print('Signup clicked');
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
