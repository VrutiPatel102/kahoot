import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view_controller.dart';

class ScoreboardController extends GetxController {
  late QuizQuestionController _qc;
  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  @override
  void onInit() {
    super.onInit();
    _qc = Get.find<QuizQuestionController>();
  }

  Future<void> nextBtn() async {
    if (_qc.isLastQuestion) {
      // 🔥 Update Firestore stage to "final"
      await quizRef.doc(_qc.quizId).update({"quizStage": "final"});

      // Host goes to final rank screen
      Get.offNamed(AppRoute.finalRankScreen);
    } else {
      _qc.currentQuestionIndex.value++;
      _qc.loadQuestion();
      _qc.startTimer();

      // 🔥 Update Firestore stage to "question"
      await quizRef.doc(_qc.quizId).update({"quizStage": "question"});

      Get.offNamed(
        AppRoute.queScreen,
        arguments: {
          "questionIndex": _qc.currentQuestionIndex.value,
          "quizId": _qc.quizId,
          "pin": _qc.pin,
        },
      );
    }
  }

  /// ✅ Expose current question data
  Map<String, dynamic> get currentQuestion => _qc.currentQuestion;
  String get questionText => _qc.currentQuestion['questionText'] ?? "";
  List<String> get options =>
      List<String>.from(_qc.currentQuestion['options'] ?? []);

  /// ✅ Expose useful fields directly
  int get currentIndex => _qc.currentQuestionIndex.value;
  int get totalQuestions => _qc.totalQuestions;
  String get gamePin => _qc.pin;

  int get correctIndex => _qc.correctAnswerIndex;
  int get selectedIndex => _qc.selectedOptionIndex.value;
}
