import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_lobby_controller.dart';

class QuizLobbyView extends GetView<QuizLobbyController> {
  const QuizLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Obx(() => Text(controller.quizTitle.value)),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildPinCodeSection(),
          const SizedBox(height: 20),
          buildPlayersList(),
          const Spacer(),
          buildStartButton(),
        ],
      ),
    );
  }

  Widget buildPinCodeSection() {
    return Column(
      children: [
        const Text(
          "Game PIN",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Obx(
          () => Text(
            controller.pinCode.value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPlayersList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.players.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(controller.players[index][0].toUpperCase()),
              ),
              title: Text(controller.players[index]),
            );
          },
        ),
      ),
    );
  }

  Widget buildStartButton() {
    return ElevatedButton(
      onPressed: controller.startQuiz,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text("Start Quiz", style: TextStyle(fontSize: 18)),
    );
  }
}
