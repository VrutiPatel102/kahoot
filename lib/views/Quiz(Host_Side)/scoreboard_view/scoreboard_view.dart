import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/scoreboard_view/scoreboard_controller.dart';

class ScoreboardView extends GetView<ScoreboardController> {
  const ScoreboardView({super.key});

  final List<String> options = const ["Lily", "Rose", "Lotus", "Sunflower"];
  final int correctAnswerIndex = 2;
  final String gamePin = "123456";
  final int currentQuestion = 3;
  final int totalQuestions = 8;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      imagePath: AppImages().backgroundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            SizedBox(height: 20),
            _buildHeader(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: currentQuestion / totalQuestions,
                      strokeWidth: 13,
                      backgroundColor: AppColors().grey300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors().green,
                      ),
                    ),
                    Center(
                      child: Text(
                        "${((currentQuestion / totalQuestions) * 100).toInt()}%",
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
            ),

            Expanded(child: _buildOptionsGrid()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "Flower __________________",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOptionsGrid() {
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
            color: optionColors[index],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(optionIcons[index], color: AppColors().white, size: 26),
                  SizedBox(width: 8),
                  Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors().white,
                    ),
                  ),
                ],
              ),

              index == correctAnswerIndex
                  ? Icon(Icons.check, color: AppColors().white, size: 26)
                  : Icon(Icons.close, color: AppColors().white, size: 26),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
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
            "Game PIN:$gamePin",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors().black,
            ),
          ),
          Text(
            "Question $currentQuestion/$totalQuestions",
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
