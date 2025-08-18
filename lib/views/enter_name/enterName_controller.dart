import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class EnterNickNameController extends GetxController {
  final TextEditingController nicknameController = TextEditingController();

  late String pin;
  late String quizId;

  @override
  void onInit() {
    super.onInit();
    pin = Get.arguments['pin'] ?? '';
    quizId = Get.arguments['quizId'] ?? '';
  }

  Future<void> onSubmitNickname() async {
    String nickname = nicknameController.text.trim();

    if (nickname.isEmpty) {
      Get.snackbar("Error", "Please enter a nickname");
      return;
    }

    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('participants')
          .add({
            'nickname': nickname,
            'joinedAt': FieldValue.serverTimestamp(),
          });

      Get.toNamed(
        AppRoute.showNickName,
        arguments: {'fullName': nickname, 'quizId': quizId},
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
