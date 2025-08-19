import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class HomeController extends GetxController {
  void onJoinQuiz() {
    Get.toNamed(AppRoute.enterPin);
  }

  void onCreateQuiz() {
    Get.toNamed(AppRoute.createQuiz);
  }
}
