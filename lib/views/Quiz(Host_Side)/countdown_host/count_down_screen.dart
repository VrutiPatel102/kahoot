import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app.dart';
import 'countdown_controller.dart';

class CountdownView extends GetView<CountdownController> {
  const CountdownView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Stack(children: [_buildBackground(), _buildCountdown()]);
  }

  Widget _buildBackground() {
    return AppBackground(
      imagePath: AppImages().backgroundImage,
      child: SizedBox.expand(),
    );
  }

  Widget _buildCountdown() {
    return Center(
      child: Obx(() {
        return FadeIn(
          key: ValueKey(controller.countdown.value),
          duration: Duration(milliseconds: 800),
          child: ZoomIn(
            duration: Duration(milliseconds: 800),
            child: _buildCountdownContainer(),
          ),
        );
      }),
    );
  }

  Widget _buildCountdownContainer() {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        color: AppColors().purple,
        shape: BoxShape.rectangle,
      ),
      alignment: Alignment.center,
      child: _buildCountdownText(),
    );
  }

  Widget _buildCountdownText() {
    return Text(
      controller.countdown.value.toString(),
      style: TextStyle(
        fontSize: 150,
        fontWeight: FontWeight.bold,
        color: AppColors().white,
      ),
    );
  }
}
