import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'package:markdown/markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        centerTitle: true,
      ),
      body: FlutterMarkdown(),
    );
  }
}

class FlutterMarkdown extends StatelessWidget {
  const FlutterMarkdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: rootBundle.loadString('doc/help.md'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.data);
          } else {
            return Center(
              child: Text("加载中..."),
            );
          }
        },
      ),
    );
  }
}
