import 'dart:math';

import 'package:get/get.dart';

class QuizLobbyController extends GetxController {
  var quizTitle = "My Awesome Quiz".obs;
  var players = <String>[].obs;
  var pinCode = "000000".obs;

  @override
  void onInit() {
    super.onInit();
    generateRandomPin();
    addSamplePlayers();
  }

  void addSamplePlayers() {
    players.addAll(["Alice", "Bob", "Charlie", "Daisy", "Ethan", "Fiona"]);
  }

  void generateRandomPin() {
    final random = Random();
    final code = 100000 + random.nextInt(900000);
    pinCode.value = code.toString();
  }

  void addPlayer(String name) {
    players.add(name);
  }

  void startQuiz() {}
}
