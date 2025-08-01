import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/Home/home_binding.dart';
import 'package:kahoot_app/views/Home/home_screen.dart';
import 'package:kahoot_app/views/create_quiz/create_binding.dart';
import 'package:kahoot_app/views/create_quiz/create_quiz.dart';
import 'package:kahoot_app/views/enter_name/enterName_binding.dart';
import 'package:kahoot_app/views/enter_name/enterName_screen.dart';
import 'package:kahoot_app/views/enter_pin/enterPin_binding.dart';
import 'package:kahoot_app/views/enter_pin/enter_pin.dart';
import 'package:kahoot_app/views/splash/splash_binding.dart';
import 'package:kahoot_app/views/splash/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoute.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoute.home,
      page: () => HomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoute.createQuiz,
      page: () => CreateQuiz(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: AppRoute.enterPin,
      page: () => EnterPin(),
      binding: EnterPinBinding(),
    ),
    GetPage(
      name: AppRoute.enterNickName,
      page: () => NicknameScreen(),
      binding: NickNameBinding(),
    ),
  ];
}
