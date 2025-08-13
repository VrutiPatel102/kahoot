import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoadingPinController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    final quizTitle = args["quizTitle"] ?? "Quiz";
    hostQuiz(quizTitle);
  }

  Future<void> hostQuiz(String quizTitle) async {
    final pin = _generatePin();

    final quizRef = await FirebaseFirestore.instance.collection('quizzes').add({
      'quizTitle': quizTitle,
      'pin': pin,
      'status': 'waiting',
      'createdAt': FieldValue.serverTimestamp(),
    });

    Get.offNamed(
      AppRoute.quizLobbyScreen,
      arguments: {
        "quizTitle": quizTitle,
        "quizId": quizRef.id,
        "pin": pin,
        "isHost": true,
      },
    );
  }

  String _generatePin() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }
}
