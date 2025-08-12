import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreboardView extends StatelessWidget {
  final List<int> selectedAnswers; // User selected indexes for each question
  final List<List<String>> options; // All options per question

  ScoreboardView({
    required this.selectedAnswers,
    required this.options,
    super.key,
  });

  static const optionSymbols = ['▲', '◆', '●', '■'];
  static const optionColors = [
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Scoreboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: selectedAnswers.length,
        itemBuilder: (context, index) {
          int selected = selectedAnswers[index];
          String answer = options[index][selected];
          Color color = optionColors[selected];
          String symbol = optionSymbols[selected];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    symbol,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
