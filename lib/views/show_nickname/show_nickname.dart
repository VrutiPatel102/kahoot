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
    return Scaffold(body: _buildBody(controller.initial, controller.fullName));
  }

  Widget _buildBody(String initial, String fullName) {
    return AppBackground(
      imagePath: AppImages().backgrndImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _letterInitial(initial),
          SizedBox(height: 16),
          _fullNameText(fullName),
          SizedBox(height: 10),
          _messageText(),
        ],
      ),
    );
  }

  Widget _letterInitial(String initial) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: AppColors().purple700,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 40,
          color: AppColors().white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _fullNameText(String fullName) {
    return Text(
      fullName,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors().white,
      ),
    );
  }

  Widget _messageText() {
    return Text(
      "You're in! See your nickname on screen?",
      style: TextStyle(fontSize: 16, color: AppColors().white.withOpacity(0.9)),
    );
  }
}
