import 'package:acm_ioit/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LogInController extends GetxController{
  static LogInController get instance => Get.find();

  // TextField Controllers to get data from textfield
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  // Call function when submit button will press
  void logInUser(String name, String email, String password){
    AuthenticationRepository.instance.loginWithEmailAndPassword(name, email, password);
  }

}