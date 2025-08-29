import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowNickNameController extends GetxController {
  late String fullName;
  late String initial;
  late String quizId;
  late String userId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    fullName = args['nickname'] ?? args['fullName'] ?? '';
    userId = args['userId'] ?? '';
    initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    quizId = args['quizId'] ?? '';

    _listenForQuizStart();
  }

  void _listenForQuizStart() {
    _firestore.collection('quizzes').doc(quizId).snapshots().listen((doc) {
      if (!doc.exists) return;

      final data = doc.data() ?? {};
      final quizStarted =
          data['status'] == 'started' || data['quizStarted'] == true;

      if (quizStarted) {
        Get.toNamed(
          AppRoute.getReadyLoading,
          arguments: {
            'quizId': quizId,
            'userId': userId,
            'nickname': fullName,
            'initial': initial,
          },
        );
      }
    });
  }
}
