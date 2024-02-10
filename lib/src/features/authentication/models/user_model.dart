import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? role;
  final String name;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      "Name": name,
      "Email-ID": email,
      "Password": password,
      "Role": role,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      role: data["Role"],
      name: data["Name"],
      email: data["Email-ID"],
      password: data["Password"],
    );
  }
}

class ScanResult {
  final String? id;
  final String result;
  // final String timeLine;

  const ScanResult({
    this.id,
    required this.result,
    // required this.timeLine,
  });

  toStoreResult(){
    return{
      "Eat": null,
      "Scan-Data": result,
      "Time": FieldValue.serverTimestamp(),
    };
  }
}
