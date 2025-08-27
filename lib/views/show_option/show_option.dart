import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/views/show_option/show_option_controller.dart';

class ShowOptionScreen extends GetView<ShowOptionController> {
  const ShowOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgroundImage,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildRow(0, 1), SizedBox(height: 24), _buildRow(2, 3)],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int i1, int i2) {
    final colors = [
      AppColors().red,
      AppColors().blue,
      AppColors().green,
      AppColors().orange,
    ];

    final icons = [
      Icons.change_history,
      Icons.diamond_outlined,
      Icons.circle_outlined,
      Icons.crop_square,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOption(i1, icons[i1], colors[i1]),
        _buildOption(i2, icons[i2], colors[i2]),
      ],
    );
  }

  Widget _buildOption(int index, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => controller.select(index),
          child: Obx(() {
            final isSelected = controller.selectedIndex.value == index;
            return Container(
              width: 250,
              height: 180,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.8) : color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors().white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(icon, color: AppColors().white, size: 48),
            );
          }),
        ),
      ),
    );
  }
}
