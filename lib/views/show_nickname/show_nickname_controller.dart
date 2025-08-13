import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_app/routes/app_route.dart';

class ShowNickNameController extends GetxController {
  late String fullName;
  late String initial;
  late String quizId; // The quiz document ID
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late RxString quizStatus;

  @override
  void onInit() {
    super.onInit();

    // Get the full name and quizId from previous screen arguments
    fullName = Get.arguments['fullName'] ?? '';
    quizId = Get.arguments['quizId'] ?? '';

    // Extract the first alphabet (uppercase)
    initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    // Listen for quiz status updates from Firestore
    _listenForQuizStart();
  }

  void _listenForQuizStart() {
    if (quizId.isEmpty) {
      Get.snackbar("Error", "Invalid quiz ID");
      return;
    }

    _firestore.collection('quizzes').doc(quizId).snapshots().listen((doc) {
      if (!doc.exists) return;

      final status = doc.data()?['status'] ?? 'waiting';
      if (status == 'started') {
        // Navigate to next screen immediately when host starts quiz
        Get.toNamed(
          AppRoute.getReadyLoading,
          arguments: {'fullName': fullName, 'initial': initial},
        );
      }
    });
  }
}
