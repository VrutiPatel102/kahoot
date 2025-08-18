import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/que_loading/que_loading_controller.dart';

class QueLoadingScreen extends GetView<QueLoadingController> {
  const QueLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QueLoadingController controller3 = controller;
    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgrndImage,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _titleText(),
              SizedBox(height: 25),
              _loadingIndicator(),
              SizedBox(height: 20),
              _loadingText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return Text(
      'Que Loading!',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w900,
        color: AppColors().white,
      ),
    );
  }

  Widget _loadingIndicator() {
    return CircularProgressIndicator(color: AppColors().white, strokeWidth: 8);
  }

  Widget _loadingText() {
    return Text(
      'Loading...',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: AppColors().white.withOpacity(0.8),
      ),
    );
  }
}
