import 'package:get/get.dart';
import 'package:kahoot_app/views/user_rank/user_rank_controller.dart';

class UserRankBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<UserRankController>(() => UserRankController(),);
  }
}