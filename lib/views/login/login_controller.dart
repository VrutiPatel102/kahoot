import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void onLogin() {}

  void register() {
    Get.toNamed(AppRoute.register);
  }
}
