import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void onLogin() {
    Get.toNamed(AppRoute.login);
  }

  void register() {}
}
