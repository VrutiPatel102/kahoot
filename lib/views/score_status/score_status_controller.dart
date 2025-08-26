// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ScoreStatusController extends GetxController {
//   var score = 0.obs;
//   var answerStreak = 0.obs;
//   var lastEarnedPoints = 0.obs;
//   var isCorrectAnswer = false.obs;
//
//   late final String quizId;
//   late final String userId;
//
//   final quizRef = FirebaseFirestore.instance.collection("quizzes");
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // ✅ Always expect quizId in arguments
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//
//     // ✅ Always take userId from FirebaseAuth
//     userId = FirebaseAuth.instance.currentUser?.uid ?? "";
//
//     if (quizId.isEmpty || userId.isEmpty) {
//       throw Exception(
//         "❌ quizId and userId are required for ScoreStatusController",
//       );
//     }
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     _listenMyScore();
//     _listenStageChanges();
//   }
//
//   /// ✅ Called when the participant answers a question
//   Future<void> updateScore(bool isCorrect) async {
//     isCorrectAnswer.value = isCorrect;
//
//     if (isCorrect) {
//       lastEarnedPoints.value = 50; // you can make this dynamic
//       score.value += 50;
//       answerStreak.value += 1;
//     } else {
//       lastEarnedPoints.value = 0;
//       answerStreak.value = 0;
//     }
//
//     print(
//       "⬆️ Updating Firestore for $userId : "
//       "score=${score.value}, streak=${answerStreak.value}, "
//       "earned=${lastEarnedPoints.value}",
//     );
//
//     // ✅ Save participant progress in Firestore
//     await quizRef.doc(quizId).collection("participants").doc(userId).set({
//       "score": score.value,
//       "answerStreak": answerStreak.value,
//       "lastUpdated": FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }
//
//   /// 🔹 Live listen to *this participant's* score from Firestore
//   void _listenMyScore() {
//     quizRef
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId)
//         .snapshots()
//         .listen((doc) {
//           if (!doc.exists) return;
//
//           score.value = doc.data()?["score"] ?? 0;
//           answerStreak.value = doc.data()?["answerStreak"] ?? 0;
//         });
//   }
//
//   /// 🔹 Listen to host stage changes → navigate participant
//   void _listenStageChanges() {
//     quizRef.doc(quizId).snapshots().listen((snapshot) {
//       if (!snapshot.exists) return;
//
//       final stage = snapshot.data()?["quizStage"];
//
//       if (stage == "question") {
//         Get.offNamed(
//           AppRoute.showOption,
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreStatusController extends GetxController {
  /// Reactive states
  var score = 0.obs;
  var answerStreak = 0.obs;
  var lastEarnedPoints = 0.obs;
  var isCorrectAnswer = false.obs;

  late final String quizId;
  late final String userId;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (quizId.isEmpty || userId.isEmpty) {
      throw Exception(
        "❌ quizId and userId are required for ScoreStatusController",
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    _listenMyScore();
    _listenStageChanges();
  }

  /// ✅ Called when the participant answers a question
  Future<void> updateScore(bool isCorrect) async {
    isCorrectAnswer.value = isCorrect;

    if (isCorrect) {
      lastEarnedPoints.value = 50; // fixed points per correct answer
      score.value += lastEarnedPoints.value;
      answerStreak.value += 1;
    } else {
      lastEarnedPoints.value = 0;
      answerStreak.value = 0;
    }

    // 🔹 Update Firestore for this participant
    await quizRef.doc(quizId).collection("participants").doc(userId).set({
      "score": score.value,
      "answerStreak": answerStreak.value,
      "lastEarnedPoints": lastEarnedPoints.value,
      "lastUpdated": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🔹 Listen to this participant's score
  void _listenMyScore() {
    quizRef
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;

          final data = doc.data();
          if (data == null) return;

          score.value = data["score"] ?? 0;
          answerStreak.value = data["answerStreak"] ?? 0;
          lastEarnedPoints.value = data["lastEarnedPoints"] ?? 0;
        });
  }

  /// 🔹 Listen to quiz stage → switch instantly
  void _listenStageChanges() {
    quizRef.doc(quizId).snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      final stage = snapshot.data()?["quizStage"];
      if (stage == null) return;

      if (stage == "question") {
        Get.offNamed(
          AppRoute.showOption,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      } else if (stage == "final") {
        Get.offNamed(
          AppRoute.userRank,
          arguments: {"quizId": quizId},
          preventDuplicates: false,
        );
      }
    });
  }
}
