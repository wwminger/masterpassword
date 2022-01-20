import 'package:encrypt/encrypt.dart';

class EncryptData {
//for AES Algorithms

  static String encryptAES(plainText) {
    Encrypted? encrypted;
    final key = Key.fromUtf8('my 32 length key.....wmdd.......');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    // print(encrypted!.base64);
    return encrypted.base64;
  }

  static String decryptAES(String plainText) {
    final key = Key.fromUtf8('my 32 length key.....wmdd.......');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    String decrypted = encrypter.decrypt64(plainText, iv: iv);
    print(decrypted);
    return decrypted;
  }
}
