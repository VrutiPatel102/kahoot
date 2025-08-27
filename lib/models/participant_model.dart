import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  final String id;
  final String nickname;
  final int score;
  final int answerStreak;
  final int lastEarnedPoints;
  final bool isCorrectAnswer;

  Participant({
    required this.id,
    required this.nickname,
    required this.score,
    required this.answerStreak,
    required this.lastEarnedPoints,
    required this.isCorrectAnswer,
  });

  factory Participant.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Participant(
      id: doc.id,
      nickname: data["nickname"] ?? "",
      score: data["score"] ?? 0,
      answerStreak: data["answerStreak"] ?? 0,
      lastEarnedPoints: data["lastEarnedPoints"] ?? 0,
      isCorrectAnswer: data["isCorrect"] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nickname": nickname,
      "score": score,
      "answerStreak": answerStreak,
      "lastEarnedPoints": lastEarnedPoints,
      "isCorrect": isCorrectAnswer,
    };
  }
}
