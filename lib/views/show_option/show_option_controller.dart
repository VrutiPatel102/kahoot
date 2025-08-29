// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
// import 'package:kahoot_app/views/score_status/score_status_controller.dart';
//
// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//   var hasAnswered = false.obs;
//
//   late String quizId;
//   late String userId;
//   late String nickname;
//
//   final quizRef = FirebaseFirestore.instance.collection("quizzes");
//
//   Future<void> select(int index) async {
//     print("👉 select() called with index: $index");
//
//     hasAnswered.value = true;
//     selectedIndex.value = index;
//
//     final snapshot = await quizRef.doc(quizId).get();
//     if (!snapshot.exists) {
//       print("❌ Quiz not found: $quizId");
//       return;
//     }
//
//     final data = snapshot.data() ?? {};
//     final currentQuestionIndex = data["currentQuestionIndex"] ?? 0;
//     print("📌 Current question index: $currentQuestionIndex");
//
//     // Try to fetch the current question from the 'questions' subcollection
//     DocumentSnapshot<Map<String, dynamic>>? questionSnap;
//     try {
//       questionSnap = await quizRef
//           .doc(quizId)
//           .collection("questions")
//           .doc("q$currentQuestionIndex")
//           .get();
//     } catch (e) {
//       print("⚠️ Could not fetch question from subcollection: $e");
//     }
//
//     Map<String, dynamic>? question;
//     if (questionSnap != null && questionSnap.exists) {
//       question = questionSnap.data();
//     } else {
//       // fallback to questions array in quiz doc
//       final questions = List.from(data["questions"] ?? []);
//       if (questions.isEmpty || currentQuestionIndex >= questions.length) {
//         print("❌ No questions found or index out of range");
//         return;
//       }
//       question = questions[currentQuestionIndex];
//     }
//
//     final options = List.from(question?["options"] ?? []);
//     if (options.isEmpty || index >= options.length) {
//       print("❌ Invalid option selected");
//       return;
//     }
//
//     // Determine if answer is correct and get selectedOptionText
//     int correctIndex = question?["correctIndex"] ?? -1;
//     bool isCorrect = false;
//     String selectedOptionText = "";
//
//     if (options[index] is Map) {
//       final option = options[index];
//       selectedOptionText = option["text"] ?? "";
//       if (option.containsKey("isCorrect")) {
//         isCorrect = option["isCorrect"] == true;
//       } else {
//         isCorrect = index == correctIndex;
//       }
//     } else if (options[index] is String) {
//       selectedOptionText = options[index];
//       isCorrect = index == correctIndex;
//     }
//
//     // Update score via ScoreStatusController
//     if (!Get.isRegistered<ScoreStatusController>()) {
//       Get.put(ScoreStatusController(), permanent: true);
//     }
//     final scoreCtrl = Get.find<ScoreStatusController>();
//     final earnedPoints = await scoreCtrl.updateScore(isCorrect);
//
//     print("🏆 Earned: $earnedPoints | Total Score: ${scoreCtrl.score.value}");
//
//     // Save participant summary document (merging updates)
//     await quizRef.doc(quizId).collection("participants").doc(userId).set({
//       "userId": userId,
//       "nickname": nickname,
//       "score": scoreCtrl.score.value,
//       "answerStreak": scoreCtrl.answerStreak.value,
//       "lastEarnedPoints": earnedPoints,
//       "selectedOption": index,
//       "isCorrect": isCorrect,
//       "lastUpdated": FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//
//     // Save individual answer in answers subcollection
//     await quizRef
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId)
//         .collection("answers")
//         .doc("q$currentQuestionIndex")
//         .set({
//           "questionIndex": currentQuestionIndex,
//           "questionText": question?["questionText"] ?? question?["text"] ?? "",
//           "selectedOption": index,
//           "selectedOptionText": selectedOptionText,
//           "isCorrect": isCorrect,
//           "earnedPoints": earnedPoints,
//           "answeredAt": FieldValue.serverTimestamp(),
//         });
//
//     print("✅ Answer saved for question $currentQuestionIndex");
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//     userId = FirebaseAuth.instance.currentUser?.uid ?? "";
//     nickname = args["nickname"] ?? "Guest"; // pass nickname from join screen
//     if (quizId.isEmpty || userId.isEmpty) {
//       throw Exception(
//         "❌ quizId and userId are required in ShowOptionController",
//       );
//     }
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
//       final data = snapshot.data() ?? {};
//       final stage = data["quizStage"] ?? "";
//
//       if (stage == "question") {
//         selectedIndex.value = -1;
//         hasAnswered.value = false;
//       } else if (stage == "scoreboard") {
//         if (hasAnswered.value) {
//           // navigate only if answered
//           Get.offNamed(
//             AppRoute.scoreStatus,
//             arguments: {"quizId": quizId},
//             preventDuplicates: false,
//           );
//         }
//       } else if (stage == "final") {
//         if (hasAnswered.value) {
//           // navigate only if answered
//           Get.offNamed(
//             AppRoute.userRank,
//             arguments: {"quizId": quizId},
//             preventDuplicates: false,
//           );
//         }
//       }
//     });
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';

// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//   var hasAnswered = false.obs;
//   late final String quizId;
//   late final String userId;
//   late final String nickname;
//
//   var score = 0.obs;
//   var streak = 0.obs;
//   var correctAnswers = 0.obs;
//   var wrongAnswers = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//     userId = args["userId"] ?? ""; // ✅ use passed userId (no FirebaseAuth)
//     nickname = args["nickname"] ?? "Guest";
//
//     if (quizId.isEmpty || userId.isEmpty) {
//       throw Exception(
//         "❌ quizId and userId are required for ShowOptionController",
//       );
//     }
//   }
//
//   /// ✅ Called when user selects an option
//   Future<void> select(int selected, int correctIndex, String questionId) async {
//     final isCorrect = (selected == correctIndex);
//     final points = isCorrect ? 50 : 0;
//
//     if (isCorrect) {
//       correctAnswers.value++;
//       streak.value++;
//     } else {
//       wrongAnswers.value++;
//       streak.value = 0;
//     }
//     score.value += points;
//
//     final participantRef = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId);
//
//     // ✅ Save the answer under answers/{questionId}
//     await participantRef.collection("answers").doc(questionId).set({
//       "selectedOption": selected,
//       "isCorrect": isCorrect,
//       "earnedPoints": points,
//       "answeredAt": FieldValue.serverTimestamp(),
//     });
//
//     // ✅ Update participant doc (score summary)
//     await participantRef.set({
//       "nickname": nickname,
//       "score": score.value,
//       "correctAnswers": correctAnswers.value,
//       "wrongAnswers": wrongAnswers.value,
//       "answerStreak": streak.value,
//       "lastEarnedPoints": points,
//       "lastUpdated": FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//
//     // 🚀 Navigate to ScoreStatus screen
//     Get.toNamed(
//       AppRoute.scoreStatus,
//       arguments: {
//         "quizId": quizId,
//         "userId": userId, // ✅ pass userId forward
//         "nickname": nickname,
//         "questionId": questionId,
//         "isCorrect": isCorrect,
//         "points": points,
//       },
//     );
//   }
// }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//   var hasAnswered = false.obs;
//
//   late final String quizId;
//   late final String userId;
//   late final String nickname;
//
//   var score = 0.obs;
//   var streak = 0.obs;
//   var correctAnswers = 0.obs;
//   var wrongAnswers = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//     userId = args["userId"] ?? "";
//     nickname = args["nickname"] ?? "Guest";
//
//     if (quizId.isEmpty || userId.isEmpty) {
//       print("❌ quizId or userId missing in ShowOptionController");
//     }
//   }
//
//   Future<void> select(int selected, int correctIndex, String questionId) async {
//     final isCorrect = (selected == correctIndex);
//     final points = isCorrect ? 50 : 0;
//
//     if (isCorrect) {
//       correctAnswers.value++;
//       streak.value++;
//     } else {
//       wrongAnswers.value++;
//       streak.value = 0;
//     }
//     score.value += points;
//
//     final participantRef = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId);
//
//     await participantRef.collection("answers").doc(questionId).set({
//       "selectedOption": selected,
//       "isCorrect": isCorrect,
//       "earnedPoints": points,
//       "answeredAt": FieldValue.serverTimestamp(),
//     });
//
//     await participantRef.set({
//       "nickname": nickname,
//       "score": score.value,
//       "correctAnswers": correctAnswers.value,
//       "wrongAnswers": wrongAnswers.value,
//       "answerStreak": streak.value,
//       "lastEarnedPoints": points,
//       "lastUpdated": FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//
//     // Navigate to ScoreStatus
//     Get.toNamed(
//       AppRoute.scoreStatus,
//       arguments: {
//         "quizId": quizId,
//         "userId": userId,
//         "nickname": nickname,
//         "questionId": questionId,
//         "isCorrect": isCorrect,
//         "points": points,
//       },
//     );
//   }
// }
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class ShowOptionController extends GetxController {
//   var selectedIndex = (-1).obs;
//   var hasAnswered = false.obs;
//
//   late String quizId;
//   late String userId;
//   late String nickname;
//   StreamSubscription? _stageSubscription;
//
//   var score = 0.obs;
//   var streak = 0.obs;
//   var correctAnswers = 0.obs;
//   var wrongAnswers = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments ?? {};
//     quizId = args["quizId"] ?? "";
//     userId = args["userId"] ?? "";
//     nickname = args["nickname"] ?? "Guest";
//
//     _listenStageChanges();
//   }
//
//   /// Listen host stage, move to ScoreStatus when stage changes
//   void _listenStageChanges() {
//     _stageSubscription = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .snapshots()
//         .listen((doc) {
//           if (!doc.exists) return;
//           final stage = doc.data()?["quizStage"] ?? "";
//           final currentQuestionIndex = doc.data()?["currentQuestionIndex"] ?? 0;
//
//           if (stage == "scoreboard") {
//             // Navigate to ScoreStatus
//             Get.offNamed(
//               AppRoute.scoreStatus,
//               arguments: {
//                 "quizId": quizId,
//                 "userId": userId,
//                 "nickname": nickname,
//                 "questionIndex": currentQuestionIndex,
//               },
//             );
//           } else if (stage == "final") {
//             // Quiz finished
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
//   // Future<void> select(int selected, int correctIndex, String questionId) async {
//   //   if (hasAnswered.value) return;
//   //   hasAnswered.value = true;
//   //   selectedIndex.value = selected;
//   //
//   //   final isCorrect = selected == correctIndex;
//   //   final points = isCorrect ? 50 : 0;
//   //
//   //   if (isCorrect) {
//   //     correctAnswers.value++;
//   //     streak.value++;
//   //   } else {
//   //     wrongAnswers.value++;
//   //     streak.value = 0;
//   //   }
//   //   score.value += points;
//   //
//   //   final participantRef = FirebaseFirestore.instance
//   //       .collection("quizzes")
//   //       .doc(quizId)
//   //       .collection("participants")
//   //       .doc(userId);
//   //
//   //   await participantRef.collection("answers").doc(questionId).set({
//   //     "selectedOption": selected,
//   //     "isCorrect": isCorrect,
//   //     "earnedPoints": points,
//   //     "answeredAt": FieldValue.serverTimestamp(),
//   //   });
//   //
//   //   await participantRef.set({
//   //     "nickname": nickname,
//   //     "score": score.value,
//   //     "correctAnswers": correctAnswers.value,
//   //     "wrongAnswers": wrongAnswers.value,
//   //     "answerStreak": streak.value,
//   //     "lastEarnedPoints": points,
//   //     "lastUpdated": FieldValue.serverTimestamp(),
//   //   }, SetOptions(merge: true));
//   // }
//
//   Future<void> select(int selected, int correctIndex, String questionId) async {
//     if (hasAnswered.value) return;
//     hasAnswered.value = true;
//     selectedIndex.value = selected;
//
//     final isCorrect = selected == correctIndex;
//     final points = isCorrect ? 50 : 0; // adjust scoring system
//
//     if (isCorrect) {
//       correctAnswers.value++;
//       streak.value++;
//     } else {
//       wrongAnswers.value++;
//       streak.value = 0;
//     }
//
//     // store per-question answer
//     final participantRef = FirebaseFirestore.instance
//         .collection("quizzes")
//         .doc(quizId)
//         .collection("participants")
//         .doc(userId);
//
//     await participantRef.collection("answers").doc(questionId).set({
//       "selectedOption": selected,
//       "isCorrect": isCorrect,
//       "earnedPoints": points,
//       "answeredAt": FieldValue.serverTimestamp(),
//     });
//
//     // ✅ increment total score instead of overwriting
//     await participantRef.set({
//       "nickname": nickname,
//       "score": FieldValue.increment(points), // cumulative score
//       "correctAnswers": FieldValue.increment(isCorrect ? 1 : 0),
//       "wrongAnswers": FieldValue.increment(isCorrect ? 0 : 1),
//       "answerStreak": streak.value,
//       "lastEarnedPoints": points,
//       "lastAnswerCorrect": isCorrect,
//       "lastUpdated": FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }
//
//   @override
//   void onClose() {
//     _stageSubscription?.cancel();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;
  var hasAnswered = false.obs;

  var message = "".obs;
  var isCorrectAnswer = false.obs;
  var lastEarnedPoints = 0.obs;
  var score = 0.obs;

  late String quizId;
  late String userId;
  late String nickname;
  StreamSubscription? _stageSubscription;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = args["userId"] ?? "";
    nickname = args["nickname"] ?? "Guest";

    _listenStageChanges();
  }

  /// Listen host stage, move to ScoreStatus when stage changes
  void _listenStageChanges() {
    _stageSubscription = FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;
          final stage = doc.data()?["quizStage"] ?? "";
          final currentQuestionIndex = doc.data()?["currentQuestionIndex"] ?? 0;

          if (stage == "scoreboard") {
            // If user hasn't answered, mark timeout
            if (!hasAnswered.value) {
              await _submitTimeout(currentQuestionIndex);
            }

            // Navigate to ScoreStatus
            Get.offNamed(
              AppRoute.scoreStatus,
              arguments: {
                "quizId": quizId,
                "userId": userId,
                "nickname": nickname,
                "questionIndex": currentQuestionIndex,
              },
            );
          } else if (stage == "final") {
            // Quiz finished
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

  /// User selects an option
  Future<void> select(int selected, int correctIndex, String questionId) async {
    if (hasAnswered.value) return;

    hasAnswered.value = true;
    selectedIndex.value = selected;

    final isCorrect = selected == correctIndex;
    isCorrectAnswer.value = isCorrect;

    final points = isCorrect ? 50 : 0;
    lastEarnedPoints.value = points;
    score.value += points;

    message.value = isCorrect ? "Correct" : "Wrong";

    await _submitAnswer(selected, isCorrect, points, questionId);
  }

  /// Store answer in Firestore
  Future<void> _submitAnswer(
    int selected,
    bool isCorrect,
    int points,
    String questionId,
  ) async {
    final participantRef = FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .collection("participants")
        .doc(userId);

    await participantRef.collection("answers").doc(questionId).set({
      "selectedOption": selected,
      "isCorrect": isCorrect,
      "earnedPoints": points,
      "answeredAt": FieldValue.serverTimestamp(),
    });

    await participantRef.set({
      "nickname": nickname,
      "score": FieldValue.increment(points),
      "lastEarnedPoints": points,
      "lastAnswerCorrect": isCorrect,
      "lastUpdated": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Automatically submit timeout for unanswered question
  Future<void> _submitTimeout(int questionIndex) async {
    hasAnswered.value = true;
    selectedIndex.value = -1;
    isCorrectAnswer.value = false;
    lastEarnedPoints.value = 0;
    message.value = "Timeout / Not Answered";

    // Get the questionId
    final query = await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .collection("questions")
        .orderBy(FieldPath.documentId)
        .get();

    if (query.docs.length > questionIndex) {
      final questionId = query.docs[questionIndex].id;

      final participantRef = FirebaseFirestore.instance
          .collection("quizzes")
          .doc(quizId)
          .collection("participants")
          .doc(userId);

      await participantRef.collection("answers").doc(questionId).set({
        "selectedOption": null,
        "isCorrect": false,
        "earnedPoints": 0,
        "answeredAt": FieldValue.serverTimestamp(),
      });

      await participantRef.set({
        "nickname": nickname,
        "lastEarnedPoints": 0,
        "lastAnswerCorrect": false,
        "lastUpdated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  @override
  void onClose() {
    _stageSubscription?.cancel();
    super.onClose();
  }
}
