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
    print("👉 select() called with index: $index");

    hasAnswered.value = true;
    selectedIndex.value = index;

    final snapshot = await quizRef.doc(quizId).get();
    if (!snapshot.exists) {
      print("❌ Quiz not found: $quizId");
      return;
    }

    final data = snapshot.data() ?? {};
    final currentQuestionIndex = data["currentQuestionIndex"] ?? 0;
    print("📌 Current question index: $currentQuestionIndex");

    // Try to fetch the current question from the 'questions' subcollection
    DocumentSnapshot<Map<String, dynamic>>? questionSnap;
    try {
      questionSnap = await quizRef
          .doc(quizId)
          .collection("questions")
          .doc("q$currentQuestionIndex")
          .get();
    } catch (e) {
      print("⚠️ Could not fetch question from subcollection: $e");
    }

    Map<String, dynamic>? question;
    if (questionSnap != null && questionSnap.exists) {
      question = questionSnap.data();
    } else {
      // fallback to questions array in quiz doc
      final questions = List.from(data["questions"] ?? []);
      if (questions.isEmpty || currentQuestionIndex >= questions.length) {
        print("❌ No questions found or index out of range");
        return;
      }
      question = questions[currentQuestionIndex];
    }

    final options = List.from(question?["options"] ?? []);
    if (options.isEmpty || index >= options.length) {
      print("❌ Invalid option selected");
      return;
    }

    // Determine if answer is correct and get selectedOptionText
    int correctIndex = question?["correctIndex"] ?? -1;
    bool isCorrect = false;
    String selectedOptionText = "";

    if (options[index] is Map) {
      final option = options[index];
      selectedOptionText = option["text"] ?? "";
      if (option.containsKey("isCorrect")) {
        isCorrect = option["isCorrect"] == true;
      } else {
        isCorrect = index == correctIndex;
      }
    } else if (options[index] is String) {
      selectedOptionText = options[index];
      isCorrect = index == correctIndex;
    }

    // Update score via ScoreStatusController
    if (!Get.isRegistered<ScoreStatusController>()) {
      Get.put(ScoreStatusController(), permanent: true);
    }
    final scoreCtrl = Get.find<ScoreStatusController>();
    final earnedPoints = await scoreCtrl.updateScore(isCorrect);

    print("🏆 Earned: $earnedPoints | Total Score: ${scoreCtrl.score.value}");

    // Save participant summary document (merging updates)
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

    // Save individual answer in answers subcollection
    await quizRef
        .doc(quizId)
        .collection("participants")
        .doc(userId)
        .collection("answers")
        .doc("q$currentQuestionIndex")
        .set({
          "questionIndex": currentQuestionIndex,
          "questionText": question?["questionText"] ?? question?["text"] ?? "",
          "selectedOption": index,
          "selectedOptionText": selectedOptionText,
          "isCorrect": isCorrect,
          "earnedPoints": earnedPoints,
          "answeredAt": FieldValue.serverTimestamp(),
        });

    print("✅ Answer saved for question $currentQuestionIndex");
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    nickname = args["nickname"] ?? "Guest"; // pass nickname from join screen
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
        if (hasAnswered.value) {
          // navigate only if answered
          Get.offNamed(
            AppRoute.scoreStatus,
            arguments: {"quizId": quizId},
            preventDuplicates: false,
          );
        }
      } else if (stage == "final") {
        if (hasAnswered.value) {
          // navigate only if answered
          Get.offNamed(
            AppRoute.userRank,
            arguments: {"quizId": quizId},
            preventDuplicates: false,
          );
        }
      }
    });
  }
}
