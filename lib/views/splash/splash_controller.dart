import 'package:get/get.dart';
import 'dart:async';

import 'package:kahoot_app/routes/app_route.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      Get.toNamed(AppRoute.home);
    });
    super.onInit();
  }
}
