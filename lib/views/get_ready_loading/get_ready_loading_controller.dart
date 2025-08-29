import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class GetReadyLoadingController extends GetxController {
  late String quizId;
  late String userId;
  late String nickname;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    nickname = args["nickname"] ?? "Guest";

    if (quizId.isEmpty || userId.isEmpty) {
      Get.snackbar("Error", "❌ Quiz ID or User ID missing");
      return;
    }

    _listenForHostCountdownEnd();
  }

  void _listenForHostCountdownEnd() {
    _subscription = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;

          final data = doc.data();
          if (data == null) return;

          final status = data['quizStage'] ?? '';
          final currentQuestionIndex = data['currentQuestionIndex'] ?? 0;

          if (status == 'question') {
            final query = await FirebaseFirestore.instance
                .collection('quizzes')
                .doc(quizId)
                .collection('questions')
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

              await _subscription?.cancel();
            }
          }
        });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
