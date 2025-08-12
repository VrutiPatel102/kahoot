import 'dart:async';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class CountdownController extends GetxController {
  var countdown = 3.obs;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        timer.cancel();
        Get.offNamed(AppRoute.queScreen);
      }
    });
  }
}
