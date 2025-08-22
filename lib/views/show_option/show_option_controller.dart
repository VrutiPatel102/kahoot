// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//
//   void select(int index) {
//     selectedIndex.value = index;
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     simulateLoading();
//   }
//
//   void simulateLoading() async {
//     await Future.delayed(const Duration(seconds: 3));
//     Get.offNamed(AppRoute.scoreStatus, preventDuplicates: false);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;
  late String quizId;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  void select(int index) {
    selectedIndex.value = index;
    // TODO: Save user answer to Firebase if needed
  }

  @override
  void onInit() {
    super.onInit();
    // Read quizId from arguments
    final args = Get.arguments;
    quizId = args["quizId"];
  }

  @override
  void onReady() {
    super.onReady();
    _listenStageChanges();
  }

  void _listenStageChanges() {
    quizRef.doc(quizId).snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      final stage = snapshot["quizStage"];
      if (stage == "scoreboard") {
        // Host moved to scoreboard → go to ScoreStatus
        Get.offNamed(
          AppRoute.scoreStatus,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      } else if (stage == "final") {
        // Host ended quiz → jump to UserRank screen
        Get.offNamed(
          AppRoute.userRank,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      }
    });
  }
}
