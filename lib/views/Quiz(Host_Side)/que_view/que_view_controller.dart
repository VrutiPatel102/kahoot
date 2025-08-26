import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizQuestionController extends GetxController {
  final String quizId;
  final String pin;

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

  Map<String, dynamic> get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex.value] : {};

  String get gamePin => pin;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    int? startIndex = args?["questionIndex"];
    if (startIndex != null) {
      currentQuestionIndex.value = startIndex;
    }
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
          "answerIndex": (data["correctIndex"] is int)
              ? data["correctIndex"] as int
              : 0,
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

  void loadQuestion() {
    if (questions.isEmpty) return;

    final q = questions[currentQuestionIndex.value];
    questionText.value = q["question"] as String;
    options.value = List<String>.from(q["options"] as List<dynamic>);
    selectedOptionIndex.value = -1;
    remainingTime.value = totalTime;

    // ✅ Tell Firebase we are showing a question
    quizRef.doc(quizId).update({
      "quizStage": "question",
      "currentQuestionIndex": currentQuestionIndex.value,
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        goToScoreboard();
      }
    });
  }

  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  void submitAnswer() {
    _timer?.cancel();
    goToScoreboard();
  }

  void goToScoreboard() {
    // ✅ Update Firebase so users switch to ScoreStatus
    quizRef.doc(quizId).update({"quizStage": "scoreboard"});

    // Navigate host to scoreboard view
    Get.toNamed(AppRoute.scoreboardScreen, arguments: {"quizId": quizId});
  }

  int get correctAnswerIndex {
    return questions.isNotEmpty
        ? questions[currentQuestionIndex.value]["answerIndex"] as int
        : 0;
  }

  void reset() {
    currentQuestionIndex.value = 0;
    loadQuestion();
    startTimer();
    selectedOptionIndex.value = -1;
  }

  /// Call this when host presses "Next" on scoreboard
  void goToNextQuestion() {
    if (!isLastQuestion) {
      currentQuestionIndex.value++;
      loadQuestion();
      startTimer();
    } else {
      // ✅ Final stage
      quizRef.doc(quizId).update({"quizStage": "final"});
      Get.toNamed(AppRoute.finalRankScreen, arguments: {"quizId": quizId});
    }
  }
}
