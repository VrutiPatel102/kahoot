// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ScoreStatusController extends GetxController {
//   var score = 0.obs;
//   var answerStreak = 0.obs;
//   var lastEarnedPoints = 0.obs;
//   var isCorrectAnswer = false.obs;
//
//   late String quizId;
//   late String userId;
//   late String nickname;
//   StreamSubscription? _participantSub;
//   StreamSubscription? _stageSub;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//     userId = args["userId"] ?? "";
//     nickname = args["nickname"] ?? "Guest";
//
//     _listenParticipant();
//     _listenStageChanges();
//   }
//
//   /// Always listen to participant stats from Firestore
//   void _listenParticipant() {
//     _participantSub = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId)
//         .snapshots()
//         .listen((doc) {
//           if (!doc.exists) return;
//           final data = doc.data();
//           if (data == null) return;
//
//           score.value = data["score"] ?? 0;
//           answerStreak.value = data["answerStreak"] ?? 0;
//           lastEarnedPoints.value = data["lastEarnedPoints"] ?? 0;
//           isCorrectAnswer.value = data["lastAnswerCorrect"] ?? false;
//         });
//   }
//
//   /// Listen to host stage updates and move user accordingly
//   void _listenStageChanges() {
//     _stageSub = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .snapshots()
//         .listen((doc) async {
//           if (!doc.exists) return;
//
//           final stage = doc.data()?["quizStage"] ?? "";
//           final currentQuestionIndex = doc.data()?["currentQuestionIndex"] ?? 0;
//
//           if (stage == "question") {
//             // navigate to next ShowOption screen
//             final query = await FirebaseFirestore.instance
//                 .collection("quizzes")
//                 .doc(quizId)
//                 .collection("questions")
//                 .orderBy(FieldPath.documentId)
//                 .get();
//
//             if (query.docs.length > currentQuestionIndex) {
//               final questionId = query.docs[currentQuestionIndex].id;
//
//               Get.offNamed(
//                 AppRoute.showOption,
//                 arguments: {
//                   "quizId": quizId,
//                   "userId": userId,
//                   "nickname": nickname,
//                   "questionId": questionId,
//                 },
//               );
//             }
//           } else if (stage == "final") {
//             // Quiz finished → User Rank Screen
//             Get.offNamed(
//               AppRoute.userRank,
//               arguments: {
//                 "quizId": quizId,
//                 "userId": userId,
//                 "nickname": nickname,
//               },
//             );
//           }
//         });
//   }
//
//   @override
//   void onClose() {
//     _participantSub?.cancel();
//     _stageSub?.cancel();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ScoreStatusController extends GetxController {
  var totalScore = 0.obs;
  var lastEarnedPoints = 0.obs;
  var isCorrectAnswer = false.obs;
  var message = "".obs;

  late String quizId;
  late String userId;
  late String nickname;

  StreamSubscription? _participantSub;
  StreamSubscription? _stageSub;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = args["userId"] ?? "";
    nickname = args["nickname"] ?? "Guest";

    _listenParticipant();
    _listenStageChanges();
  }

  void _listenParticipant() {
    _participantSub = FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;
          final data = doc.data();
          if (data == null) return;

          totalScore.value = data["score"] ?? 0;
          lastEarnedPoints.value = data["lastEarnedPoints"] ?? 0;

          if (data.containsKey("lastAnswerCorrect")) {
            isCorrectAnswer.value = data["lastAnswerCorrect"];
            message.value = data["lastAnswerCorrect"] ? "Correct" : "Wrong";
          } else {
            message.value = "Timeout / Not answered";
          }
        });
  }

  void _listenStageChanges() {
    _stageSub = FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;

          final stage = doc.data()?["quizStage"] ?? "";
          final currentQuestionIndex = doc.data()?["currentQuestionIndex"] ?? 0;

          if (stage == "question") {
            // Navigate to next ShowOption screen
            final query = await FirebaseFirestore.instance
                .collection("quizzes")
                .doc(quizId)
                .collection("questions")
                .orderBy(FieldPath.documentId)
                .get();

            if (query.docs.length > currentQuestionIndex) {
              final questionId = query.docs[currentQuestionIndex].id;

              Get.offNamed(
                AppRoute.showOption,
                arguments: {
                  "quizId": quizId,
                  "userId": userId,
                  "nickname": nickname,
                  "questionId": questionId,
                },
              );
            }
          } else if (stage == "final") {
            Get.offNamed(
              AppRoute.userRank,
              arguments: {
                "quizId": quizId,
                "userId": userId,
                "nickname": nickname,
              },
            );
          }
        });
  }

  @override
  void onClose() {
    _participantSub?.cancel();
    _stageSub?.cancel();
    super.onClose();
  }
}
