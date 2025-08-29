import 'package:get/get.dart';

class FinalRankController extends GetxController {
  final players = <Player>[
    Player(name: 'Jeel', score: 1453),
    Player(name: 'Varun', score: 1253),
    Player(name: 'Roshan', score: 1000),
  ].obs;
}

class Player {
  final String name;
  final int score;
  Player({required this.name, required this.score});
}
