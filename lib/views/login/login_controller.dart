import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  void onLogin() {
    final pin = pinController.text.trim();

    if (pin.isEmpty) {
      Get.snackbar("Error", "Please enter a PIN");
      return;
    }

    Get.toNamed(
      AppRoute.quizLobbyScreen,
      arguments: {
        'pin': pin,
        'isHost': true,
      },
    );
  }

  void register() {
    Get.toNamed(AppRoute.register);
  }
}
