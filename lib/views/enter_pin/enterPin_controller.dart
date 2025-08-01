import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterPinController extends GetxController {
  TextEditingController pinController = TextEditingController();

  void onEnterPin() {
    String pin = pinController.text.trim();
    if (pin.isNotEmpty) {
      Get.toNamed(AppRoute.enterNickName, arguments: {'pin': pin});
    } else {
      Get.snackbar(
        "Error",
        "Please enter a valid Game PIN",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors().red700,
        colorText: AppColors().white,
      );
    }
  }

  void login() {
    Get.toNamed(AppRoute.enterNickName);
  }
}
