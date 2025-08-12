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
          buildProgressBar(),
          const SizedBox(height: 20),
          buildQuestionText(),
          const SizedBox(height: 20),
          Expanded(child: buildOptionsList()),
          const SizedBox(height: 20),
          buildNextButton(),
        ],
      ),
    );
  }

  Widget buildProgressBar() {
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

  Widget buildQuestionText() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          controller.questionText.value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildOptionsList() {
    final optionColors = [Colors.red, Colors.blue, Colors.orange, Colors.green];

    final optionIcons = [
      Icons.change_history, // triangle
      Icons.diamond, // diamond
      Icons.circle, // circle
      Icons.crop_square, // square
    ];

    return Obx(
      () => ListView.separated(
        itemCount: controller.options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Icon(optionIcons[index], color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget buildNextButton() {
    return ElevatedButton(
      onPressed: controller.goToNextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors().purple,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Text(
        controller.isLastQuestion ? "Finish Quiz" : "Next Question",
        style: TextStyle(
          fontSize: 18,
          color: AppColors().white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
