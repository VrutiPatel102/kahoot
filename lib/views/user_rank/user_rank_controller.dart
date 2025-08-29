import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRankController extends GetxController {
  // Observables
  var playerName = "".obs;
  var rank = 0.obs;
  var points = 0.obs;
  var subtitle = "".obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String quizId;
  late String userId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = args["userId"] ?? FirebaseAuth.instance.currentUser?.uid ?? "";

    if (quizId.isNotEmpty && userId.isNotEmpty) {
      _loadUserRank();
    } else {
      // fallback demo data
      playerName.value = "Guest";
      rank.value = 0;
      points.value = 0;
      subtitle.value = "Keep practicing!";
    }
  }

  Future<void> _loadUserRank() async {
    try {
      final snapshot = await _firestore
          .collection("quizzes")
          .doc(quizId)
          .collection("participants")
          .orderBy("score", descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        playerName.value = "Guest";
        points.value = 0;
        rank.value = 0;
        subtitle.value = "No data available";
        return;
      }

      int currentRank = 1;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (doc.id == userId) {
          playerName.value = data["nickname"] ?? "Guest";
          points.value = data["score"] ?? 0;
          rank.value = currentRank;

          // Dynamic subtitle
          if (points.value > 1000) {
            subtitle.value = "Big cheese!";
          } else if (points.value > 500) {
            subtitle.value = "Rising star!";
          } else if (points.value > 100) {
            subtitle.value = "Getting warmed up!";
          } else {
            subtitle.value = "Keep practicing!";
          }
          break;
        }
        currentRank++;
      }
    } catch (e) {
      print("⚠️ Error loading user rank: $e");
    }
  }
}
