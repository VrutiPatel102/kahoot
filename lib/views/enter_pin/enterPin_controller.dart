import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterPinController extends GetxController {
  final TextEditingController pinController = TextEditingController();

  Future<void> onEnterPin() async { // renamed to match UI call
    String pin = pinController.text.trim();
    if (pin.isEmpty) {
      Get.snackbar("Error", "Please enter a PIN");
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(pin)
        .get();

    if (doc.exists) {
      Get.toNamed(AppRoute.enterNickName, arguments: {'pin': pin});
    } else {
      Get.snackbar("Invalid PIN", "Please enter a valid game PIN");
    }
  }

  void login() {
    // Optional: Navigate to login screen
    Get.toNamed(
      AppRoute.login,
      arguments: {'pin': pinController.text},
    );  }
}
