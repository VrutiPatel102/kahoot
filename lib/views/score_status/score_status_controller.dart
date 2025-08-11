import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/que_loading/que_loading_controller.dart';

class ScoreStatusController extends GetxController {
  var score = 691.obs;
  var answerStreak = 1.obs;

  void setResult(int newScore, int streak) {
    score.value = newScore;
    answerStreak.value = streak;
  }

  @override
  void onReady() {
    super.onReady();
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(const Duration(seconds: 3));

    QueLoadingController.loopCount++;

    if (QueLoadingController.loopCount < 3) {
      Get.offNamed(AppRoute.queLoading, preventDuplicates: false);
    } else {
      Get.offNamed(AppRoute.userRank);
    }
  }
}
