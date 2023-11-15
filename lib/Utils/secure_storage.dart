import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart'as enc;
import 'package:shared_preferences/shared_preferences.dart';
class SecureStorage{
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  writeSecureData(String key, String value)async{

    if(Platform.isIOS){
      SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString(key, value);
    }
    else{
      await storage.write(key: key, value: value);
    }

  }

  readSecureData(String key)async{

    if(Platform.isIOS){
      SharedPreferences prefs = await SharedPreferences.getInstance();
       return prefs.getString(key);
    }else{
      String? value = await storage.read(key: key);
      print('Data read from secure storage:$value');
      return value;
    }

  }
 /* deleteAll()async{
    print("DDDDD");
    await storage.deleteAll();
    print("KKKKKKKKKKK");

  }*/
  final String _secretKey = "STRACE@1234SAKTHIATHISOURCETRACE";
  encryptAES(String plainText) {
    final key =enc. Key.fromUtf8(_secretKey);
    enc.IV iv =enc. IV.fromLength(16);
    final encrypt =enc. Encrypter(enc.AES(key,mode: enc.AESMode.cbc),);
      var en= encrypt.encrypt(plainText, iv: iv);
    return en.base64;
  }

  decryptAES(String encryptedValue ) {
    final key =enc. Key.fromUtf8(_secretKey);
    final iv =enc. IV.fromLength(16);
    final encrypt =enc. Encrypter(enc.AES(key,mode: enc.AESMode.cbc));
    return   encrypt.decrypt(enc.Encrypted.fromBase64(encryptedValue), iv: iv);

  }
}