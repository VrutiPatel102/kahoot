import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller1 = controller;
    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgrndImage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb, size: 100, color: AppColors().yellow),
            SizedBox(height: 20),
            Text(
              'QuizTime',
              style: TextStyle(fontSize: 28, color: AppColors().white),
            ),
          ],
        ),
      ),
    );
  }
}
