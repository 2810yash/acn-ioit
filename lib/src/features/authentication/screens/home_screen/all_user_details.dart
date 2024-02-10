import 'package:acm_ioit/src/features/authentication/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/colors.dart';
import '../../models/user_model.dart';

class AllUserDetails extends StatefulWidget {
  const AllUserDetails({Key? key}) : super(key: key);

  @override
  State<AllUserDetails> createState() => _AllUserDetailsState();
}

class _AllUserDetailsState extends State<AllUserDetails> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile (Admin)"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: controller.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final userList = snapshot.data!;

              return ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: userList.length, // Set itemCount to the length of user list
                itemBuilder: (context, index) {
                  final user = userList[index];

                  return ListTile(
                    iconColor: AccentColor,
                    tileColor: Colors.blue.withOpacity(0.1),
                    leading: const Icon(Icons.verified_user),
                    title: Text("Name: ${user.name}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(user.role.toString()),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No user data available."),
              );
            }
          } else {
            // While fetching data, display a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
