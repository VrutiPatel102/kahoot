// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class QuizLobbyController extends GetxController {
//   var quizTitle = "".obs;
//   var pinCode = "".obs;
//   var players = <String>[].obs;
//   var totalParticipants = 0.obs;
//   var isHost = false;
//   late String playerName;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Get arguments from navigation
//     final args = Get.arguments ?? {};
//     quizTitle.value = args["quizTitle"] ?? "My Quiz";
//     pinCode.value = args["pin"] ?? _generatePin();
//     isHost = args["isHost"] ?? false;
//     playerName = args["playerName"] ?? "Player${Random().nextInt(1000)}";
//
//     if (isHost) {
//       _createQuizInFirestore();
//     } else {
//       _joinQuiz();
//     }
//
//     _listenToPlayers();
//   }
//
//   // Generate a 6-digit PIN
//   String _generatePin() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }
//
//   // Create quiz doc in Firestore (host only)
//   Future<void> _createQuizInFirestore() async {
//     await FirebaseFirestore.instance
//         .collection('quizzes')
//         .doc(pinCode.value)
//         .set({
//           'quizTitle': quizTitle.value,
//           'pin': pinCode.value,
//           'status': 'waiting',
//           'players': [],
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//   }
//
//   // Participant joins quiz
//   Future<void> _joinQuiz() async {
//     final docRef = FirebaseFirestore.instance
//         .collection('quizzes')
//         .doc(pinCode.value);
//     final docSnap = await docRef.get();
//
//     if (docSnap.exists) {
//       await docRef.update({
//         'players': FieldValue.arrayUnion([playerName]),
//       });
//     }
//   }
//
//   // Remove participant on exit
//   Future<void> _leaveQuiz() async {
//     if (!isHost) {
//       final docRef = FirebaseFirestore.instance
//           .collection('quizzes')
//           .doc(pinCode.value);
//       await docRef.update({
//         'players': FieldValue.arrayRemove([playerName]),
//       });
//     }
//   }
//
//   // Listen for Firestore updates
//   void _listenToPlayers() {
//     FirebaseFirestore.instance
//         .collection('quizzes')
//         .doc(pinCode.value)
//         .snapshots()
//         .listen((doc) {
//           if (doc.exists) {
//             final data = doc.data() ?? {};
//             final playerList = List<String>.from(data['players'] ?? []);
//             players.assignAll(playerList);
//             totalParticipants.value = playerList.length;
//           }
//         });
//   }
//
//   // Start quiz (host only)
//   Future<void> startQuiz() async {
//     if (!isHost) return;
//
//     await FirebaseFirestore.instance
//         .collection('quizzes')
//         .doc(pinCode.value)
//         .update({'status': 'started'});
//
//     Get.toNamed(
//       AppRoute.queScreen,
//       arguments: {
//         "quizTitle": quizTitle.value,
//         "pin": pinCode.value,
//         "isHost": true,
//       },
//     );
//   }
//
//   @override
//   void onClose() {
//     _leaveQuiz();
//     super.onClose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizLobbyController extends GetxController {
  var quizTitle = "".obs;
  var pinCode = "".obs;
  var players = <String>[].obs;
  var totalParticipants = 0.obs;
  var isHost = false;
  late String playerName;
  late String quizId;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    final args = Get.arguments ?? {};
    quizTitle.value = args["quizTitle"] ?? "My Quiz";
    pinCode.value = args["pin"] ?? "";
    isHost = args["isHost"] ?? false;
    playerName = args["playerName"] ?? "";
    quizId = args["quizId"] ?? "";

    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    // Listen to participants in real time
    _listenToParticipants();
  }

  // Listen for live participants
  void _listenToParticipants() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('participants')
        .orderBy('joinedAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final names = snapshot.docs.map((doc) {
            final data = doc.data();
            return data['nickname'] ?? 'Unknown';
          }).toList();

          players.assignAll(List<String>.from(names));
          totalParticipants.value = names.length;
        });
  }

  // Start quiz (host only)
  Future<void> startQuiz() async {
    if (!isHost) return;

    await FirebaseFirestore.instance.collection('quizzes').doc(quizId).update({
      'status': 'started',
    });

    Get.toNamed(
      AppRoute.queScreen,
      arguments: {
        "quizTitle": quizTitle.value,
        "pin": pinCode.value,
        "quizId": quizId,
        "isHost": true,
      },
    );
  }
}
