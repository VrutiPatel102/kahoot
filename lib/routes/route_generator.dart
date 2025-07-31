import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kahoot_app/views/Home/home_binding.dart';
import 'package:kahoot_app/views/Home/home_screen.dart';
import 'package:kahoot_app/views/create_quiz/create_binding.dart';
import 'package:kahoot_app/views/create_quiz/create_quiz.dart';
import 'package:kahoot_app/views/join_quiz/join_binding.dart';
import 'package:kahoot_app/views/join_quiz/join_quiz.dart';
import 'package:kahoot_app/views/splash/splash_binding.dart';
import 'package:kahoot_app/views/splash/splash_screen.dart';

class AppPages {


  static final routes = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBindings()),
    GetPage(
      name: '/createQuiz',
      page: () => CreateQuiz(),
      binding: CreateBinding(),
    ),
    GetPage(name: '/joinQuiz', page: () => JoinQuiz(), binding: JoinBinding()),
  ];
}
