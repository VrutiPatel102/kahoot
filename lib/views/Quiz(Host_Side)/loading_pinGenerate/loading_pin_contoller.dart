// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class LoadingPinController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     final quizTitle = args["quizTitle"] ?? "Quiz";
//     hostQuiz(quizTitle);
//   }
//
//   Future<void> hostQuiz(String quizTitle) async {
//     final pin = _generatePin();
//
//     final quizRef = await FirebaseFirestore.instance.collection('quizzes').add({
//       'quizTitle': quizTitle,
//       'pin': pin,
//       'quizStarted': false,
//       'status': 'waiting',
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//
//     Get.offNamed(
//       AppRoute.quizLobbyScreen,
//       arguments: {
//         "quizTitle": quizTitle,
//         "quizId": quizRef.id,
//         "pin": pin,
//         "isHost": true,
//       },
//     );
//   }
//
//   String _generatePin() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }
// }
//
// //
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class LoadingPinController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     final quizTitle = args["quizTitle"] ?? "Quiz";
//     final hostName = args["playerName"] ?? "Host";
//     hostQuiz(quizTitle, hostName);
//   }
//
//   Future<void> hostQuiz(String quizTitle, String hostName) async {
//     try {
//       final pin = _generatePin();
//
//       // Create quiz document
//       final quizRef = await FirebaseFirestore.instance
//           .collection('quizzes')
//           .add({
//             'quizTitle': quizTitle,
//             'pin': pin,
//             'quizStarted': false,
//             'status': 'waiting',
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//
//       // Add host to participants subcollection
//       await quizRef.collection('participants').add({
//         'nickname': hostName,
//         'joinedAt': FieldValue.serverTimestamp(),
//       });
//
//       // Navigate to lobby
//       Get.offNamed(
//         AppRoute.quizLobbyScreen,
//         arguments: {
//           "quizTitle": quizTitle,
//           "quizId": quizRef.id,
//           "pin": pin,
//           "isHost": true,
//           "playerName": hostName,
//         },
//       );
//     } catch (e) {
//       Get.snackbar("Error", "Failed to create quiz: $e");
//     }
//   }
//
//   String _generatePin() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }
// }
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
      // Example: random 6-digit PIN
      final generatedPin =
          (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
              .toString();
      pin.value = generatedPin;

      // Save the PIN to Firestore under this quiz
      await _firestore.collection('quizzes').doc(args['quizId']).update({
        'pin': generatedPin,
        'isActive': true,
      });

      // Update args with the generated PIN
      args['pin'] = generatedPin;

      // Navigate to Lobby after saving
      Get.offNamed(AppRoute.quizLobbyScreen, arguments: args);
    } catch (e) {
      print("Error generating PIN: $e");
    }
  }
}
