import 'package:get/get.dart';

class QuizQuestionController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var totalQuestions = 5;
  var questionText = ''.obs;
  var options = <String>[].obs;

  var totalTime = 20;
  var remainingTime = 10.obs;

  var selectedOptionIndex = (-1).obs; // -1 means nothing selected

  // Sample question list
  final questions = [
    {
      "question": "What is Flutter?",
      "options": ["Framework", "Library", "Language", "Tool"],
    },
    {
      "question": "Who developed Dart?",
      "options": ["Google", "Microsoft", "Apple", "Facebook"],
    },
    {
      "question": "What is GetX?",
      "options": ["State management", "Database", "OS", "Language"],
    },
    {
      "question": "Which widget is immutable?",
      "options": ["StatelessWidget", "StatefulWidget", "Both", "None"],
    },
    {
      "question": "Which company owns Flutter?",
      "options": ["Google", "Meta", "Amazon", "Microsoft"],
    },
  ];

  @override
  void onInit() {
    super.onInit();
    loadQuestion();
    startTimer();
  }

  void loadQuestion() {
    questionText.value =
        questions[currentQuestionIndex.value]["question"]! as String;
    options.value = List<String>.from(
      questions[currentQuestionIndex.value]["options"]! as List<dynamic>,
    );
    selectedOptionIndex.value = -1;
    remainingTime.value = totalTime;
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (remainingTime.value > 0) {
        remainingTime.value--;
        return true;
      } else {
        nextQuestion();
        return false;
      }
    });
  }

  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
      loadQuestion();
      startTimer();
    } else {
      // Quiz finished
      Get.snackbar("Quiz", "You have completed the quiz!");
    }
  }

  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  void goToNextQuestion() => nextQuestion();
}
