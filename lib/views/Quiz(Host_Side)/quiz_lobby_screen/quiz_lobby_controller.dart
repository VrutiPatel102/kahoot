import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizLobbyController extends GetxController {
  var quizTitle = "".obs;
  var pinCode = "".obs;
  var enteredPin = "".obs;
  var players = <String>[].obs;
  var totalParticipants = 0.obs;
  var isHost = false;
  late String playerName;
  late String quizId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    quizTitle.value = args["quizTitle"] ?? "My Quiz";
    pinCode.value = args["pin"] ?? "";
    quizId = args["quizId"] ?? "";
    isHost = args["isHost"] ?? false;
    playerName = args["playerName"] ?? "";
    enteredPin.value = args["enteredPin"] ?? ""; // Participant input pin

    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    if (isHost) {
      _clearOldParticipants();
    }

    if (!isHost && playerName.isNotEmpty) {
      _addPlayerWithPin(playerName, enteredPin.value);
    }

    _listenToParticipants();
    _listenToQuizStart();
  }

  Future<void> _clearOldParticipants() async {
    final participantsRef = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('participants');

    final snapshot = await participantsRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _addPlayerWithPin(String name, String pin) async {
    if (pin != pinCode.value) {
      Get.snackbar("Error", "Incorrect pin! Please try again.");
      return;
    }

    final participantsRef = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('participants');

    final existing = await participantsRef
        .where('nickname', isEqualTo: name)
        .limit(1)
        .get();

    if (existing.docs.isEmpty) {
      await participantsRef.add({
        'nickname': name,
        'joinedAt': FieldValue.serverTimestamp(),
      });
    }
  }

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

  Future<void> startQuiz() async {
    if (!isHost) return;

    if (players.isEmpty) {
      Get.snackbar("Error", "Cannot start quiz without participants!");
      return;
    }

    await FirebaseFirestore.instance.collection('quizzes').doc(quizId).update({
      'status': 'started',
      'startedAt': FieldValue.serverTimestamp(),
    });
  }

  void _listenToQuizStart() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .snapshots()
        .listen((doc) {
          if (doc.exists && doc.data()?['status'] == 'started') {
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
