import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class GetReadyLoadingController extends GetxController {
  late String quizId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";

    print('GetReadyLoadingController initialized with quizId: $quizId');

    // 🔹 Listen to Firestore instead of fixed delay
    _listenForCountdownEnd();
  }

  void _listenForCountdownEnd() {
    _firestore.collection('quizzes').doc(quizId).snapshots().listen((doc) {
      if (doc.exists && doc.data()?['status'] == 'question') {
        // 🔹 Navigate only when host finishes countdown
        print('Navigating to ShowOption...');
        Get.offNamed(
          AppRoute.showOption,
          arguments: {
            "quizId": quizId,
            "userId": FirebaseAuth.instance.currentUser?.uid, // 🔹 add this
          },
        );
      }
    });
  }
}
