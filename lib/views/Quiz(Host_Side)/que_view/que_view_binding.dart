import 'package:get/get.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view_controller.dart';

class QueViewBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments ?? {};
    final quizId = args["quizId"] ?? "";

    Get.lazyPut(() => QuizQuestionController(quizId: quizId));
  }
}
