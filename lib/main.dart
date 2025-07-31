import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/routes/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute:'/splash',
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
