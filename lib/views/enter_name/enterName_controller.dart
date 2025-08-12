import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterNameController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  late String pin;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the pin from route arguments
    final args = Get.arguments ?? {};
    pin = args['pin'] ?? '';

    if (pin.isEmpty) {
      Get.snackbar("Error", "No PIN found. Please go back and enter it again.");
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRoute.enterPin);
      });
    }
  }

  Future<void> submitNickname() async {
    String nickname = nameController.text.trim();

    if (nickname.isEmpty) {
      Get.snackbar("Error", "Please enter a nickname");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('quizzes').doc(pin).update({
        'players': FieldValue.arrayUnion([nickname]),
      });

      Get.toNamed(AppRoute.quizLobbyScreen, arguments: {
        "pin": pin,
        "isHost": false
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to join quiz: $e");
    }
  }
}
