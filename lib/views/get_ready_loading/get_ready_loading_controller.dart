import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class GetReadyLoadingController extends GetxController {
  late String quizId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";

    if (quizId.isEmpty) {
      print("❌ quizId is missing!");
      return;
    }

    // Use a microtask to ensure GetX navigation works
    Future.microtask(() => _fetchFirstQuestionAndNavigate());
  }

  Future<void> _fetchFirstQuestionAndNavigate() async {
    try {
      // 1️⃣ Listen to the quiz document for real-time status
      _firestore.collection('quizzes').doc(quizId).snapshots().listen((
        docSnapshot,
      ) async {
        if (!docSnapshot.exists) return;

        // Check if the quiz has started or status is 'question'
        final status = docSnapshot.data()?['status'] ?? '';
        if (status != 'question') return;

        // 2️⃣ Fetch the first question
        final questionsSnapshot = await _firestore
            .collection('quizzes')
            .doc(quizId)
            .collection('questions')
            .orderBy('createdAt')
            .limit(1)
            .get();

        if (questionsSnapshot.docs.isEmpty) {
          print("❌ No questions found for quizId: $quizId");
          return;
        }

        final firstQuestionId = questionsSnapshot.docs.first.id;

        // 3️⃣ Get userId & nickname
        final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
        final nickname = "Guest"; // You can pass from previous screen

        if (userId.isEmpty) {
          print("❌ User not logged in!");
          return;
        }

        // 4️⃣ Navigate once to ShowOption
        print("✅ Navigating to ShowOption with questionId: $firstQuestionId");
        Get.offNamed(
          AppRoute.showOption,
          arguments: {
            "quizId": quizId,
            "userId": userId,
            "nickname": nickname,
            "questionId": firstQuestionId,
          },
        );
      });
    } catch (e) {
      print("❌ Error fetching first question: $e");
    }
  }
}
