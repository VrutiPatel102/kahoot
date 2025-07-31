import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/views/join_quiz/join_controller.dart';

class JoinQuiz extends GetView<JoinController> {
  const JoinQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return AppBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("MyApp", style: TextStyle(fontSize: 50)),
          _container(),
        ],
      ),
    );
  }

  Widget _container() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: 320,
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            // controller: controller.pinController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Game PIN',
              hintStyle: TextStyle(fontSize: 22),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              // controller.onEnterPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size.fromHeight(68),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
              ),
              child: Text(
                'Enter',
                style: TextStyle(color: AppColors().white, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
