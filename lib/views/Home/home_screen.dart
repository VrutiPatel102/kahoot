import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/views/Home/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: _buildBody());
  }

  AppBar _buildAppbar() {
    return AppBar(title: const Text("HomeScreen"));
  }

  Widget _buildBody() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.onJoinQuiz();
            },
            child: Text("Join Quiz"),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              controller.onCreateQuiz();
            },
            child: Text("Create Quiz"),
          ),
        ],
      ),
    );
  }
}
