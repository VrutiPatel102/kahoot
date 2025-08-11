import 'dart:math';

import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class QuizLobbyController extends GetxController {
  var quizTitle = "My Awesome Quiz".obs;
  var players = <String>[].obs;
  var pinCode = "000000".obs;
  var totalParticipants = 0.obs;

  @override
  void onInit() {
    super.onInit();
    generateRandomPin();
    addSamplePlayers();
  }

  void addSamplePlayers() {
    players.addAll([
      "Alice",
      "Jhon",
      "Jeel",
      "Bob",
      "Charlie",
      "Daisy",
      "Ethan",
      "Fiona",
    ]);
    totalParticipants.value = players.length;
  }

  void generateRandomPin() {
    final random = Random();
    final code = 100000 + random.nextInt(900000);
    pinCode.value = code.toString();
  }

  void addPlayer(String name) {
    players.add(name);
    totalParticipants.value = players.length;
  }

  void startQuiz() {
    Get.toNamed(AppRoute.countdownScreen);
  }
}
