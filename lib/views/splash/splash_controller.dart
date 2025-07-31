import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController{
   void onInit()
   {
     Future.delayed(Duration(seconds: 3),() {
       Get.offAllNamed('/home');
     },);
   }
}