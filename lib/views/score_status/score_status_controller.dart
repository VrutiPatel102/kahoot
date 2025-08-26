// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ScoreStatusController extends GetxController {
//   var score = 0.obs;
//   var answerStreak = 0.obs;
//   late String quizId;
//
//   final quizRef = FirebaseFirestore.instance.collection("quizzes");
//
//   void setResult(int newScore, int streak) {
//     score.value = newScore;
//     answerStreak.value = streak;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//     quizId = args["quizId"];
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     _listenStageChanges();
//   }
//
//   void _listenStageChanges() {
//     quizRef.doc(quizId).snapshots().listen((snapshot) {
//       if (!snapshot.exists) return;
//
//       final stage = snapshot["quizStage"];
//       if (stage == "question") {
//         // Host moved to next question → user goes directly to ShowOptionScreen
//         Get.offNamed(
//           AppRoute.showOption,
//           arguments: {"quizId": quizId},
//           preventDuplicates: false,
//         );
//       } else if (stage == "final") {
//         // Host ended quiz → user rank screen
//         Get.offNamed(
//           AppRoute.userRank,
//           arguments: {"quizId": quizId},
//           preventDuplicates: false,
//         );
//       }
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreStatusController extends GetxController {
  var score = 0.obs;
  var answerStreak = 0.obs;
  var status = "pending".obs; // ✅ correct, wrong, timeout
  late String quizId;
  late String userId;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    quizId = args["quizId"];
    userId = args["userId"];
  }

  @override
  void onReady() {
    super.onReady();
    _listenToParticipant();
    _listenStageChanges();
  }

  /// ✅ Listen to this user's result in participants collection
  void _listenToParticipant() {
    quizRef
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) return;

          final data = snapshot.data() ?? {};
          score.value = data["score"] ?? 0;
          status.value = data["status"] ?? "";

          // ✅ handle streak (consecutive correct answers)
          if (status.value == "correct") {
            answerStreak.value = (answerStreak.value + 1);
          } else if (status.value == "wrong" || status.value == "timeout") {
            answerStreak.value = 0;
          }
        });
  }

  /// ✅ Listen to quiz stage changes from host
  void _listenStageChanges() {
    quizRef.doc(quizId).snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      final stage = snapshot["quizStage"];
      if (stage == "question") {
        // Host moved to next question → user goes directly to ShowOptionScreen
        Get.offNamed(
          AppRoute.showOption,
          arguments: {"quizId": quizId, "userId": userId},
          preventDuplicates: false,
        );
      } else if (stage == "final") {
        // Host ended quiz → user rank screen
        Get.offNamed(
          AppRoute.userRank,
          arguments: {"quizId": quizId, "userId": userId},
          preventDuplicates: false,
        );
      }
    });
  }
}
