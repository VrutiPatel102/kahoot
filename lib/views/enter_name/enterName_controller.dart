import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:uuid/uuid.dart';

class EnterNickNameController extends GetxController {
  final TextEditingController nicknameController = TextEditingController();

  late String pin;
  late String quizId;

  final _uuid = Uuid();

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
      // generate a unique userId (not FirebaseAuth)
      final userId = _uuid.v4();

      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('participants')
          .doc(userId) // ✅ instead of .add()
          .set({
            'nickname': nickname,
            'joinedAt': FieldValue.serverTimestamp(),
            'score': 0, // initialize score
            'correctAnswers': 0,
            'wrongAnswers': 0,
          });

      // pass both quizId & userId forward
      Get.toNamed(
        AppRoute.showNickName,
        arguments: {
          'quizId': quizId,
          'pin': pin,
          'userId': userId,
          'nickname': nickname,
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
      debugPrint("❌ EnterNickName error: $e");
    }
  }
}
