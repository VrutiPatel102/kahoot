import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_app/routes/app_route.dart';

class LoadingPinController extends GetxController {
  late final Map<String, dynamic> args;
  final _firestore = FirebaseFirestore.instance;

  var pin = "".obs;

  @override
  void onInit() {
    super.onInit();
    args = Map<String, dynamic>.from(Get.arguments ?? {});

    _generatePin();
  }

  Future<void> _generatePin() async {
    try {
      final generatedPin =
          (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
              .toString();
      pin.value = generatedPin;

      await _firestore.collection('quizzes').doc(args['quizId']).update({
        'pin': generatedPin,
        'isActive': true,
      });

      args['pin'] = generatedPin;

      Get.offNamed(AppRoute.quizLobbyScreen, arguments: args);
    } catch (e) {
      print("Error generating PIN: $e");
    }
  }
}
