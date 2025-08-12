import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kahoot_app/routes/app_route.dart';
import 'package:kahoot_app/views/Home/home_binding.dart';
import 'package:kahoot_app/views/Home/home_screen.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/countdown_host/countdown_binding.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/deshboard_host/dashboard_binding.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/deshboard_host/dashboard_screen.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/loading_pinGenerate/loading_pin.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/loading_pinGenerate/loading_pin_binding.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/que_view/que_view_binding.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/quiz_lobby_screen/quiz_lobby_bindings.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/quiz_lobby_screen/quiz_lobby_screen.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/scoreboard_view/scoreboard_binding.dart';
import 'package:kahoot_app/views/Quiz(Host_Side)/scoreboard_view/scoreboard_view.dart';
import 'package:kahoot_app/views/create_quiz/create_binding.dart';
import 'package:kahoot_app/views/create_quiz/create_quiz.dart';
import 'package:kahoot_app/views/enter_name/enterName_binding.dart';
import 'package:kahoot_app/views/enter_name/enterName_screen.dart';
import 'package:kahoot_app/views/enter_pin/enterPin_binding.dart';
import 'package:kahoot_app/views/enter_pin/enter_pin.dart';
import 'package:kahoot_app/views/login/login_binding.dart';
import 'package:kahoot_app/views/login/login_screen.dart';

// import 'package:kahoot_app/views/rank_screen/rank_binding.dart';
// import 'package:kahoot_app/views/rank_screen/rank_screen.dart';
import 'package:kahoot_app/views/register/register_binding.dart';
import 'package:kahoot_app/views/register/register_screen.dart';
import 'package:kahoot_app/views/get_ready_loading/get_ready_loading.dart';
import 'package:kahoot_app/views/get_ready_loading/get_ready_loading_binding.dart';
import 'package:kahoot_app/views/que_loading/que_loading.dart';
import 'package:kahoot_app/views/que_loading/que_loading_binding.dart';
import 'package:kahoot_app/views/score_status/score_status_binding.dart';
import 'package:kahoot_app/views/score_status/score_status_screen.dart';
import 'package:kahoot_app/views/show_nickname/show_nickname.dart';
import 'package:kahoot_app/views/show_nickname/show_nickname_binding.dart';
import 'package:kahoot_app/views/show_option/show_option.dart';
import 'package:kahoot_app/views/show_option/show_option_binding.dart';
import 'package:kahoot_app/views/splash/splash_binding.dart';
import 'package:kahoot_app/views/splash/splash_screen.dart';
import 'package:kahoot_app/views/user_rank/user_rank_binding.dart';
import 'package:kahoot_app/views/user_rank/user_rank_screen.dart';

import '../views/Quiz(Host_Side)/countdown_host/count_down_screen.dart'
    show CountdownView;

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
    GetPage(
      name: AppRoute.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoute.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoute.showNickName,
      page: () => ShowNicknameScreen(),
      binding: ShowNickNameBinding(),
    ),
    GetPage(
      name: AppRoute.getReadyLoading,
      page: () => GetReadyLoadingScreen(),
      binding: GetReadyLoadingBinding(),
    ),
    GetPage(
      name: AppRoute.queLoading,
      page: () => QueLoadingScreen(),
      binding: QueLoadingBinding(),
    ),
    GetPage(
      name: AppRoute.showOption,
      page: () => ShowOptionScreen(),
      binding: ShowOptionBinding(),
    ),
    GetPage(
      name: AppRoute.scoreStatus,
      page: () => ScoreStatusScreen(),
      binding: ScoreStatusBinding(),
    ),
    GetPage(
      name: AppRoute.userRank,
      page: () => UserRankScreen(),
      binding: UserRankBinding(),
    ),
    GetPage(
      name: AppRoute.dashboardHostSide,
      page: () => HostDashboardView(),
      binding: HostDashboardBinding(),
    ),
    GetPage(
      name: AppRoute.loadingHostSide,
      page: () => LoadingPinScreen(),
      binding: LoadingPinBindings(),
    ),
    GetPage(
      name: AppRoute.quizLobbyScreen,
      page: () => QuizLobbyView(),
      binding: QuizLobbyBinding(),
    ),
    GetPage(
      name: AppRoute.countdownScreen,
      page: () => CountdownView(),
      binding: CountdownBinding(),
    ),
    GetPage(
      name: AppRoute.queScreen,
      page: () => QuizQuestionView(),
      binding: QueViewBinding(),
    ),
    GetPage(
      name: AppRoute.scoreboardScreen,
      page: () => ScoreboardView(),
      binding: ScoreboardBinding(),
    ),
  ];
}
