import 'package:encrypt/encrypt.dart';
import 'package:pass_key/src/core/services/env_service.dart';

class EncryptionService {
  static final _key = Key.fromUtf8(EnvService.encryptionKey);
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc, padding: 'PKCS7'));

  static String encryptText(String plainText) {
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptText(String encryptedWithIv) {
    final parts = encryptedWithIv.split(':');
    if (parts.length != 2) return '';

    final iv = IV.fromBase64(parts[0]);
    final encrypted = parts[1];

    return _encrypter.decrypt64(encrypted, iv: iv);
  }
}
