import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/routes/app_route.dart';

class NickNameController extends GetxController {
  TextEditingController nameController = TextEditingController();
  void onEnterName() {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      Get.toNamed(AppRoute.home);
    } else {
      Get.snackbar(
        "Error",
        "Please enter a name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors().red700,
        colorText: AppColors().white,
      );
    }
  }
}
