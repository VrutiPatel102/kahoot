import 'package:get/get.dart';
import 'quiz_lobby_controller.dart';

class QuizLobbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizLobbyController>(() => QuizLobbyController());
  }
}
