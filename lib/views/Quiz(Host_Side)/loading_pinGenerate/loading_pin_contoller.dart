import 'dart:math';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoadingPinController extends GetxController {
  void hostQuiz(String quizTitle) async {
    Get.toNamed(AppRoute.quizLobbyScreen);

    await Future.delayed(Duration(seconds: 2));

    final pin = _generatePin();

    Get.offNamed(
      '/quiz-lobby',
      arguments: {"quizTitle": quizTitle, "pin": pin},
    );
  }

  int _generatePin() {
    final random = Random();
    return 100000 + random.nextInt(900000);
  }
}
