import 'package:get/get.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;

  void select(int index) {
    selectedIndex.value = index;
    // Optional: Add timer or navigation logic here
  }
}
