import 'package:get/get.dart';
import 'package:kahoot_app/views/que_loading/que_loading_controller.dart';

class QueLoadingBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<QueLoadingController>(() =>QueLoadingController() ,);
  }
}