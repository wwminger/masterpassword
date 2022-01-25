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
  final FocusNode focusNode = FocusNode();

  final Color colorON = Colors.blueAccent;
  final colorOFF = Colors.grey;
  RxString rxShowSitePW = "ggsmd".obs;
  RxString rxSitePW = "ggsmd".obs;

  //默认密码可见
  bool flagVisible = true;
  late Rx<Icon> rxVisibleIcon; //= Icon(Icons.visibility, color: colorON).obs;
  //默认开启site记录
  bool flagRecordable = true;
  late Rx<Icon> rxRecordIcon;
  // final rxRecordIconColor = Colors.red[100].obs;

  // list store
  late List<String> siteList;
  late List<String> optionSiteList;
  // late RxInt rxOptionSiteListLength;
  final String spiltFlag = "&*&*";

  // String s = "";
  String userkey = "owner";
  final s = Spectre();
  @override
  void onInit() {
    super.onInit();

    rxVisibleIcon = Icon(Icons.visibility, color: colorON).obs;
    rxRecordIcon = Icon(
      Icons.toggle_on,
      color: colorON,
    ).obs;
    siteList = <String>[];
    // read the perfs
    readList(userkey, siteList);

    optionSiteList = <String>[];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    saveList(userkey);
    userController.text = "";
    userController.dispose();
    mpasswordController.text = "";
    mpasswordController.dispose();
    spasswordController.text = "";
    spasswordController.dispose();
    rxSitePW.value = "ggsmd";
  }

  void clearAndSave() {
    saveList(userkey);
    userController.text = "";
    mpasswordController.text = "";
    spasswordController.text = "";
    rxSitePW.value = "ggsmd";
    siteList.clear();
    readList(userkey, siteList);
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: rxSitePW.value));
  }

  void genPassword() {
    if (true) {
      rxSitePW.value = s.genpassword(userController.text,
          mpasswordController.text, spasswordController.text);
      visibleText();

      addList(siteList, spasswordController.text);
    }
  }

  void addList(List<String> listA, String value) {
    if (flagRecordable) {
      if (!listA.contains(value)) {
        siteList.add(value);
        debugPrint("add the SiteList and the lengh now is ${siteList.length}");
      }
    }
  }

  void visibleText() {
    int strlenght = 0;
    String left = "";
    if (flagVisible) {
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
    flagVisible = !(flagVisible);

    if (flagVisible) {
      rxVisibleIcon.value = Icon(
        Icons.visibility,
        color: colorON,
      );
    } else {
      rxVisibleIcon.value = Icon(Icons.visibility_off);
    }
    visibleText();
  }

  void changeRecordIcon() {
    flagRecordable = !flagRecordable;

    if (flagRecordable) {
      rxRecordIcon.value = Icon(
        Icons.toggle_on,
        color: colorON,
      );
      // rxRecordIconColor.value = ;
    } else {
      rxRecordIcon.value = Icon(Icons.toggle_off, color: colorOFF);
    }
  }

  void saveList(String userkey) {
    if (siteList.isNotEmpty || !(siteList.length == 1 && siteList[0] != "")) {
      SharedPreferencesUtil.saveData(
          userkey, EncryptData.encryptAES(siteList.join(spiltFlag)));
    }
  }

  void readList(String userkey, List<String> ListA) {
    try {
      SharedPreferencesUtil.getData<String>(userkey).then((String result) {
        List<String> x = EncryptData.decryptAES(result).split(spiltFlag);
        ListA.addAll(x);
      });
    } catch (e) {
      debugPrint("read error");
    }
  }

  void importFormClipboard() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      //这里是一个剪贴板对象，调用data.text就是文本，其他的内容各位自行查看
      print(data);
      List<String> x = EncryptData.decryptAES(data.text ?? "").split(spiltFlag);
      siteList.clear();
      siteList.addAll(x);
      Get.snackbar('Ok', 'import from clipboard!');
    } else {
      Get.snackbar('Sorry', 'Get nothing from clipboard!');
    }
  }

  void saveToClipboard() {
    Clipboard.setData(
        ClipboardData(text: EncryptData.encryptAES(siteList.join(spiltFlag))));
    Get.snackbar('Ok', 'copy to clipboard!');
  }

  void importFormQrcode() {
    Get.snackbar('Sorry', 'developing!');
  }

  void saveToQrcode() {
    Get.snackbar('Sorry', 'developing!');
  }

  // autocomplate
  Iterable<String> sortList(String textEditingValue) {
    final sitelter = siteList.where((String option) {
      return option.contains(textEditingValue.toLowerCase());
    });
    optionSiteList.clear();
    optionSiteList.addAll(sitelter);
    optionSiteList.sort();
    // rxOptionSiteListLength.value = rxOptionSiteList.length;
    debugPrint("the options length is ${optionSiteList.length}");
    return sitelter;
  }

  void removeItem(int index) {
    siteList.removeWhere((element) => element == optionSiteList[index]);
    optionSiteList.removeAt(index);
    // rxOptionSiteListLength.value = rxOptionSiteListLength.value - 1;
    // debugPrint("The rxOptionSiteListLength is $rxOptionSiteListLength");
    debugPrint("The rxOptionSiteList length2 is ${optionSiteList.length}");
    debugPrint("The SiteList length2 is ${siteList.length}");

    // update();
  }
}
