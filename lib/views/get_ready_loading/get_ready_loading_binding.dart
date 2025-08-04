import 'package:get/get.dart';
import 'package:kahoot_app/views/get_ready_loading/get_ready_loading_controller.dart';

class GetReadyLoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetReadyLoadingController());
  }
}
