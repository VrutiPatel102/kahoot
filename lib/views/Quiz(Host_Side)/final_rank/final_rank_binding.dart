import 'package:get/get.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/final_rank/final_rank_controller.dart';

class FinalRankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FinalRankController());
  }
}
