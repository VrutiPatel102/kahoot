import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class HostDashboardController extends GetxController {
  var generatedPin = ''.obs;
  var tempQuestions = <Map<String, dynamic>>[].obs;

  void addTempQuestion(
    String question,
    List<String> options,
    int correctIndex,
  ) {
    if (question.isNotEmpty && options.any((o) => o.isNotEmpty)) {
      tempQuestions.add({
        "questionText": question,
        "options": options,
        "correctIndex": correctIndex,
      });
    }
  }

  Future<void> saveQuiz(String title) async {
    if (title.isEmpty || tempQuestions.isEmpty) {
      Get.snackbar("Error", "Please add a title and at least one question.");
      return;
    }

    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc();

    await quizRef.set({
      "title": title,
      "createdAt": FieldValue.serverTimestamp(),
    });

    for (var q in tempQuestions) {
      await quizRef.collection("questions").add(q);
    }

    tempQuestions.clear();
    Get.snackbar("Success", "Quiz saved successfully!");
  }

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

  /// ✅ Delete quiz and its questions
  Future<void> deleteQuiz(String quizId) async {
    try {
      final quizRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId);

      // delete all questions inside quiz
      final questions = await quizRef.collection("questions").get();
      for (var doc in questions.docs) {
        await doc.reference.delete();
      }

      // delete quiz
      await quizRef.delete();

      Get.snackbar("Deleted", "Quiz deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete quiz: $e");
    }
  }

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

  String _generatePin(int length) {
    final random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }
}
