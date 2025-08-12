import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoadingPinController extends GetxController {
  Future<void> hostQuiz(String quizTitle) async {
    final pin = _generatePin();

    // Save quiz to Firestore
    await FirebaseFirestore.instance.collection('quizzes').doc(pin).set({
      'quizTitle': quizTitle,
      'pin': pin,
      'status': 'waiting', // waiting | started
      'players': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Navigate to quiz lobby
    Get.offNamed(AppRoute.quizLobbyScreen, arguments: {
      "quizTitle": quizTitle,
      "pin": pin,
      "isHost": true
    });
  }

  String _generatePin() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit pin
  }
}
