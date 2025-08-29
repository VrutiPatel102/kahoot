import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/final_rank/final_rank_controller.dart';

class FinalRankView extends StatelessWidget {
  final controller = Get.put(FinalRankController());

  FinalRankView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgroundImage,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'QuizBuzz!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors().white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors().white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  'firstquiz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Obx(() {
                final players = controller.players;
                return SizedBox(
                  height: size.height * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildPodiumCard(
                        players[1],
                        2,
                        AppColors().pink,
                        size,
                        180,
                      ),
                      _buildPodiumCard(
                        players[0],
                        1,
                        AppColors().orange,
                        size,
                        220,
                      ),
                      _buildPodiumCard(
                        players[2],
                        3,
                        AppColors().deepOrange,
                        size,
                        150,
                      ),
                    ],
                  ),
                );
              }),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumCard(
    Player player,
    int rank,
    Color color,
    Size size,
    double height,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 120,
          height: height,
          decoration: BoxDecoration(
            color: AppColors().deeppurple700,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors().white,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                player.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors().white,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 8),
              Text(
                player.score.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors().white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Text(
              rank.toString(),
              style: TextStyle(
                color: AppColors().white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),

        Positioned(
          top: -67,
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppColors().green,
            child: Text(
              player.name.isNotEmpty ? player.name[0].toUpperCase() : '',
              style: TextStyle(
                fontSize: 36,
                color: AppColors().white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
