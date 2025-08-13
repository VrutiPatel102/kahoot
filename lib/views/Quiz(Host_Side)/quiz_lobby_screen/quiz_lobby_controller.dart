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

    final args = Get.arguments ?? {};
    quizTitle.value = args["quizTitle"] ?? "My Quiz";
    pinCode.value = args["pin"] ?? "";
    quizId = args["quizId"] ?? "";
    isHost = args["isHost"] ?? false;
    playerName = args["playerName"] ?? "";

    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    // Host joins automatically if no playerName (optional)
    if (!isHost && playerName.isNotEmpty) {
      _addPlayer(playerName);
    }

    // Listen to participants in real-time
    _listenToParticipants();
  }

  // Add participant to Firestore (if joining)
  Future<void> _addPlayer(String name) async {
    final docRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);

    // Add to players array
    await docRef.update({
      'players': FieldValue.arrayUnion([name]),
    });
  }

  // Listen to live participants
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

  @override
  void onClose() async {
    // Optional: Remove player on exit (if not host)
    if (!isHost && playerName.isNotEmpty) {
      final docRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId);
      await docRef.update({
        'players': FieldValue.arrayRemove([playerName]),
      });
    }
    super.onClose();
  }
}
