import 'gocrypt.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Directory, Platform;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

class Spectre {
  late NativeLibrary cs;
  Spectre() {
    String libraryPath =
        path.join(Directory.current.path, 'lib', 'libspectre.so');
    if (Platform.isAndroid) {
      libraryPath = path.join('libspectre.so');
    } else if (Platform.isWindows) {
      libraryPath = path.join('gocrypt.dll');
    }
    final dynamicLibrary = ffi.DynamicLibrary.open(libraryPath);
    cs = NativeLibrary(dynamicLibrary);
  }
  String genpassword(String userName, String userSecret, String siteName) {
    final userNameInt8 = userName.toNativeUtf8().cast<ffi.Int8>();

    final userSecretInt8 = userSecret.toNativeUtf8().cast<ffi.Int8>();

    final siteNameInt8 = siteName.toNativeUtf8().cast<ffi.Int8>();

    final spectrestr = cs
        .generate(userNameInt8, userSecretInt8, siteNameInt8)
        .cast<Utf8>()
        .toDartString();
    return spectrestr;
  }
}
