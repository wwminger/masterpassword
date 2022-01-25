import 'package:get/get.dart';

import '../modules/copyt/bindings/copyt_binding.dart';
import '../modules/copyt/views/copyt_view.dart';
import '../modules/help/bindings/help_binding.dart';
import '../modules/help/views/help_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.COPYT;

  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: _Paths.COPYT,
      page: () => CopytView(),
      binding: CopytBinding(),
    ),
    GetPage(
      name: _Paths.HELP,
      page: () => HelpView(),
      binding: HelpBinding(),
    ),
  ];
}
