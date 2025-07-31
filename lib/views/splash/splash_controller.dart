import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController{
  @override
   void onInit()
   {
     super.onInit();
     Future.delayed(Duration(seconds: 3),() {
       // print("Navigating to home...");
       Get.offAllNamed('/home');
     },);
   }
}