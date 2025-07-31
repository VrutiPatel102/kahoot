import 'package:flutter/material.dart';
import 'package:kahoot_app/app_route.dart';
import 'package:kahoot_app/login_screen.dart';
import 'package:kahoot_app/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.splashScreen:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
          settings: settings,
        );
      case AppRoute.splashScreen:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings,
        );
    }
  }
}
