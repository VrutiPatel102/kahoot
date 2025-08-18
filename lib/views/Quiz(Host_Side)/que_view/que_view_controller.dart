// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class QuizQuestionController extends GetxController {
//   final String quizId; // Pass quizId when creating controller
//   QuizQuestionController({required this.quizId});
//
//   var currentQuestionIndex = 0.obs;
//   var questionText = ''.obs;
//   var options = <String>[].obs;
//
//   final totalTime = 20;
//   var remainingTime = 20.obs;
//
//   var selectedOptionIndex = (-1).obs;
//   Timer? _timer;
//
//   var questions = <Map<String, dynamic>>[].obs;
//
//   int get totalQuestions => questions.length;
//   bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchQuestions();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   /// Fetch quiz questions from Firestore
//   Future<void> fetchQuestions() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(quizId)
//           .collection('questions')
//           .get();
//
//       questions.value = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           "question": data["questionText"] ?? "",
//           "options": List<String>.from(data["options"] ?? []),
//           "answerIndex": data["correctIndex"] ?? 0,
//         };
//       }).toList();
//
//       if (questions.isNotEmpty) {
//         loadQuestion();
//         startTimer();
//       } else {
//         print("No questions found for quiz: $quizId");
//       }
//     } catch (e) {
//       print("Error fetching questions: $e");
//     }
//   }
//
//   /// Load current question into UI
//   void loadQuestion() {
//     if (questions.isEmpty) return;
//
//     final q = questions[currentQuestionIndex.value];
//     questionText.value = q["question"] as String;
//     options.value = List<String>.from(q["options"] as List<dynamic>);
//     selectedOptionIndex.value = -1;
//     remainingTime.value = totalTime;
//   }
//
//   /// Start countdown timer for each question
//   void startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (remainingTime.value > 0) {
//         remainingTime.value--;
//       } else {
//         timer.cancel();
//         if (isLastQuestion) {
//           Get.toNamed(AppRoute.scoreboardScreen);
//         } else {
//           nextQuestion();
//         }
//       }
//     });
//   }
//
//   /// When user selects an answer
//   void selectOption(int index) {
//     selectedOptionIndex.value = index;
//   }
//
//   /// Submit the answer and move to next or end quiz
//   void submitAnswer() {
//     _timer?.cancel();
//     if (isLastQuestion) {
//       Get.toNamed(AppRoute.scoreboardScreen);
//     } else {
//       nextQuestion();
//     }
//   }
//
//   /// Move to the next question
//   void nextQuestion() {
//     if (!isLastQuestion) {
//       currentQuestionIndex.value++;
//       loadQuestion();
//       startTimer();
//     }
//   }
//
//   /// Get correct answer for current question
//   int get correctAnswerIndex {
//     return questions.isNotEmpty
//         ? questions[currentQuestionIndex.value]["answerIndex"] as int
//         : 0;
//   }
//
//   /// Reset quiz for replay
//   void reset() {
//     currentQuestionIndex.value = 0;
//     loadQuestion();
//     startTimer();
//     selectedOptionIndex.value = -1;
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizQuestionController extends GetxController {
  final String quizId;
  final String pin; // 👈 added pin

  QuizQuestionController({required this.quizId, required this.pin});

  var currentQuestionIndex = 0.obs;
  var questionText = ''.obs;
  var options = <String>[].obs;

  final totalTime = 20;
  var remainingTime = 20.obs;

  var selectedOptionIndex = (-1).obs;
  Timer? _timer;

  var questions = <Map<String, dynamic>>[].obs;

  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Fetch quiz questions from Firestore
  Future<void> fetchQuestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();

      questions.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "question": data["questionText"] ?? "",
          "options": List<String>.from(data["options"] ?? []),
          "answerIndex": data["correctIndex"] ?? 0,
        };
      }).toList();

      if (questions.isNotEmpty) {
        loadQuestion();
        startTimer();
      } else {
        print("No questions found for quiz: $quizId");
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  /// Load current question into UI
  void loadQuestion() {
    if (questions.isEmpty) return;

    final q = questions[currentQuestionIndex.value];
    questionText.value = q["question"] as String;
    options.value = List<String>.from(q["options"] as List<dynamic>);
    selectedOptionIndex.value = -1;
    remainingTime.value = totalTime;
  }

  /// Start countdown timer for each question
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        if (isLastQuestion) {
          Get.toNamed(AppRoute.scoreboardScreen);
        } else {
          nextQuestion();
        }
      }
    });
  }

  /// When user selects an answer
  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  /// Submit the answer and move to next or end quiz
  void submitAnswer() {
    _timer?.cancel();
    if (isLastQuestion) {
      Get.toNamed(AppRoute.scoreboardScreen);
    } else {
      nextQuestion();
    }
  }

  /// Move to the next question
  void nextQuestion() {
    if (!isLastQuestion) {
      currentQuestionIndex.value++;
      loadQuestion();
      startTimer();
    }
  }

  /// Get correct answer for current question
  int get correctAnswerIndex {
    return questions.isNotEmpty
        ? questions[currentQuestionIndex.value]["answerIndex"] as int
        : 0;
  }

  /// Reset quiz for replay
  void reset() {
    currentQuestionIndex.value = 0;
    loadQuestion();
    startTimer();
    selectedOptionIndex.value = -1;
  }
}
