import 'package:acm_ioit/src/features/authentication/screens/home_screen/scanner_screen.dart';
import 'package:acm_ioit/src/features/authentication/screens/login_screen/login_screen.dart';
import 'package:acm_ioit/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/user_deatails.dart';
import '../../features/authentication/screens/home_screen/admin_scanner_screen.dart';
import 'exceptions/login_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Firebase Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationID = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const LogInScreen())
        : Get.offAll(() => ScannerScreen());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => ScannerScreen())
          : Get.to(() => LogInScreen());
    } on FirebaseAuthException catch (e) {
      final exception = SignUpWithEmailAndPasswordFailure.code(e.code);
      final error = "Firebase Auth Exception: ${exception.message}";
      print(error);
      print("**********************${e.toString()}");
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;
    } catch (_) {
      const exception = SignUpWithEmailAndPasswordFailure();
      print("Exception: ${exception.message}");
      Fluttertoast.showToast(
        msg: exception.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;
    }
  }

  Future<void> loginWithEmailAndPassword(String userName, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      globalUserName = userName;
      globalEmail = email;
      globalPassword = password;
      final user = _auth.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(userName)
            .doc("${userName} Data")
            .get();

        final role = userDoc.get('Role'); // Assuming you have a 'role' field in Firestore

        if (role == 'Admin') {
          Get.offAll(() => AdminScannerScreen());
        } else if (role == 'User') {
          Get.offAll(() => ScannerScreen());
        } else {
          print('Unknown role: $role');
        }
      }
    } on FirebaseAuthException catch (e) {
      final exception = LoginWithEmailAndPasswordFailure.code(e.code);
      final error = "Firebase Auth Exception: ${exception.message}";
      print(error);
      Fluttertoast.showToast(
        msg: e.code.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;    } catch (e) {
      final exception = LoginWithEmailAndPasswordFailure();
      print("Exception: ${exception.message}");
      print("******************${e.toString()}");
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      Get.snackbar(
        "Exception",
        exception.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.black87,
      );
      throw exception;    }
  }

  Future<void> logout() async => await _auth.signOut();
}
