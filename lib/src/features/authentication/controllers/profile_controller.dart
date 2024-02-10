import 'package:acm_ioit/src/repository/authentication_repository/authentication_repository.dart';
import 'package:acm_ioit/src/repository/user_repository/user_repository.dart';
import 'package:get/get.dart';

import '../../../constants/user_deatails.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final userName = globalUserName ?? 'Users';

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email, userName);
    }else{
      Get.snackbar("Error", "Login to continue");
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.allUser(userName);
  }
}