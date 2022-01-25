import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:mpw/app/modules/help/views/help_view.dart';
import 'package:mpw/app/data/my_autocomplete.dart';
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
            onPressed: controller.clearAndSave,
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Get.to(HelpView());
            },
          ),
          // IconButton(onPressed: onPressed, icon: const Icon(Icons.remove_red_eye_outlined)),
          Obx(() => IconButton(
                onPressed: controller.changeRecordIcon,
                icon: controller.rxRecordIcon.value,
              )),

          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('import form clipboard'),
                  onTap: controller.importFormClipboard,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('save to clipboard'),
                  onTap: controller.saveToClipboard,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('import form qrcode'),
                  onTap: controller.importFormQrcode,
                ),
                PopupMenuItem(
                  // key: controller.popupMenuItemKey,
                  child: Text('save to qrcode'),
                  onTap: controller.saveToQrcode,
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
            MyAutocomplete(
                focusNode: controller.focusNode,
                textEditingController: controller.spasswordController,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return controller.sortList(textEditingValue.text);
                },
                onSelected: (String selection) {
                  Get.snackbar('Successfully', 'You just selected $selection',
                      snackPosition: SnackPosition.BOTTOM);
                  debugPrint('You just selected $selection');
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        labelText: "Site",
                        hintText: "站点主网址",
                        prefixIcon: Icon(Icons.web)),
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    // validator: (String? value) {
                    //   if (!controller.rxSiteList.contains(value)) {
                    //     return 'Nothing selected.';
                    //   }
                    //   return null;
                    // },
                  );
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options) {
                  return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: controller.optionSiteList.length,
                              itemBuilder: (context, index) {
                                return _item(
                                    context,
                                    index,
                                    controller.optionSiteList,
                                    onSelected,
                                    controller.removeItem);
                              },
                            ),
                          ),
                        ),
                      ));
                }),
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
                    onPressed: controller.genPassword,
                  )),
                ],
              ),
            ),
            Center(
              // margin: EdgeInsets.only(top: 100),
              child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            onPressed: controller.changeVisibleIcon,
                            icon: controller.rxVisibleIcon.value),
                        Text(
                          controller.rxShowSitePW.value,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: controller.copy,
                        )
                      ])),
            )
          ])),
    );
  }

  Widget _item(BuildContext ctx, int index, options, onSelected, removeItem) {
    return SwipeActionCell(
      // controller: controller2,
      index: index,

      // Required!
      key: ValueKey(options[index]),

      // key: ValueKey(controller.rxSiteList[index]),

      /// Animation default value below
      // normalAnimationDuration: 400,
      // deleteAnimationDuration: 400,
      selectedForegroundColor: Colors.black.withAlpha(30),
      trailingActions: [
        SwipeAction(
            title: "delete",
            widthSpace: 110,
            performsFirstActionWithFullSwipe: true,
            nestedAction: SwipeNestedAction(title: "confirm"),
            onTap: (handler) async {
              await handler(true);
              removeItem(index);
            }),
        // SwipeAction(
        //     title: "action2", color: Colors.grey, onTap: (handler) {}),
      ],
      // leadingActions: [
      //   SwipeAction(
      //       title: "delete",
      //       onTap: (handler) async {
      //         await handler(true);
      //         controller.rxSiteList.removeAt(index);
      //       }),
      //   SwipeAction(
      //       title: "action3", color: Colors.orange, onTap: (handler) {}),
      // ],
      child: GestureDetector(
        onTap: () {
          onSelected(options[index]);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(options[index], style: const TextStyle(fontSize: 25)),
        ),
      ),
    );
  }
}
