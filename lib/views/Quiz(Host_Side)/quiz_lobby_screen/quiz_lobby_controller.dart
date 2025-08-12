import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizLobbyController extends GetxController {
  var players = <String>[].obs;
  var totalParticipants = 0.obs;
  var quizTitle = ''.obs;
  var pinCode = ''.obs; // for UI display

  late String pin;
  late bool isHost;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    pin = args['pin'] ?? '';
    isHost = args['isHost'] ?? false;

    if (pin.isEmpty) {
      Get.snackbar("Error", "No PIN provided");
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(AppRoute.enterPin);
      });
      return;
    }

    // show PIN in the UI
    pinCode.value = pin;

    // start listening to players
    listenToPlayers();
  }

  void listenToPlayers() {
    FirebaseFirestore.instance
        .collection('quizzes')
        .doc(pin)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        players.value = List<String>.from(snapshot['players'] ?? []);
        totalParticipants.value = players.length;
        quizTitle.value = snapshot['title'] ?? 'Quiz Lobby';

        if (snapshot['status'] == 'started' && !isHost) {
          Get.toNamed(AppRoute.getReadyLoading);
        }
      }
    });
  }

  Future<void> startQuiz() async {
    if (isHost) {
      await FirebaseFirestore.instance.collection('quizzes').doc(pin).update({
        'status': 'started',
      });
      Get.toNamed(AppRoute.getReadyLoading);
    }
  }
}
