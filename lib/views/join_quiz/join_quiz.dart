import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/join_quiz/join_controller.dart';

class JoinQuiz extends GetView<JoinController> {
  const JoinQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return AppBackground(
      imagePath: AppImages().backgrndImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("MyApp", style: TextStyle(fontSize: 50))],
      ),
    );
  }
}
