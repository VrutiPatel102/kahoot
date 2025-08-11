import 'package:get/get.dart';

class QuizLobbyController extends GetxController {
  // Example reactive values
  var quizTitle = "My Awesome Quiz".obs;
  var players = <String>[].obs;
  var pinCode = "123456".obs;

  // Simulate adding players
  void addPlayer(String name) {
    players.add(name);
  }

  // Start quiz action
  void startQuiz() {
    // TODO: Navigate to the quiz question screen
  }
}
