import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
            top: 45,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: AppColors().black),
            ),
          ),
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
            "Welcome!",
            style: TextStyle(
              fontSize: 40,
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
      width: 350,
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _textField(
            hintText: 'Email',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),
          _textField(
            hintText: 'Password',
            controller: controller.passwordController,
            obscureText: true,
          ),
          SizedBox(height: 15),
          _loginBtn(),
        ],
      ),
    );
  }

  Widget _textField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          'Login',
          style: TextStyle(color: AppColors().white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _bottomText() {
    return GestureDetector(
      onTap: controller.register,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: AppColors().white),
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: "Register",
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
