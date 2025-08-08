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
        child: Obx(() => _buildOptionsGrid()),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final controller = Get.find<ShowOptionController>();

    final colors = [
      AppColors().red,
      AppColors().blue,
      AppColors().green,
      AppColors().orange,
    ];

    final icons = [
      Icons.change_history,
      Icons.hexagon_outlined,
      Icons.circle_outlined,
      Icons.crop_square,
    ];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(0, 1, icons, colors, controller),
          SizedBox(height: 24),
          _buildRow(2, 3, icons, colors, controller),
        ],
      ),
    );
  }

  Widget _buildRow(
    int i1,
    int i2,
    List<IconData> icons,
    List<Color> colors,
    ShowOptionController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOption(i1, icons[i1], colors[i1], controller),
        _buildOption(i2, icons[i2], colors[i2], controller),
      ],
    );
  }

  Widget _buildOption(
    int index,
    IconData icon,
    Color color,
    ShowOptionController controller,
  ) {
    final isSelected = controller.selectedIndex.value == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => controller.select(index),
          child: Container(
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
          ),
        ),
      ),
    );
  }
}
