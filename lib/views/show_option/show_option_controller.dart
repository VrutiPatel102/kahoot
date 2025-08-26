// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//   late String quizId;
//
//   final quizRef = FirebaseFirestore.instance.collection("quizzes");
//
//   void select(int index) {
//     selectedIndex.value = index;
//     // TODO: Save user answer to Firebase if needed
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Read quizId from arguments
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
//       if (stage == "scoreboard") {
//         // Host moved to scoreboard → go to ScoreStatus
//         Get.offNamed(
//           AppRoute.scoreStatus,
//           arguments: {"quizId": quizId},
//           preventDuplicates: false,
//         );
//       } else if (stage == "final") {
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

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;
  late String quizId;
  late String userId; // pass this from arguments when joining
  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    quizId = args["quizId"];
    userId = args["userId"]; // must pass from login/join
  }

  /// ✅ When user selects an option
  Future<void> select(int index) async {
    selectedIndex.value = index;

    final doc = await quizRef.doc(quizId).get();
    if (!doc.exists) return;

    final data = doc.data() ?? {};
    final currentIndex = data["currentQuestionIndex"] ?? 0;
    final questions = data["questions"] as List<dynamic>? ?? [];
    if (currentIndex >= questions.length) return;

    final question = questions[currentIndex];
    final correctIndex = question["correctIndex"] ?? -1;

    // ✅ Decide result
    String status;
    int scoreDelta = 0;
    if (index == correctIndex) {
      status = "correct";
      scoreDelta = 100; // give 100 points for correct
    } else {
      status = "wrong";
    }

    // ✅ Update participant record
    final participantRef = quizRef
        .doc(quizId)
        .collection("participants")
        .doc(userId);

    final participantSnap = await participantRef.get();
    final prevScore = participantSnap.data()?["score"] ?? 0;

    await participantRef.set({
      "selectedIndex": index,
      "status": status,
      "score": prevScore + scoreDelta,
      "lastUpdated": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  void onReady() {
    super.onReady();
    _listenStageChanges();
  }

  void _listenStageChanges() {
    quizRef.doc(quizId).snapshots().listen((snapshot) async {
      if (!snapshot.exists) return;

      final stage = snapshot["quizStage"];
      if (stage == "scoreboard") {
        // ✅ if user didn’t answer → timeout
        if (selectedIndex.value == -1) {
          final participantRef = quizRef
              .doc(quizId)
              .collection("participants")
              .doc(userId);

          final snap = await participantRef.get();
          if (snap.exists && (snap.data()?["status"] == null)) {
            await participantRef.set({
              "selectedIndex": -1,
              "status": "timeout",
              "lastUpdated": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }
        }

        // Move to score status screen
        Get.offNamed(
          AppRoute.scoreStatus,
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
