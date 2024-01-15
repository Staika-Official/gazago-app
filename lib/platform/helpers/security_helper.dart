import 'package:encrypt/encrypt.dart';

String encrypt(String secretKey, String email, String password) {
  String base64 = Key.fromUtf8(password + email).base64;

  Map<String, String> map = _getAlgorithm(base64);

  Key key = Key.fromUtf8(map['key']!);
  IV iv = IV.fromUtf8(map['iv']!);
  // Encrypted encrypted = Encrypter(AES(key, mode: AESMode.ctr, padding: "PKCS7")).encryptBytes(Key.fromUtf8(secretKey).bytes, iv: iv);
  Encrypted encrypted = Encrypter(AES(key)).encrypt(secretKey, iv: iv);
  return encrypted.base64;
}

String? decrypt(String wrappedKey, String email, String password) {
  String base64 = Key.fromUtf8(password + email).base64;
  print('base64 : $base64');
  Map<String, String> map = _getAlgorithm(base64);
  print('map : $map');
  Key key = Key.fromUtf8(map['key']!);
  IV iv = IV.fromUtf8(map['iv']!);

  Encrypted encrypted = Encrypted.fromBase64(wrappedKey);
  try {
    String decrypt = Encrypter(AES(key)).decrypt(encrypted, iv: iv);
    // String decrypt = Encrypter(AES(key, mode: AESMode.ctr, padding: "PKCS7")).decrypt64(wrappedKey, iv: iv);
    return decrypt;
  } catch (e) {
    return null;
  }
}

Map<String, String> _getAlgorithm(String base64) {
  late String keyStr;
  late String ivStr;

  if (base64.length < 32) {
    StringBuffer sb = StringBuffer();
    bool isPassword = true;
    while (true) {
      sb.write(base64);
      if (sb.length > 32) {
        keyStr = sb.toString().substring(0, 32);
        break;
      }
      isPassword = !isPassword;
    }
  } else {
    keyStr = base64.substring(0, 32);
  }
  ivStr = base64.substring(base64.length - 16, base64.length);

  return {'key': keyStr, 'iv': ivStr};
}

RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$');
