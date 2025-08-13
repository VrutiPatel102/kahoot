import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'quiz_lobby_controller.dart';
import 'package:kahoot_app/constants/app_images.dart';

class QuizLobbyView extends GetView<QuizLobbyController> {
  const QuizLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      imagePath: AppImages().backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Obx(
        () => Text(
          controller.quizTitle.value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors().white,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.deepPurple.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          buildPinCodeSection(),
          SizedBox(height: 20),
          Expanded(child: buildPlayersList()),
          SizedBox(height: 20),
          buildStartButton(),
        ],
      ),
    );
  }

  Widget buildPinCodeSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors().purple,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Game PIN",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Obx(
            () => Text(
              controller.pinCode.value,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors().purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayersList() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Participants (${controller.totalParticipants.value})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: controller.players.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final player = controller.players[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors().purple,
                      child: Text(
                        player[0].toUpperCase(),
                        style: TextStyle(color: AppColors().white),
                      ),
                    ),
                    title: Text(
                      player,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStartButton() {
    return ElevatedButton(
      onPressed: controller.startQuiz,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors().purple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Text(
        "Start Quiz",
        style: TextStyle(
          fontSize: 18,
          color: AppColors().white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
