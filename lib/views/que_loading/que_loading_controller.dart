import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QueLoadingController extends GetxController {
  static int loopCount = 0; // Tracks repetitions

  @override
  void onReady() {
    super.onReady();
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(AppRoute.showOption, preventDuplicates: false);
  }
}
