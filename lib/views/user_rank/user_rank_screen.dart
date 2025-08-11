import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'user_rank_controller.dart';

class UserRankScreen extends GetView<UserRankController> {
  const UserRankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppBackground(
              imagePath: AppImages().backgrndImage,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlayerName(),
                    SizedBox(height: 10),
                    _buildInitialCircle(),
                    SizedBox(height: 10),
                    _buildRankBadge(),
                    SizedBox(height: 8),
                    _buildPointsText(),
                    SizedBox(height: 4),
                    _buildSubtitle(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerName() {
    return Obx(
      () => Text(
        controller.playerName.value,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors().black,
        ),
      ),
    );
  }

  Widget _buildInitialCircle() {
    return Obx(() {
      String initial = controller.playerName.value.isNotEmpty
          ? controller.playerName.value[0].toUpperCase()
          : "?";
      return CircleAvatar(
        radius: 50,
        backgroundColor: AppColors().purple700,
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors().white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  Widget _buildRankBadge() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors().amber,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "Rank ${controller.rank.value}",
          style: TextStyle(
            color: AppColors().white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPointsText() {
    return Obx(
      () => Text(
        "${controller.points.value} points",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Obx(
      () => Text(
        controller.subtitle.value,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}
