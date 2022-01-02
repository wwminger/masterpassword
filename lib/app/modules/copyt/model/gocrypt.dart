import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  ffi.Pointer<ffi.Int8> generate(
    ffi.Pointer<ffi.Int8> username,
    ffi.Pointer<ffi.Int8> password,
    ffi.Pointer<ffi.Int8> webname,
  ) {
    return _generate(
      username,
      password,
      webname,
    );
  }

  late final _generatePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Int8> Function(ffi.Pointer<ffi.Int8>,
              ffi.Pointer<ffi.Int8>, ffi.Pointer<ffi.Int8>)>>('generate');
  late final _generate = _generatePtr.asFunction<
      ffi.Pointer<ffi.Int8> Function(ffi.Pointer<ffi.Int8>,
          ffi.Pointer<ffi.Int8>, ffi.Pointer<ffi.Int8>)>();
}
