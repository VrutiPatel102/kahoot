import 'package:get/get.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/dashboard_host/dashboard_controller.dart';

class HostDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HostDashboardController());
  }
}
