// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/constants/app.dart';
// import 'package:kahoot_app/constants/app_colors.dart';
// import 'package:kahoot_app/constants/app_images.dart';
// import 'package:kahoot_app/views/score_status/score_status_controller.dart';
//
// class ScoreStatusScreen extends GetView<ScoreStatusController> {
//   const ScoreStatusScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors().white,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: AppBackground(
//               imagePath: AppImages().backgrndImage,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildCorrectIcon(),
//                     SizedBox(height: 10),
//                     _buildCorrectText(),
//                     SizedBox(height: 10),
//                     _buildAnswerStreak(),
//                     SizedBox(height: 20),
//                     _buildScoreBox(),
//                     SizedBox(height: 10),
//                     _buildPodiumText(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCorrectIcon() {
//     return Icon(Icons.check_circle, color: Colors.green, size: 80);
//   }
//
//   Widget _buildCorrectText() {
//     return Text(
//       "Correct",
//       style: TextStyle(
//         fontSize: 28,
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//       ),
//     );
//   }
//
//   Widget _buildAnswerStreak() {
//     return Obx(
//       () => Text(
//         "Answer Streak ${controller.answerStreak.value}",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   Widget _buildScoreBox() {
//     return Obx(
//       () => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.8),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           "+ ${controller.score.value}",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPodiumText() {
//     return Text(
//       "You're on the podium!",
//       style: TextStyle(fontSize: 16, color: Colors.black),
//     );
//   }
// }

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
                    _buildStatusIcon(),
                    const SizedBox(height: 10),
                    _buildStatusText(),
                    const SizedBox(height: 10),
                    _buildAnswerStreak(),
                    const SizedBox(height: 20),
                    _buildScoreBox(),
                    const SizedBox(height: 10),
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

  /// ✅ Dynamic Icon based on status
  Widget _buildStatusIcon() {
    return Obx(() {
      switch (controller.status.value) {
        case "correct":
          return const Icon(Icons.check_circle, color: Colors.green, size: 80);
        case "wrong":
          return const Icon(Icons.cancel, color: Colors.red, size: 80);
        case "timeout":
          return const Icon(Icons.access_time, color: Colors.orange, size: 80);
        default:
          return const SizedBox.shrink();
      }
    });
  }

  /// ✅ Dynamic Text based on status
  Widget _buildStatusText() {
    return Obx(() {
      String text = "";
      Color color = Colors.black;

      switch (controller.status.value) {
        case "correct":
          text = "Correct!";
          color = Colors.green;
          break;
        case "wrong":
          text = "Wrong!";
          color = Colors.red;
          break;
        case "timeout":
          text = "Time’s Up!";
          color = Colors.orange;
          break;
      }

      return Text(
        text,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );
    });
  }

  /// 🔥 Show streak
  Widget _buildAnswerStreak() {
    return Obx(
      () => Text(
        "Answer Streak: ${controller.answerStreak.value}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// 🎯 Show score
  Widget _buildScoreBox() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Score: ${controller.score.value}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Podium encouragement
  Widget _buildPodiumText() {
    return const Text(
      "You're on the podium!",
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
