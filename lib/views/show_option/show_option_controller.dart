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

  final quizRef = FirebaseFirestore.instance.collection("quizzes");

  Future<void> select(int index) async {
    // ✅ allow changing answer until stage changes
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
    await scoreCtrl.updateScore(isCorrect);

    // 🔹 overwrite last choice in Firestore
    await quizRef.doc(quizId).collection("participants").doc(userId).set({
      "selectedOption": index,
      "isCorrect": isCorrect,
    }, SetOptions(merge: true));
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
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
        // reset for new question
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
