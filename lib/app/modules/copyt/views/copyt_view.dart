import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mpw/app/modules/help/views/help_view.dart';

import '../controllers/copyt_controller.dart';

class CopytView extends GetView<CopytController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: const Icon(Icons.account_balance),
        title: const Text("主密码"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.onClose,
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Get.to(HelpView());
            },
          ),
          // IconButton(onPressed: onPressed, icon: const Icon(Icons.remove_red_eye_outlined)),
          IconButton(
              onPressed: controller.changeRecordIcon,
              icon: Obx(() => Icon(controller.rxRecordIcon.value))),

          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('import form clipboard'),
                  onTap: controller.changeText,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('save to clipboard'),
                  onTap: controller.changeText,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('import form qrcode'),
                  onTap: controller.changeText,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('save to qrcode'),
                  onTap: controller.changeText,
                ),
              ];
            },
          )
        ],
      ),
      body: Form(
          key: controller.copytFormKey,
          child: Column(children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: controller.userController,
              decoration: InputDecoration(
                labelText: "UserName",
                hintText: "用户名",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              autofocus: true,
              controller: controller.mpasswordController,
              decoration: InputDecoration(
                  labelText: "MasterKey",
                  hintText: "主密码",
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            TextFormField(
              autofocus: true,
              controller: controller.spasswordController,
              decoration: InputDecoration(
                  labelText: "Site",
                  hintText: "站点主网址",
                  prefixIcon: Icon(Icons.web)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("GEN"),
                    ),
                    onPressed: controller.changeText,
                  )),
                ],
              ),
            ),
            Center(
              // margin: EdgeInsets.only(top: 100),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: controller.changeVisibleIcon,
                        icon: Obx(() => Icon(controller.rxVisibleIcon.value))),
                    Obx(() => Text(
                          controller.rxShowSitePW.value,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        )),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: controller.copy,
                    )
                  ]),
            )
          ])),
    );
  }
}
