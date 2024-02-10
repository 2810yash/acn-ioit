import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/user_deatails.dart';

class UpdateData {
  String? result;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateDocuments() async {
    try {
      String? cameraScanResult = await scanner.scan();
      result = cameraScanResult;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(globalUserName!) // Replace with your collection name
          .where('Scan-Data', isEqualTo: result) // Replace 'scan-data' with your field name
          .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;
      print(documents);
      Fluttertoast.showToast(msg: documents.toString(),toastLength: Toast.LENGTH_LONG);
      // Update the matching documents
      for (final document in documents) {
        final reference = document.reference;
        await reference.update({
          'Eat': "True", // Replace with the field and new value you want to update
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error searching documents: $e',toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,);
      print('Error searching documents: $e');
    }
  }
}
