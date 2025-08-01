import 'package:get/get.dart';

class HomeController extends GetxController {
  void onJoinQuiz() {
    Get.toNamed('/enterPin');
  }

  void onCreateQuiz() {
    Get.toNamed('/createQuiz');
  }
}
