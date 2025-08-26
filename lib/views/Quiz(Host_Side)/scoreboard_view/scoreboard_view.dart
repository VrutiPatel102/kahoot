import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/scoreboard_view/scoreboard_controller.dart';

class ScoreboardView extends GetView<ScoreboardController> {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      imagePath: AppImages().backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Obx(() {
          final question = controller.currentQuestion;

          if (question.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(controller.questionText),
              SizedBox(height: 20),
              _buildProgress(
                controller.currentIndex + 1,
                controller.totalQuestions,
              ),
              Expanded(
                child: _buildOptionsGrid(
                  controller.options,
                  controller.correctIndex,
                ),
              ),
              _buildBottomBar(
                controller.currentIndex + 1,
                controller.totalQuestions,
                controller.gamePin,
              ),
            ],
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors().transparent,
      actions: [
        TextButton(
          onPressed: () {
            controller.nextBtn();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors().white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text("Next", style: TextStyle(color: AppColors().black)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String questionText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        questionText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgress(int current, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: 130,
        height: 130,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: total == 0 ? 0 : current / total,
              strokeWidth: 13,
              backgroundColor: AppColors().grey300,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors().green),
            ),
            Center(
              child: Text(
                total == 0 ? "0%" : "${((current / total) * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: AppColors().black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(List<String> options, int correctIndex) {
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

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2,
      padding: const EdgeInsets.all(8),
      children: List.generate(options.length, (index) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: optionColors[index % optionColors.length],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(
                      optionIcons[index % optionIcons.length],
                      color: AppColors().white,
                      size: 26,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        options[index],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors().white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              index == correctIndex
                  ? Icon(Icons.check, color: AppColors().white, size: 26)
                  : Icon(Icons.close, color: AppColors().white, size: 26),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar(int current, int total, String gamePin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Game PIN : $gamePin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors().black,
            ),
          ),
          Text(
            "Question $current/$total",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors().black,
            ),
          ),
        ],
      ),
    );
  }
}
