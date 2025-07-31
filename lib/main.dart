import 'package:flutter/material.dart';
import 'package:kahoot_app/app_route.dart';
import 'package:kahoot_app/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoute.splashScreen,
      onGenerateRoute:RouteGenerator.routeGenerate,
    );
  }
}

