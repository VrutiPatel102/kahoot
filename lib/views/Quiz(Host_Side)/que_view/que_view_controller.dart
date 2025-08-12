import 'dart:async';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizQuestionController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var questionText = ''.obs;
  var options = <String>[].obs;

  final totalTime = 20;
  var remainingTime = 20.obs;

  var selectedOptionIndex = (-1).obs;

  Timer? _timer;

  final questions = [
    {
      "question": "What is Flutter?",
      "options": ["Framework", "Library", "Language", "Tool"],
      "answerIndex": 0,
    },
    {
      "question": "Who developed Dart?",
      "options": ["Google", "Microsoft", "Apple", "Facebook"],
      "answerIndex": 0,
    },
    {
      "question": "What is GetX?",
      "options": ["State management", "Database", "OS", "Language"],
      "answerIndex": 0,
    },
    {
      "question": "Which widget is immutable?",
      "options": ["StatelessWidget", "StatefulWidget", "Both", "None"],
      "answerIndex": 0,
    },
    {
      "question": "Which company owns Flutter?",
      "options": ["Google", "Meta", "Amazon", "Microsoft"],
      "answerIndex": 0,
    },
  ];

  int get totalQuestions => questions.length;

  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  @override
  void onInit() {
    super.onInit();
    loadQuestion();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void loadQuestion() {
    final q = questions[currentQuestionIndex.value];
    questionText.value = q["question"] as String;
    options.value = List<String>.from(q["options"] as List<dynamic>);
    selectedOptionIndex.value = -1;
    remainingTime.value = totalTime;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        Get.toNamed(AppRoute.scoreboardScreen);
      }
    });
  }

  void submitAnswer() {
    _timer?.cancel();
    Get.toNamed(AppRoute.scoreboardScreen);
  }

  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      currentQuestionIndex.value++;
      loadQuestion();
      startTimer();
    }
  }

  int get correctAnswerIndex {
    return questions[currentQuestionIndex.value]["answerIndex"] as int;
  }

  void reset() {
    currentQuestionIndex.value = 0;
    loadQuestion();
    startTimer();
    selectedOptionIndex.value = -1;
  }
}
