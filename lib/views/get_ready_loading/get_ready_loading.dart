import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/views/get_ready_loading/get_ready_loading_controller.dart';

class GetReadyLoadingScreen extends GetView<GetReadyLoadingController> {
  const GetReadyLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GetReadyLoadingController controller2 = controller;
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
      'Get Ready!',
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
