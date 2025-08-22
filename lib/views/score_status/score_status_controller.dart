// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
// import 'package:kahoot_app/views/que_loading/que_loading_controller.dart';
//
// class ScoreStatusController extends GetxController {
//   var score = 691.obs;
//   var answerStreak = 1.obs;
//
//   void setResult(int newScore, int streak) {
//     score.value = newScore;
//     answerStreak.value = streak;
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     simulateLoading();
//   }
//
//   void simulateLoading() async {
//     await Future.delayed(Duration(seconds: 3));
//
//     QueLoadingController.loopCount++;
//
//     if (QueLoadingController.loopCount < 3) {
//       Get.offNamed(AppRoute.queLoading, preventDuplicates: false);
//     } else {
//       Get.offNamed(AppRoute.userRank);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreStatusController extends GetxController {
  var score = 0.obs;
  var answerStreak = 0.obs;
  late String quizId;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  void setResult(int newScore, int streak) {
    score.value = newScore;
    answerStreak.value = streak;
  }

  @override
  void onInit() {
    super.onInit();
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
      if (stage == "question") {
        // Host moved to next question → user goes directly to ShowOptionScreen
        Get.offNamed(
          AppRoute.showOption,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      } else if (stage == "final") {
        // Host ended quiz → user rank screen
        Get.offNamed(
          AppRoute.userRank,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      }
    });
  }
}
