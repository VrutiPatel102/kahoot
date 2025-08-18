import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/dashboard_host/dashboard_controller.dart';

class HostDashboardView extends StatelessWidget {
  const HostDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: AppBackground(
          imagePath: 'assets/images/backgroundImage.jpg',
          child: TabBarView(
            children: [_buildViewQuizzesTab(), _buildCreateQuizTab(context)],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("Host Dashboard"),
      bottom: TabBar(
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
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No quizzes found"));
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
                        child: Text("No questions added yet"),
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
                                    "${i + 1}. ${options[i]}",
                                    style: TextStyle(
                                      color: i == correctIndex
                                          ? AppColors().green
                                          : AppColors().black,
                                      fontWeight: i == correctIndex
                                          ? FontWeight.bold
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
                ElevatedButton.icon(
                  onPressed: () {
                    showHostConfirmationDialog(context, quizTitle, doc.id);
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
              ],
            );
          },
        );
      },
    );
  }

  void showHostConfirmationDialog(
    BuildContext context,
    String quizTitle,
    String quizId,
  ) {
    final controller = Get.find<HostDashboardController>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Host Quiz"),
        content: Text("Are you sure you want to host '$quizTitle'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors().black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.hostQuiz(quizTitle, quizId); // Pass quizId here
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
  Widget _buildCreateQuizTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildQuizTitleField(),
            SizedBox(height: 20),
            _buildAddQuestionButton(context),
            SizedBox(height: 10),
            Text("Questions Added: 0 "),
            SizedBox(height: 20),
            _buildSaveQuizButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTitleField() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors().white,
        hintText: "Quiz Title",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddQuestionButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
      onPressed: () => _showAddQuestionDialog(context),
      child: Text("Add Question", style: TextStyle(color: AppColors().black)),
    );
  }

  Widget _buildSaveQuizButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
      onPressed: () {},
      child: Text("Save Quiz", style: TextStyle(color: AppColors().black)),
    );
  }

  void _showAddQuestionDialog(BuildContext context) {
    final questionController = TextEditingController();
    final optionControllers = List.generate(4, (_) => TextEditingController());
    int correctIndex = 0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              DropdownButton<int>(
                value: correctIndex,
                items: List.generate(
                  4,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text("Correct Answer: Option ${i + 1}"),
                  ),
                ),
                onChanged: (val) {
                  if (val != null) {
                    correctIndex = val;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Add question logic will go here
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
