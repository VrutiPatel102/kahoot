import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/show_nickname/show_nickname_controller.dart';


class ShowNicknameScreen extends GetView<ShowNickNameController> {
  const ShowNicknameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(controller.initial, controller.fullName),
    );
  }

  Widget _buildBody(String initial, String fullName) {
    return AppBackground(
      imagePath: AppImages().backgrndImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors().purple700,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors().white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're in! See your nickname on screen?",
            style: TextStyle(
              fontSize: 16,
              color: AppColors().white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
