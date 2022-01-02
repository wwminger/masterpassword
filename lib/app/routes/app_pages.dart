import 'package:get/get.dart';

import 'package:mpw/app/modules/copyt/bindings/copyt_binding.dart';
import 'package:mpw/app/modules/copyt/views/copyt_view.dart';
import 'package:mpw/app/modules/home/bindings/home_binding.dart';
import 'package:mpw/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.COPYT;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.COPYT,
      page: () => CopytView(),
      binding: CopytBinding(),
    ),
  ];
}
