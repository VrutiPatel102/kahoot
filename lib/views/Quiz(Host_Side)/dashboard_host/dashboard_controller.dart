import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class HostDashboardController extends GetxController {
  void hostQuiz(String quizTitle) {
    Get.toNamed(AppRoute.loadingHostSide);
  }
}
