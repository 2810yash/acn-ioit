import 'package:acm_ioit/src/features/authentication/controllers/profile_controller.dart';
import 'package:acm_ioit/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userdata = snapshot.data as UserModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 140.0,
                        child: Image.asset("assets/images/about_logo.png"),
                      ),
                      const SizedBox(height: 40.0),
                      Container(
                        child: Center(
                          child: Text(("Name: ${userdata.name}")),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        height: 45.0,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        child: Center(
                          child: Text("Email-ID: ${userdata.email}"),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        height: 45.0,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        child: Center(
                          child: Text("Role: ${userdata.role.toString()}"),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        height: 45.0,
                      ),
                      // TextFormField(
                      //   keyboardType: TextInputType.text,
                      //   decoration: InputDecoration(
                      //     // labelText: "First name",
                      //     hintText: "Role",
                      //     filled: true,
                      //     fillColor: SecondaryColor.withOpacity(0.5),
                      //     border: InputBorder.none, // Remove the border
                      //   ),
                      // )
                    ],
                  );
                }
              }
              return Text("data");
            },
          ),
        ),
      ),
    );
  }
}
