import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/score_status/score_status_controller.dart';

class ShowOptionController extends GetxController {
  var selectedIndex = (-1).obs;
  var hasAnswered = false.obs;

  late String quizId;
  late String userId;
  late String nickname;

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  Future<void> select(int index) async {
    hasAnswered.value = true;
    selectedIndex.value = index;

    final snapshot = await quizRef.doc(quizId).get();
    if (!snapshot.exists) return;

    final data = snapshot.data() ?? {};
    final currentQuestionIndex = data["currentQuestionIndex"] ?? 0;
    final questions = List.from(data["questions"] ?? []);
    if (questions.isEmpty || currentQuestionIndex >= questions.length) return;

    final question = questions[currentQuestionIndex];
    final options = List.from(question["options"] ?? []);
    if (options.isEmpty || index >= options.length) return;

    final option = options[index];
    final isCorrect = option is Map && option["isCorrect"] == true;

    // ensure ScoreStatusController exists
    if (!Get.isRegistered<ScoreStatusController>()) {
      Get.put(ScoreStatusController(), permanent: true);
    }
    final scoreCtrl = Get.find<ScoreStatusController>();
    final earnedPoints = await scoreCtrl.updateScore(isCorrect);

    // ✅ Save summary info in participant doc
    await quizRef.doc(quizId).collection("participants").doc(userId).set({
      "userId": userId,
      "nickname": nickname,
      "score": scoreCtrl.score.value,
      "answerStreak": scoreCtrl.answerStreak.value,
      "lastEarnedPoints": earnedPoints,
      "selectedOption": index,
      "isCorrect": isCorrect,
      "lastUpdated": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ✅ Save per-question details in subcollection
    await quizRef
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .collection("answers")
        .doc("q$currentQuestionIndex")
        .set({
          "questionIndex": currentQuestionIndex,
          "questionText": question["text"] ?? "",
          "selectedOption": index,
          "selectedOptionText": option is Map ? option["text"] ?? "" : "",
          "isCorrect": isCorrect,
          "earnedPoints": earnedPoints,
          "answeredAt": FieldValue.serverTimestamp(),
        });
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    nickname = args["nickname"] ?? "Guest"; // ✅ pass nickname from join screen
    if (quizId.isEmpty || userId.isEmpty) {
      throw Exception(
        "❌ quizId and userId are required in ShowOptionController",
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    _listenStageChanges();
  }

  void _listenStageChanges() {
    quizRef.doc(quizId).snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data() ?? {};
      final stage = data["quizStage"] ?? "";

      if (stage == "question") {
        selectedIndex.value = -1;
        hasAnswered.value = false;
      } else if (stage == "scoreboard") {
        Get.offNamed(
          AppRoute.scoreStatus,
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
