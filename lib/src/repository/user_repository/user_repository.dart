import 'package:acm_ioit/src/features/authentication/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user, String userName) async {
    await _db.collection(userName).doc("${userName}'s Data").set(user.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Your account has been created",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue[100],
        colorText: Colors.green,
      );
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong, Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[200],
          colorText: Colors.blue);
      print("Error: ${error}");
    });
  }

  Future<UserModel> getUserDetails(String email, String userName) async{
    final snapshot = await _db.collection(userName).where("Email-ID",isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUser(String userName) async{
    final snapshot = await _db.collection(userName).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  // scanData(String scanResult) async {
  //   await _scandb.collection("Scan-Data").doc(AutofillHints.username)
  // }
  // scanData(String documentId, Map<String, dynamic> data) async {
  //   await _scandb.collection("Scan-Data").doc(documentId).set(data).then((_) {
  //     Get.snackbar(
  //       "Success",
  //       "Scan data has been saved",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.blue[100],
  //       colorText: Colors.green,
  //     );
  //   }).catchError((error, stackTrace) {
  //     Get.snackbar(
  //       "Error",
  //       "Something went wrong, Try again",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red[200],
  //       colorText: Colors.blue,
  //     );
  //     print("Error: $error");
  //   });
  // }

}
