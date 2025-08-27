import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/models/participant_model.dart';

class ScoreStatusController extends GetxController {
  var score = 0.obs;
  var answerStreak = 0.obs;
  var lastEarnedPoints = 0.obs;
  var isCorrectAnswer = true.obs;

  late final String quizId;
  late final String userId;
  late final String nickname;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    nickname = args["nickname"] ?? "Guest";

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

  /// ✅ Update score after answering
  Future<int> updateScore(bool isCorrect) async {
    isCorrectAnswer.value = isCorrect;

    if (isCorrect) {
      lastEarnedPoints.value = 50;
      score.value += lastEarnedPoints.value;
      answerStreak.value += 1;
    } else {
      lastEarnedPoints.value = 0;
      answerStreak.value = 0;
    }

    // Save participant score in Firestore
    final participant = Participant(
      id: userId,
      nickname: nickname,
      score: score.value,
      answerStreak: answerStreak.value,
      lastEarnedPoints: lastEarnedPoints.value,
      isCorrectAnswer: isCorrectAnswer.value,
    );

    await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .set(
          participant.toMap()
            ..addAll({"lastUpdated": FieldValue.serverTimestamp()}),
          SetOptions(merge: true),
        );

    return lastEarnedPoints.value;
  }

  /// 🔁 Real-time listener for participant score (from Firestore)
  void _listenMyScore() {
    FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;

          final participant = Participant.fromDoc(doc);

          score.value = participant.score;
          answerStreak.value = participant.answerStreak;
          lastEarnedPoints.value = participant.lastEarnedPoints;
          isCorrectAnswer.value = participant.isCorrectAnswer;
        });
  }

  /// 🚦 Listen to quiz stage changes and redirect
  void _listenStageChanges() {
    FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) return;

          final stage = snapshot.data()?["quizStage"];
          if (stage == null) return;

          if (stage == "question") {
            Get.offNamed(
              AppRoute.showOption,
              arguments: {"quizId": quizId, "nickname": nickname},
              preventDuplicates: false,
            );
          } else if (stage == "final") {
            Get.offNamed(
              AppRoute.userRank,
              arguments: {"quizId": quizId, "nickname": nickname},
              preventDuplicates: false,
            );
          }
        });
  }
}
