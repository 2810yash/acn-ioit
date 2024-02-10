import 'package:acm_ioit/src/features/authentication/models/user_model.dart';
import 'package:acm_ioit/src/repository/authentication_repository/authentication_repository.dart';
import 'package:acm_ioit/src/repository/user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  // TextField Controllers to get data from textfield
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  // Call function when submit button will press
  void registerUser(String email, String password){
    String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if(error != null){
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
    // AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  Future<void> createUser(UserModel user) async {
    String userName = user.name;
    await userRepo.createUser(user,userName);
    SignUpController.instance.registerUser(user.email, user.password);
  }

}