import 'package:get/get.dart';
import 'package:kahoot_app/views/show_nickname/show_nickname_controller.dart';

class JoinBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ShowNickNameController());
  }

}