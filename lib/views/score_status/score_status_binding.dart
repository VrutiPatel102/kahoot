import 'package:get/get.dart';
import 'package:kahoot_app/views/score_status/score_status_controller.dart';

class ScoreStatusBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ScoreStatusController>(() => ScoreStatusController(),);
  }
}