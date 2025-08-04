import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kahoot_app/views/register/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
