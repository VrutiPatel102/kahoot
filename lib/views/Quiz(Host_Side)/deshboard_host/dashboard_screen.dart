import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:kahoot_app/constants/app.dart';
import 'package:kahoot_app/constants/app_colors.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/deshboard_host/dashboard_controller.dart';

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
    final quizzes = [
      {"title": "Funny Ques", "questions": List.filled(10, {})},
      {"title": "General Knowledge", "questions": List.filled(5, {})},
    ];

    if (quizzes.isEmpty) {
      return Center(child: Text("No quizzes found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Card(
          child: ListTile(
            title: Text(quiz["title"].toString()),
            subtitle: Text("${(quiz["questions"] as List).length} questions"),
            trailing: ElevatedButton(
              onPressed: () {
                showHostConfirmationDialog(context, quiz["title"].toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(),
              ),
              child: Text("Host", style: TextStyle(color: AppColors().white)),
            ),
          ),
        );
      },
    );
  }

  void showHostConfirmationDialog(BuildContext context, String quizTitle) {
    final controller = Get.find<HostDashboardController>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Host Quiz"),
        content: Text("Are you sure you want to host '$quizTitle'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors().black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.hostQuiz(quizTitle);
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
    return const TextField(
      decoration: InputDecoration(
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
