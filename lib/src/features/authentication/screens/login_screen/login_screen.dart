import 'package:acm_ioit/src/features/authentication/screens/signup_screen/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/colors.dart';
import '../../controllers/login_controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  bool _obscureText = true;
  final role = FirebaseFirestore.instance;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    final _LoginformKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _LoginformKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0), // Adjust the spacing as needed
              TextFormField(
                controller: controller.name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "First name",
                  filled: true,
                  fillColor: SecondaryColor.withOpacity(0.5),
                  border: InputBorder.none, // Remove the border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),const SizedBox(height: 20.0), // Adjust the spacing as needed
              TextFormField(
                controller: controller.email,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Email-ID",
                  filled: true,
                  fillColor: SecondaryColor.withOpacity(0.5),
                  border: InputBorder.none, // Remove the border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0), // Add space between fields
              TextFormField(
                controller: controller.password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Password",
                  filled: true,
                  fillColor: SecondaryColor.withOpacity(0.5),
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0), // Add space between fields
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_LoginformKey.currentState!.validate()) {
                      LogInController.instance.logInUser(
                          controller.name.text.trim(),
                          controller.email.text.trim(),
                          controller.password.text.trim());
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),

              // SignUP button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      });
                    },
                    child: Text("SignUp")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
