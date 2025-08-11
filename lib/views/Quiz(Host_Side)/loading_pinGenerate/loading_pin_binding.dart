import 'package:get/get.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/loading_pinGenerate/loading_pin_contoller.dart';

class LoadingPinBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoadingPinController());
  }
}
