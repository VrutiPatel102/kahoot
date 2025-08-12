import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view_controller.dart';

class ScoreboardController extends GetxController {
  QuizQuestionController get _qc => Get.find<QuizQuestionController>();

  bool isCorrect(int index) {
    return index == _qc.correctAnswerIndex;
  }

  int get userSelectedIndex => _qc.selectedOptionIndex.value;
  int get correctIndex => _qc.correctAnswerIndex;

  void nextBtn() {
    if (!_qc.isLastQuestion) {
      _qc.nextQuestion();
      Get.offNamed(AppRoute.queScreen);
    } else {
      Get.offNamed(AppRoute.finalRankScreen);
    }
  }
}
