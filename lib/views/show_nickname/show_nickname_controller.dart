import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowNickNameController extends GetxController {
  late String fullName;
  late String initial;

  @override
  void onInit() {
    super.onInit();
    fullName = Get.arguments['fullName'] ?? '';
    initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    goToGetReadyScreen();
  }

  void goToGetReadyScreen() async {
    await Future.delayed( Duration(seconds: 5));
    Get.toNamed(AppRoute.getReadyLoading);
  }
}
