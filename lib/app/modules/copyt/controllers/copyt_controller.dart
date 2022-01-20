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
  RxString rxSite = "".obs;
  final rxVisibleIcon = Icons.visibility.obs;
  RxBool rxVisible = true.obs;
  RxBool rxRecordable = true.obs;
  final rxRecordIcon = Icons.toggle_on.obs;

  // list store
  late RxList<String> rxSiteList;
  late RxList<String> rxOptionSiteList;
  late RxInt rxOptionSiteListLength;
  final String spiltFlag = "&*&*";
  // String s = "";

  final s = Spectre();
  @override
  void onInit() {
    super.onInit();
    // TODO:read the perfs
    rxSiteList = <String>[
      'aardvark',
      'bobcat',
      'chameleon',
    ].obs;
    rxOptionSiteList = <String>[''].obs;
    rxOptionSiteListLength = rxOptionSiteList.length.obs;
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

  void saveList(String userkey) {
    SharedPreferencesUtil.saveData(
        userkey, EncryptData.encryptAES(rxSiteList.join(spiltFlag)));
  }

  void readList(String userkey) {
    String temp = SharedPreferencesUtil.getData(userkey) as String;
    rxSiteList.value = EncryptData.decryptAES(temp).split(spiltFlag);
  }

  void suggestlist() {
    // TODO:两种触发：
    // 1. 点击右侧下拉键，按照文本内容搜索，文本为空时展示全部
    // 2. 输入文本时自动联想相关参数并显示
  }
  // autocomplate
  Iterable<String> sortList(String textEditingValue) {
    final sitelter = rxSiteList.where((String option) {
      return option.contains(textEditingValue.toLowerCase());
    });
    rxOptionSiteList.clear();
    rxOptionSiteList.addAll(sitelter);
    rxOptionSiteListLength.value = rxOptionSiteList.length;
    return sitelter;
  }

  void removeItem(int index) {
    rxSiteList.removeWhere((element) => element == rxOptionSiteList[index]);
    rxOptionSiteList.removeAt(index);
    rxOptionSiteListLength.value = rxOptionSiteListLength.value - 1;
  }
}
