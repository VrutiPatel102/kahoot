import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreboardController extends GetxController {
  var selectedAnswer = (-1).obs;
  var correctAnswerIndex = 2;

  void selectAnswer(int index) {
    selectedAnswer.value = index;
  }

  bool isCorrect(int index) {
    return index == correctAnswerIndex;
  }

  void nextBtn() {
    Get.toNamed(AppRoute.queScreen);
  }
}
