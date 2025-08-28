// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class EnterPinController extends GetxController {
//   TextEditingController pinController = TextEditingController();
//   var isLoading = false.obs;
//
//   Future<void> onEnterPin() async {
//     final enteredPin = pinController.text.trim();
//
//     if (enteredPin.isEmpty) {
//       Get.snackbar("Error", "Please enter a game PIN");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .where('pin', isEqualTo: enteredPin)
//           .limit(1)
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         Get.snackbar("Error", "Invalid PIN. Please check and try again.");
//         isLoading.value = false;
//         return;
//       }
//
//       // Get quiz data & ID
//       final quizDoc = snapshot.docs.first;
//       final quizData = quizDoc.data();
//       final quizId = quizDoc.id;
//
//       Get.toNamed(
//         AppRoute.enterNickName,
//         arguments: {
//           'pin': enteredPin,
//           'quizId': quizId,
//           'quizTitle': quizData['quizTitle'] ?? 'Quiz',
//           'isHost': false,
//         },
//       );
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void login() {
//     Get.toNamed(AppRoute.login);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterPinController extends GetxController {
  TextEditingController pinController = TextEditingController();
  var isLoading = false.obs;

  Future<void> onEnterPin() async {
    final enteredPin = pinController.text.trim();

    if (enteredPin.isEmpty) {
      Get.snackbar("Error", "Please enter a game PIN");
      return;
    }

    isLoading.value = true;

    try {
      // find quiz by pin
      final snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('pin', isEqualTo: enteredPin)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        Get.snackbar("Error", "Invalid PIN. Please check and try again.");
        isLoading.value = false;
        return;
      }

      // quiz doc
      final quizDoc = snapshot.docs.first;
      final quizData = quizDoc.data();
      final quizId = quizDoc.id;

      // Navigate to nickname screen
      Get.toNamed(
        AppRoute.enterNickName,
        arguments: {
          'pin': enteredPin,
          'quizId': quizId,
          'quizTitle': quizData['quizTitle'] ?? 'Quiz',
          'isHost': false,
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
      debugPrint("❌ EnterPin error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void login() {
    Get.toNamed(AppRoute.login);
  }
}
