import 'package:get/get.dart';
import 'package:kahoot_app/views/enter_name/enterName_controller.dart';

class NickNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NickNameController());
  }
}
