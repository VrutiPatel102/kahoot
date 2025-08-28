// import 'package:get/get.dart';
//
// class UserRankController extends GetxController {
//   var playerName = "Jeel".obs;
//   var rank = 1.obs;
//   var points = 1453.obs;
//   var subtitle = "Big cheese!".obs;
// }

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
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (quizId.isNotEmpty && userId.isNotEmpty) {
      _loadUserRank();
    } else {
      // ✅ fallback to dummy data (like your code)
      playerName.value = "Jeel";
      rank.value = 1;
      points.value = 1453;
      subtitle.value = "Big cheese!";
    }
  }

  Future<void> _loadUserRank() async {
    try {
      // Get all participants sorted by score
      final snapshot = await _firestore
          .collection("quizzes")
          .doc(quizId)
          .collection("participants")
          .orderBy("score", descending: true)
          .get();

      int currentRank = 1;
      for (var doc in snapshot.docs) {
        if (doc.id == userId) {
          playerName.value = doc["nickname"] ?? "Guest";
          points.value = doc["score"] ?? 0;
          rank.value = currentRank;

          // set subtitle dynamically
          if (points.value > 1000) {
            subtitle.value = "Big cheese!";
          } else if (points.value > 500) {
            subtitle.value = "Rising star!";
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
