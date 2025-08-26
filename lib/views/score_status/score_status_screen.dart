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
                    const SizedBox(height: 10),
                    _buildCorrectText(),
                    const SizedBox(height: 10),
                    _buildAnswerStreak(),
                    const SizedBox(height: 20),
                    _buildEarnedPointsBox(),
                    const SizedBox(height: 10),
                    _buildTotalScoreBox(),
                    const SizedBox(height: 20),
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

  /// Dynamic correct/wrong icon
  Widget _buildCorrectIcon() {
    return Obx(() {
      final isCorrect = controller.isCorrectAnswer.value;
      return Icon(
        isCorrect ? Icons.check_circle : Icons.cancel,
        color: isCorrect ? Colors.green : Colors.red,
        size: 80,
      );
    });
  }

  /// Dynamic correct/wrong text
  Widget _buildCorrectText() {
    return Obx(() {
      final isCorrect = controller.isCorrectAnswer.value;
      return Text(
        isCorrect ? "Correct" : "Wrong",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isCorrect ? Colors.green : Colors.red,
        ),
      );
    });
  }

  Widget _buildAnswerStreak() {
    return Obx(
          () => Text(
        "Answer Streak ${controller.answerStreak.value}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Points earned this round
  Widget _buildEarnedPointsBox() {
    return Obx(() {
      final isCorrect = controller.isCorrectAnswer.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isCorrect
              ? Colors.green.withOpacity(0.8)
              : Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isCorrect
              ? "+${controller.lastEarnedPoints.value}"
              : "0",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  /// Running total score
  Widget _buildTotalScoreBox() {
    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Total: ${controller.score.value}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumText() {
    return const Text(
      "You're on the podium!",
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
