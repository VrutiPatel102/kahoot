import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class HostDashboardController extends GetxController {
  var generatedPin = ''.obs;

  Future<void> hostQuiz(String quizTitle, String quizId) async {
    try {
      final pin = await _generateUniquePin(6);
      generatedPin.value = pin;

      final quizRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId);

      await quizRef.update({
        'pin': pin,
        'quizStarted': false,
        'currentQuestionIndex': 0,
        'status': 'inLobby',
        'createdAt': FieldValue.serverTimestamp(),
        'host': {'name': 'Host', 'joinedAt': FieldValue.serverTimestamp()},
      });

      Get.offNamed(
        AppRoute.loadingHostSide,
        arguments: {
          "quizTitle": quizTitle,
          "quizId": quizId,
          "pin": pin,
          "isHost": true,
          "playerName": "Host",
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to host quiz: $e");
    }
  }

  /// Generate a unique pin that doesn’t collide with existing quiz pins
  Future<String> _generateUniquePin(int length) async {
    String pin;
    bool exists = true;

    do {
      pin = _generatePin(length);
      final query = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('pin', isEqualTo: pin)
          .get();

      exists = query.docs.isNotEmpty;
    } while (exists);

    return pin;
  }

  /// Random pin generator
  String _generatePin(int length) {
    final random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }
}
