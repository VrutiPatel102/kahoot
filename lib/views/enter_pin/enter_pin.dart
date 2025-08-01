import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'enterPin_controller.dart';

class EnterPin extends GetView<EnterPinController> {
  const EnterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(child: _bottomText()),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return AppBackground(
      imagePath: AppImages().backgrndImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "MyApp!",
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
      padding: const EdgeInsets.all(15),
      height: 170,
      width: 350,
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_pin(), SizedBox(height: 15), _enterBtn()],
      ),
    );
  }

  Widget _enterBtn() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.onEnterPin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          'Enter',
          style: TextStyle(color: AppColors().white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _pin() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller.pinController,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Game PIN',
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _bottomText() {
    return GestureDetector(
      onTap: controller.login,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: AppColors().white),
          children: [
            const TextSpan(text: "Create your own quiz? "),
            TextSpan(
              text: "Login",
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
