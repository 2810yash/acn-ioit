import 'package:acm_ioit/src/constants/user_deatails.dart';
import 'package:acm_ioit/src/features/authentication/screens/home_screen/user_profile.dart';
import 'package:acm_ioit/src/repository/authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import '../../../../constants/colors.dart';
import '../../../../repository/scanner_firestore_repository/scanner_firestore_repository.dart';
import '../../models/user_model.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = "Welcome to QR scanner";
  var count = 0;
  final _scandb = FirebaseFirestore.instance;

  Future _scanQR() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      // If camera permission is not granted, request it.
      status = await Permission.camera.request();
      if (!status.isGranted) {
        // Permission denied by the user.
        Fluttertoast.showToast(
          msg: "QR code scanning requires camera permissions.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.black87,
        );
        return;
      }
    }

    try {
      String? cameraScanResult = await scanner.scan();
      setState(() async {
        result = cameraScanResult!;// setting string result with cameraScanResult
        scanResult = result;
        final Result = ScanResult(result: result);
        await _scandb.collection(globalUserName!).doc("${globalUserName} Scan Data ${count}").set(Result.toStoreResult());
        count++;
      });
    } on PlatformException catch (e) {
      print("${e.toString()}");
    }
  }

  Future<String?> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserEmail(),
      builder: (context, snapshot) {
        String? userEmail = snapshot.data;

       return Scaffold(
          drawer: Drawer(
            backgroundColor: BgColor,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: AccentColor,
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: LightColor,
                    foregroundImage: AssetImage(
                      'assets/images/about_logo.png',
                    ),
                  ),
                  accountName: Text(globalUserName.toString()),
                  accountEmail:
                  Text(userEmail ?? "No Email"), // Display email here
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.bubble_chart_rounded),
                  title: Text("About Us"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner),
                  title: Text("Scan QR"),
                  onTap: () {
                    _scanQR(); // calling function
                  },
                ),
                ListTile(
                    leading: Icon(Icons.account_circle_rounded),
                    title: Text("Profile"),
                    onTap: () => Get.to(UserProfile())),
                Divider(),
                ListTile(
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    AuthenticationRepository.instance.logout();
                    Navigator.of(context).pop(); // Close the drawer
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            centerTitle: true,
            title: const Text("QR Scanner"),
          ),
          body: Center(
            child: ListView(
              children: [
                Image.asset("assets/images/about_logo.png"),
                Text(
                  result, // Here the scanned result will be shown
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF000044),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: AccentColor,
            child: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              _scanQR(); // calling function
            },
          ),
        );
      },
    );
  }
}
