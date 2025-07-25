import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class CryptoUtils {
  static const String _aesKey = 'EtJs~2*)C</nSTc]s:Tta8Qe,cCdec!k';

  /// Descifra el texto cifrado en AES/CBC/PKCS5Padding sin IV explícito
  static String decryptAES(String encryptedBase64) {
    try {
      // Clave de 32 bytes (256 bits)
      final key = encrypt.Key.fromUtf8(_aesKey);

      // IV de 16 bytes en cero
      final iv = encrypt.IV(Uint8List(16));

      // Cipher AES CBC PKCS5Padding
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      // Decodificar Base64
      final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);

      // Desencriptar
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      // Limpiar basura antes/después del JSON
      final start = decrypted.indexOf('{');
      final end = decrypted.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        return decrypted.substring(start, end + 1);
      }

      throw const FormatException('❌ No se encontró un JSON válido en el texto descifrado');
    } catch (e) {
      throw FormatException('❌ Error al descifrar: $e');
    }
  }
}
