import 'package:acm_ioit/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/colors.dart';
import '../../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
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
              ),
              const SizedBox(height: 20.0),
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
                    if (_formKey.currentState!.validate()) {
                      // SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                      final user = UserModel(
                        name: controller.name.text.trim(),
                        email: controller.email.text.trim(),
                        password: controller.password.text.trim(),
                        role: null,
                      );
                      SignUpController.instance.createUser(user);
                    }
                  },
                  // onPressed: () => Get.to(ScannerScreen()),
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScannerScreen()));
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
