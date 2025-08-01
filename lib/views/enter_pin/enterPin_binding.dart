import 'package:get/get.dart';
import 'package:kahoot_app/views/enter_pin/enterPin_controller.dart';

class EnterPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EnterPinController());
  }
}
