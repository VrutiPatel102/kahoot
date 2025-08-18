import 'dart:async';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class CountdownController extends GetxController {
  var countdown = 3.obs;
  late String quizId;
  late String quizTitle;
  late bool isHost;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    quizTitle = args["quizTitle"] ?? "Quiz";
    isHost = args["isHost"] ?? false;
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        timer.cancel();
        Get.offNamed(
          AppRoute.queScreen,
          arguments: {
            "quizId": quizId,
            "quizTitle": quizTitle,
            "isHost": isHost,
          },
        );
      }
    });
  }
}
