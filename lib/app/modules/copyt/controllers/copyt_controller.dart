import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../model/gocrypt_wrapper.dart';

class CopytController extends GetxController {
  final copytFormKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final mpasswordController = TextEditingController();
  final spasswordController = TextEditingController();
  final RxString sitepw = "ggsmd".obs;
  final s = Spectre();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    userController.dispose();
    mpasswordController.dispose();
    spasswordController.dispose();
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: sitepw.value));
  }

  void changeText() {
    if (true) {
      sitepw.value = s.genpassword(userController.text,
          mpasswordController.text, spasswordController.text);
    }
  }
}
