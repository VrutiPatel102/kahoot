import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreStatusController extends GetxController{
  var score = 691.obs;
  var answerStreak = 1.obs;

  void setResult(int newScore, int streak) {
    score.value = newScore;
    answerStreak.value = streak;
  }
  @override
  void onInit() {
    super.onInit();
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(Duration(seconds: 3));
    print('Navigating to Show Option...');
    Get.toNamed(AppRoute.userRank);
  }
}