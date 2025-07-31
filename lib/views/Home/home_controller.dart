import 'package:get/get.dart';

class HomeController extends GetxController {
  void onJoinQuiz() {
    Get.toNamed('/joinQuiz');
  }

  void onCreateQuiz() {
    Get.toNamed('/createQuiz');
  }
}
