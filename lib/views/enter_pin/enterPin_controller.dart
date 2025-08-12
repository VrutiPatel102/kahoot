import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterPinController extends GetxController {
  TextEditingController pinController = TextEditingController();
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Called when player enters a PIN
  Future<void> onEnterPin() async {
    final enteredPin = pinController.text.trim();

    if (enteredPin.isEmpty) {
      Get.snackbar("Error", "Please enter a game PIN");
      return;
    }

    isLoading.value = true;

    try {
      final snapshot = await _firestore
          .collection('quizzes')
          .where('pin', isEqualTo: enteredPin)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        Get.snackbar("Error", "Invalid PIN. Please check and try again.");
        isLoading.value = false;
        return;
      }

      // If valid PIN found, navigate
      Get.toNamed(
        '/enterNickname', // Replace with your actual nickname route
        arguments: {
          'pin': enteredPin,
          'isHost': false,
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Host login button action
  void login() {
    Get.toNamed('/login'); // Replace with your actual login route
  }
}

