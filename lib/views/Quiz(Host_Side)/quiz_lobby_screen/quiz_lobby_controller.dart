import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizLobbyController extends GetxController {
  var quizTitle = "My Awesome Quiz".obs;
  var players = <String>[].obs;
  var pinCode = "".obs;
  var totalParticipants = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool isHost;
  String? quizId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    isHost = args['isHost'] ?? false;

    if (isHost) {
      _createQuizInFirestore();
    } else {
      final pin = args['pin'];
      _listenToPlayers(pin);
    }
  }

  Future<void> _createQuizInFirestore() async {
    final random = Random();
    final generatedPin = (100000 + random.nextInt(900000)).toString();
    pinCode.value = generatedPin;

    final docRef = await _firestore.collection('quizzes').add({
      'pin': generatedPin,
      'hostId': _auth.currentUser?.uid,
      'quizStarted': false,
      'players': [],
    });

    quizId = docRef.id;
    _listenToPlayers(generatedPin);
  }

  void _listenToPlayers(String pin) {
    _firestore
        .collection('quizzes')
        .where('pin', isEqualTo: pin)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final List playerList = data['players'] ?? [];
        players.value = List<String>.from(playerList);
        totalParticipants.value = players.length;
        quizId = snapshot.docs.first.id;
      }
    });
  }

  Future<void> addPlayer(String name) async {
    if (quizId == null) return;
    await _firestore.collection('quizzes').doc(quizId).update({
      'players': FieldValue.arrayUnion([name]),
    });
  }

  void startQuiz() async {
    if (!isHost || quizId == null) return;
    await _firestore.collection('quizzes').doc(quizId).update({
      'quizStarted': true,
    });
    Get.toNamed(AppRoute.countdownScreen);
  }
}
