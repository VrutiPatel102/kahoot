import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ShowNickNameController extends GetxController {
  late String fullName;
  late String initial;

  @override
  void onInit() {
    super.onInit();
    fullName = Get.arguments['fullName'] ?? '';
    initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}
