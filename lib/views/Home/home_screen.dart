import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_buttons.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Home/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return AppBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_joinBtn(), SizedBox(height: 20), _createBtn()],
      ),
    );
  }

  Widget _joinBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomButton(
        text: "Join Quiz",
        onPressed: () {
          controller.onJoinQuiz();
        },
      ),
    );
  }

  Widget _createBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomButton(
        text: "Create Quiz",
        onPressed: () {
          controller.onCreateQuiz();
        },
      ),
    );
  }
}
