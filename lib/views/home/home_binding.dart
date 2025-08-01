import 'package:get/get.dart';
import 'package:kahoot_app/views/Home/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
