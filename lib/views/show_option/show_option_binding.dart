import 'package:get/get.dart';
import 'package:kahoot_app/views/show_option/show_option_controller.dart';

class ShowOptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowOptionController>(() => ShowOptionController());
  }
}
