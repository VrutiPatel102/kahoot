// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class EnterNickNameController extends GetxController {
//   final TextEditingController nicknameController = TextEditingController();
//
//   late String pin;
//   late String quizId;
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     pin = Get.arguments['pin'];
//     quizId = Get.arguments['quizId'];
//   }
//
//   Future<void> onSubmitNickname() async {
//     String nickname = nicknameController.text.trim();
//
//     if (nickname.isEmpty) {
//       Get.snackbar("Error", "Please enter a nickname");
//       return;
//     }
//
//     try {
//       await _firestore
//           .collection('quizzes')
//           .doc(quizId)
//           .collection('participants')
//           .add({
//         'nickname': nickname,
//         'joinedAt': FieldValue.serverTimestamp(),
//       });
//
//       Get.toNamed(
//         AppRoute.quizLobbyScreen,
//         arguments: {
//           'pin': pin,
//           'isHost': false,
//         },
//       );
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterNickNameController extends GetxController {
  final TextEditingController nicknameController = TextEditingController();

  late String pin;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    pin = Get.arguments['pin'];
  }

  Future<void> onSubmitNickname() async {
    String nickname = nicknameController.text.trim();

    if (nickname.isEmpty) {
      Get.snackbar("Error", "Please enter a nickname");
      return;
    }

    try {
      await _firestore
          .collection('quizzes')
          .doc(pin) // ✅ pin is the quiz document ID
          .collection('participants')
          .add({
            'nickname': nickname,
            'joinedAt': FieldValue.serverTimestamp(),
          });

      Get.toNamed(
        AppRoute.showNickName,
        arguments: {'pin': pin, 'isHost': false},
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
