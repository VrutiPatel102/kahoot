import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;

  void select(int index) {
    selectedIndex.value = index;

  }
  @override
  void onInit() {
    super.onInit();
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(Duration(seconds: 3));
    print('Navigating to Show Option...');
    Get.toNamed(AppRoute.scoreStatus);
  }
}
