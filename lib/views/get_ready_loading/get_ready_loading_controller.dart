// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:get/get.dart';
// // import 'package:kahoot_app/routes/app_route.dart';
// //
// // class GetReadyLoadingController extends GetxController {
// //   late String quizId;
// //
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     final args = Get.arguments ?? {};
// //     quizId = args["quizId"] ?? "";
// //
// //     print('GetReadyLoadingController initialized with quizId: $quizId');
// //
// //     // 🔹 Listen to Firestore instead of fixed delay
// //     _listenForCountdownEnd();
// //   }
// //
// //   void _listenForCountdownEnd() {
// //     _firestore.collection('quizzes').doc(quizId).snapshots().listen((doc) {
// //       if (doc.exists && doc.data()?['status'] == 'question') {
// //         // 🔹 Navigate only when host finishes countdown
// //         print('Navigating to ShowOption...');
// //         Get.offNamed(
// //           AppRoute.showOption,
// //           arguments: {
// //             "quizId": quizId,
// //             "userId": FirebaseAuth.instance.currentUser?.uid, // 🔹 add this
// //           },
// //         );
// //       }
// //     });
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:kahoot_app/routes/app_route.dart';
//
// class GetReadyLoadingController extends GetxController {
//   late String quizId;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Get quizId from navigation arguments
//     quizId = Get.arguments?["quizId"] ?? "";
//
//     if (quizId.isNotEmpty) {
//       _listenForCountdownEnd();
//     } else {
//       Get.snackbar("Error", "❌ Quiz ID is missing");
//     }
//   }
//
//   void _listenForCountdownEnd() {
//     _firestore.collection('quizzes').doc(quizId).snapshots().listen((
//       doc,
//     ) async {
//       if (!doc.exists) return;
//
//       final data = doc.data();
//       if (data == null) return;
//
//       // Wait for host to change status
//       final status = data['status'] ?? '';
//       final currentQuestionIndex = data['currentQuestionIndex'] ?? 0;
//
//       if (status == 'question') {
//         // Fetch questions in order by ID (q0, q1, q2...)
//         final query = await _firestore
//             .collection('quizzes')
//             .doc(quizId)
//             .collection('questions')
//             .orderBy(FieldPath.documentId)
//             .get();
//
//         if (query.docs.length > currentQuestionIndex) {
//           final questionDoc = query.docs[currentQuestionIndex];
//           final questionId =
//               questionDoc.id; // 👈 actual Firestore docId (q0,q1,q2)
//
//           // Navigate to ShowOption screen
//           Get.offNamed(
//             AppRoute.showOption,
//             arguments: {
//               "quizId": quizId,
//               "userId": FirebaseAuth.instance.currentUser?.uid,
//               "questionId": questionId, // ✅ no longer missing
//             },
//           );
//         } else {
//           Get.snackbar("Error", "❌ Question index out of range");
//         }
//       }
//     });
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/app_route.dart';

class GetReadyLoadingController extends GetxController {
  late String quizId;
  late String userId;
  late String nickname;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    quizId = args["quizId"] ?? "";
    userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    nickname = args["nickname"] ?? "Guest";

    if (quizId.isEmpty || userId.isEmpty) {
      Get.snackbar("Error", "❌ Quiz ID or User ID missing");
      return;
    }

    _listenForHostCountdownEnd();
  }

  /// Wait for host to finish countdown
  void _listenForHostCountdownEnd() {
    _subscription = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;

          final data = doc.data();
          if (data == null) return;

          final status = data['quizStage'] ?? '';
          final currentQuestionIndex = data['currentQuestionIndex'] ?? 0;

          if (status == 'question') {
            // Navigate to first ShowOption
            final query = await FirebaseFirestore.instance
                .collection('quizzes')
                .doc(quizId)
                .collection('questions')
                .orderBy(FieldPath.documentId)
                .get();

            if (query.docs.length > currentQuestionIndex) {
              final questionId = query.docs[currentQuestionIndex].id;

              Get.offNamed(
                AppRoute.showOption,
                arguments: {
                  "quizId": quizId,
                  "userId": userId,
                  "nickname": nickname,
                  "questionId": questionId,
                },
              );

              await _subscription?.cancel();
            }
          }
        });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
