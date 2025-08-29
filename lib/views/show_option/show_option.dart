// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kahoot_app/constants/app_colors.dart';
// import 'package:kahoot_app/constants/app_images.dart';
// import 'package:kahoot_app/constants/app.dart';
// import 'package:kahoot_app/views/show_option/show_option_controller.dart';
//
// class ShowOptionScreen extends GetView<ShowOptionController> {
//   const ShowOptionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final quizId = controller.quizId;
//     final questionId = Get.arguments?["questionId"] ?? "";
//
//     // Prevent null navigation
//     if (quizId.isEmpty || questionId.isEmpty) {
//       return const Scaffold(
//         body: Center(child: Text("❌ Quiz ID or Question ID missing")),
//       );
//     }
//
//     return Scaffold(
//       body: AppBackground(
//         imagePath: AppImages().backgroundImage,
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("quizzes")
//               .doc(quizId)
//               .collection("questions")
//               .doc(questionId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Center(child: Text("❌ Question not found"));
//             }
//
//             final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//             final options = List<String>.from(data["options"] ?? []);
//
//             return Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildRow(options, 0, 1),
//                   const SizedBox(height: 24),
//                   _buildRow(options, 2, 3),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRow(List<String> options, int i1, int i2) {
//     final colors = [
//       AppColors().red,
//       AppColors().blue,
//       AppColors().green,
//       AppColors().orange,
//     ];
//
//     final icons = [
//       Icons.change_history,
//       Icons.diamond_outlined,
//       Icons.circle_outlined,
//       Icons.crop_square,
//     ];
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildOption(options, i1, icons[i1], colors[i1]),
//         _buildOption(options, i2, icons[i2], colors[i2]),
//       ],
//     );
//   }
//
//   Widget _buildOption(
//     List<String> options,
//     int index,
//     IconData icon,
//     Color color,
//   ) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: GestureDetector(
//           onTap: () {
//             if (options.length > index) {
//               controller.select(
//                 index,
//                 options.length > 0 ? index : 0,
//                 Get.arguments?["questionId"] ?? "",
//               );
//             }
//           },
//           child: Obx(() {
//             final isSelected = controller.selectedIndex.value == index;
//             return Container(
//               width: 250,
//               height: 180,
//               decoration: BoxDecoration(
//                 color: isSelected ? color.withOpacity(0.8) : color,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isSelected ? AppColors().white : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   index < options.length
//                       ? options[index]
//                       : "", // Show option text
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/views/show_option/show_option_controller.dart';

class ShowOptionScreen extends GetView<ShowOptionController> {
  const ShowOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizId = controller.quizId;
    final questionId = Get.arguments?["questionId"] ?? "";

    if (quizId.isEmpty || questionId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("❌ Quiz ID or Question ID missing")),
      );
    }

    return Scaffold(
      body: AppBackground(
        imagePath: AppImages().backgroundImage,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("quizzes")
              .doc(quizId)
              .collection("questions")
              .doc(questionId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("❌ Question not found"));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final options = List<String>.from(data["options"] ?? []);
            final questionText = data["questionText"] ?? "";
            final correctIndex = data["correctIndex"] ?? -1;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ show question
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                _buildRow(options, 0, 1, correctIndex, questionId),
                const SizedBox(height: 24),
                _buildRow(options, 2, 3, correctIndex, questionId),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(
    List<String> options,
    int i1,
    int i2,
    int correctIndex,
    String questionId,
  ) {
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
        _buildOption(
          options,
          i1,
          icons[i1],
          colors[i1],
          correctIndex,
          questionId,
        ),
        _buildOption(
          options,
          i2,
          icons[i2],
          colors[i2],
          correctIndex,
          questionId,
        ),
      ],
    );
  }

  Widget _buildOption(
    List<String> options,
    int index,
    IconData icon,
    Color color,
    int correctIndex,
    String questionId,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            if (options.length > index && !controller.hasAnswered.value) {
              controller.select(index, correctIndex, questionId);
            }
          },
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
              child: Center(
                child: Text(
                  index < options.length ? options[index] : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
