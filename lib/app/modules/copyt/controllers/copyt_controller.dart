import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mpw/app/data/gocrypt_wrapper.dart';
import 'package:mpw/app/data/shared_preferences_util.dart';
import 'package:mpw/app/data/encrypt_data.dart';

class CopytController extends GetxController {
  // final popupMenuItemKey = GlobalKey<PopupMenuItemState>();
  final copytFormKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final mpasswordController = TextEditingController();
  final spasswordController = TextEditingController();
  RxString rxShowSitePW = "ggsmd".obs;
  RxString rxSitePW = "ggsmd".obs;

  final rxVisibleIcon = Icons.visibility.obs;
  RxBool rxVisible = true.obs;
  RxBool rxRecordable = true.obs;
  final rxRecordIcon = Icons.toggle_on.obs;

  // list store
  late RxList<String> rxSiteList;
  final String spiltFlag = "&*&*";
  // String s = "";

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
    userController.text = "";
    userController.dispose();
    mpasswordController.text = "";
    mpasswordController.dispose();
    spasswordController.text = "";
    spasswordController.dispose();
    rxSitePW.value = "ggsmd";
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: rxSitePW.value));
  }

  void changeText() {
    if (true) {
      rxSitePW.value = s.genpassword(userController.text,
          mpasswordController.text, spasswordController.text);
      visibleText();
    }
  }

  void visibleText() {
    int strlenght = 0;
    String left = "";
    if (rxVisible.value) {
      rxShowSitePW.value = rxSitePW.value;
    } else {
      strlenght = rxSitePW.value.length;
      for (var i = 0; i < strlenght; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
        left = left + '*';
      }
      rxShowSitePW.value = left;
    }
  }

  void changeVisibleIcon() {
    rxVisible.value = !(rxVisible.value);

    if (rxVisible.value) {
      rxVisibleIcon.value = Icons.visibility;
    } else {
      rxVisibleIcon.value = Icons.visibility_off;
    }
    visibleText();
  }

  void changeRecordIcon() {
    rxRecordable.value = !rxRecordable.value;

    if (rxRecordable.value) {
      rxRecordIcon.value = Icons.toggle_on;
    } else {
      rxRecordIcon.value = Icons.toggle_off;
    }
  }

  void savelist(String userkey) {
    SharedPreferencesUtil.saveData(
        userkey, EncryptData.encryptAES(rxSiteList.value.join(spiltFlag)));
  }

  void readlist(String userkey) {
    String temp = SharedPreferencesUtil.getData(userkey) as String;
    rxSiteList.value = EncryptData.decryptAES(temp).split(spiltFlag);
  }
}
