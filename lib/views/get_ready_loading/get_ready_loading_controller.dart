import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class GetReadyLoadingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('GetReadyLoadingController initialized');
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(Duration(seconds: 8));
    print('Navigating to Home...');
    Get.toNamed(AppRoute.queLoading);
  }
}
