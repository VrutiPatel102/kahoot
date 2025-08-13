import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/loading_pinGenerate/loading_pin_contoller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPinScreen extends GetView<LoadingPinController> {
  const LoadingPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final quizTitle = args["quizTitle"] ?? "Quiz";

    controller.hostQuiz(quizTitle);

    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgrndImage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
              color: AppColors().white,
              size: 70,
            ),
            const SizedBox(height: 30),
            Text(
              "Generating PIN for \"$quizTitle\"",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: AppColors().white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
