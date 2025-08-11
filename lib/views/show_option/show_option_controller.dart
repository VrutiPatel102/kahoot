import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;

  void select(int index) {
    selectedIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
    simulateLoading();
  }

  void simulateLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(AppRoute.scoreStatus, preventDuplicates: false);
  }
}
