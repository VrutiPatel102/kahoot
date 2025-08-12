import 'package:get/get.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/scoreboard_view/scoreboard_controller.dart';

class ScoreboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScoreboardController());
  }
}
