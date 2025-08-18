import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowNickNameController extends GetxController {
  late String fullName;
  late String initial;

  @override
  void onInit() {
    super.onInit();

    // Get the full name from previous screen arguments
    fullName = Get.arguments['fullName'] ?? '';

    // Extract the first alphabet (uppercase)
    initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    // Navigate automatically to the next screen after a delay
    goToGetReadyScreen();
  }

  void goToGetReadyScreen() async {
    await Future.delayed(const Duration(seconds: 10));

    Get.toNamed(
      AppRoute.getReadyLoading, // Next screen route
      arguments: {'fullName': fullName, 'initial': initial},
    );
  }
}
