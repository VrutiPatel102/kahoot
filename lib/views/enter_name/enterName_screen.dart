import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/enter_name/enterName_controller.dart';

class NicknameScreen extends GetView<EnterNickNameController> {
  const NicknameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return AppBackground(
      imagePath: AppImages().backgrndImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Quiz Time!",
            style: TextStyle(
              fontSize: 50,
              color: AppColors().white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 30),
          _container(),
        ],
      ),
    );
  }

  Widget _container() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 170,
      width: 350,
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_nickname(), SizedBox(height: 15), _btn()],
      ),
    );
  }

  Widget _btn() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.onSubmitNickname();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          'OK, go!',
          style: TextStyle(color: AppColors().white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _nickname() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller.nicknameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Nickname',
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
