import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/score_status/score_status_controller.dart';

class ScoreStatusScreen extends GetView<ScoreStatusController> {
  const ScoreStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppBackground(
              imagePath: AppImages().backgrndImage,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCorrectIcon(),
                    SizedBox(height: 10),
                    _buildCorrectText(),
                    SizedBox(height: 10),
                    _buildAnswerStreak(),
                    SizedBox(height: 20),
                    _buildScoreBox(),
                    SizedBox(height: 10),
                    _buildPodiumText(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectIcon() {
    return Icon(Icons.check_circle, color: Colors.green, size: 80);
  }

  Widget _buildCorrectText() {
    return Text(
      "Correct",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAnswerStreak() {
    return Obx(
      () => Text(
        "Answer Streak ${controller.answerStreak.value}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildScoreBox() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "+ ${controller.score.value}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumText() {
    return Text(
      "You're on the podium!",
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
