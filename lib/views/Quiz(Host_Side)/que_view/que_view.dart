import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view_controller.dart';

class QuizQuestionView extends GetView<QuizQuestionController> {
  const QuizQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      imagePath: AppImages().backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Obx(
        () => Text(
          "Question ${controller.currentQuestionIndex.value + 1} of ${controller.totalQuestions}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors().white,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.deepPurple.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressBar(),
          SizedBox(height: 20),
          _buildQuestionText(),
          SizedBox(height: 20),
          Expanded(child: _buildOptionsList()),
          SizedBox(height: 20),
          // _buildNextButton(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      double progress = (controller.remainingTime.value / controller.totalTime)
          .clamp(0.0, 1.0);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          color: AppColors().purple,
          minHeight: 18,
        ),
      );
    });
  }

  Widget _buildQuestionText() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          controller.questionText.value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    final optionColors = [
      AppColors().red,
      AppColors().blue,
      AppColors().green,
      AppColors().orange,
    ];

    final optionIcons = [
      Icons.change_history,
      Icons.diamond,
      Icons.circle_outlined,
      Icons.crop_square,
    ];

    return Obx(
      () => ListView.separated(
        itemCount: controller.options.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final option = controller.options[index];
          final isSelected = controller.selectedOptionIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectOption(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: optionColors[index].withOpacity(isSelected ? 0.8 : 1.0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors().white
                      : AppColors().transparent,
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Icon(optionIcons[index], color: AppColors().white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors().white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Text(
          "Game PIN : ${controller.pin}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors().black,
          ),
        ),
      ),
    );
  }
}
