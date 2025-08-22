import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/constants/app_images.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/dashboard_host/dashboard_controller.dart';

class HostDashboardView extends GetView<HostDashboardController> {
  const HostDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController quizTitleController = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: AppBackground(
          imagePath: AppImages().backgroundImage,
          child: TabBarView(
            children: [
              _buildViewQuizzesTab(),
              _buildCreateQuizTab(quizTitleController),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Host Dashboard"),
      bottom: const TabBar(
        tabs: [
          Tab(text: "View Quizzes"),
          Tab(text: "Create Quiz"),
        ],
      ),
    );
  }

  /// ------------------ VIEW QUIZZES TAB ------------------
  Widget _buildViewQuizzesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No quizzes found"));
        }

        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final quizTitle = data['title'] ?? 'Untitled Quiz';

            return ExpansionTile(
              title: Text(
                "${index + 1}) $quizTitle",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                // QUESTIONS
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('quizzes')
                      .doc(doc.id)
                      .collection('questions')
                      .snapshots(),
                  builder: (context, questionSnapshot) {
                    if (questionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!questionSnapshot.hasData ||
                        questionSnapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No Questions added yet"),
                      );
                    }
                    return Column(
                      children: questionSnapshot.data!.docs.map((qDoc) {
                        final qData = qDoc.data() as Map<String, dynamic>;
                        final questionText =
                            qData['questionText'] ?? 'Untitled Question';
                        final options = List<String>.from(
                          qData['options'] ?? [],
                        );
                        final correctIndex = qData['correctIndex'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            title: Text(questionText),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < options.length; i++)
                                  Text(
                                    "(${i + 1}) ${options[i]}",
                                    style: TextStyle(
                                      color: i == correctIndex
                                          ? AppColors().green
                                          : AppColors().black,
                                      fontWeight: i == correctIndex
                                          ? FontWeight.w700
                                          : FontWeight.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // HOST BUTTON
                ElevatedButton.icon(
                  onPressed: () {
                    _showHostConfirmationDialog(quizTitle, doc.id);
                  },
                  icon: Icon(Icons.play_arrow, color: AppColors().white),
                  label: Text(
                    "Host This Quiz",
                    style: TextStyle(color: AppColors().white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().green,
                  ),
                ),
                // DELETE BUTTON
                TextButton.icon(
                  onPressed: () {
                    controller.deleteQuiz(doc.id);
                  },
                  icon: Icon(Icons.delete, color: AppColors().red),
                  label: Text(
                    "Delete Quiz",
                    style: TextStyle(color: AppColors().red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHostConfirmationDialog(String quizTitle, String quizId) {
    Get.dialog(
      AlertDialog(
        title: const Text("Host Quiz"),
        content: Text("Are you sure you want to host '$quizTitle'?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: AppColors().black)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.hostQuiz(quizTitle, quizId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors().green),
            child: Text(
              "Yes, Host",
              style: TextStyle(color: AppColors().white),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------ CREATE QUIZ TAB ------------------
  Widget _buildCreateQuizTab(TextEditingController quizTitleController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: quizTitleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors().white,
                hintText: "Quiz Title",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () => _showAddQuestionDialog(),
              child: Text(
                "Add Question",
                style: TextStyle(color: AppColors().black),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text("Questions Added: ${controller.tempQuestions.length}"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () async {
                await controller.saveQuiz(quizTitleController.text.trim());
                quizTitleController.clear();
              },
              child: Text(
                "Save Quiz",
                style: TextStyle(color: AppColors().black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddQuestionDialog() {
    final questionController = TextEditingController();
    final optionControllers = List.generate(4, (_) => TextEditingController());
    final RxInt correctIndex = 0.obs;

    Get.dialog(
      AlertDialog(
        title: const Text("Add Question"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              for (int i = 0; i < 4; i++)
                TextField(
                  controller: optionControllers[i],
                  decoration: InputDecoration(labelText: "Option ${i + 1}"),
                ),
              Obx(
                () => DropdownButton<int>(
                  value: correctIndex.value,
                  items: List.generate(
                    4,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text("Correct Answer: Option ${i + 1}"),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      correctIndex.value = val;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.addTempQuestion(
                questionController.text.trim(),
                optionControllers.map((c) => c.text.trim()).toList(),
                correctIndex.value,
              );
              Get.back();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
