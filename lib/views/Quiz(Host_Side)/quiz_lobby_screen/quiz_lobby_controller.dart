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

  // @override
  // void onInit() {
  //   super.onInit();
  //   final args = Get.arguments ?? {};
  //   quizTitle.value = args["quizTitle"] ?? "My Quiz";
  //   pinCode.value = args["pin"] ?? "";
  //   quizId = args["quizId"] ?? "";
  //   isHost = args["isHost"] ?? false;
  //   playerName = args["playerName"] ?? "";
  //
  //   if (quizId.isEmpty) {
  //     Get.snackbar("Error", "Invalid quiz ID");
  //     return;
  //   }
  //
  //   if (!isHost && playerName.isNotEmpty) {
  //     _addPlayer(playerName);
  //   }
  //
  //   _listenToParticipants();
  //   _listenToQuizStart();
  // }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizTitle.value = args["quizTitle"] ?? "My Quiz";
    quizId = args["quizId"] ?? "";
    isHost = args["isHost"] ?? false;
    playerName = args["playerName"] ?? "";

    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    // 🔹 Listen to quiz doc for pin + status updates
    FirebaseFirestore.instance
        .collection("quizzes")
        .doc(quizId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            pinCode.value = doc.data()?["pin"] ?? "";
            if (doc.data()?['status'] == 'started') {
              Get.toNamed(
                AppRoute.countdownScreen,
                arguments: {
                  "quizTitle": quizTitle.value,
                  "pin": pinCode.value,
                  "quizId": quizId,
                  "isHost": isHost,
                },
              );
            }
          }
        });

    if (!isHost && playerName.isNotEmpty) {
      _addPlayer(playerName);
    }

    _listenToParticipants();
  }

  /// Add player to participants subcollection
  Future<void> _addPlayer(String name) async {
    final participantsRef = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('participants');

    await participantsRef.add({
      'nickname': name,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Listen for participant changes
  void _listenToParticipants() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('participants')
        .orderBy('joinedAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final names = snapshot.docs
              .map((doc) => (doc.data()['nickname'] ?? 'Unknown').toString())
              .toList();

          players.assignAll(names);
          totalParticipants.value = names.length;
        });
  }

  /// Host starts the quiz
  Future<void> startQuiz() async {
    if (!isHost) return;

    if (players.isEmpty) {
      Get.snackbar("Error", "Cannot start quiz without participants!");
      return;
    }

    await FirebaseFirestore.instance.collection('quizzes').doc(quizId).update({
      'status': 'started',
    });
  }

  /// Listen for quiz status changes to move players to countdown
  void _listenToQuizStart() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .snapshots()
        .listen((doc) {
          if (doc.exists && (doc.data()?['status'] == 'started')) {
            Get.toNamed(
              AppRoute.countdownScreen,
              arguments: {
                "quizTitle": quizTitle.value,
                "pin": pinCode.value,
                "quizId": quizId,
                "isHost": isHost,
              },
            );
          }
        });
  }

  @override
  void onClose() async {
    if (!isHost && playerName.isNotEmpty) {
      final participantsRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('participants');

      // Find and remove the player's document
      final snapshot = await participantsRef
          .where('nickname', isEqualTo: playerName)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
    super.onClose();
  }
}
