import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyLocalStorage {
  final storage = FlutterSecureStorage();

  //Store Data object
  void storeObject(Map<String, dynamic> object) async {
    final jsonString = jsonEncode(object);
    await storage.write(key: 'userData', value: jsonString);
  }

  //Get Store Object
  Future<Map<String, dynamic>?> getObject() async {
    final jsonString = await storage.read(key: 'userData');
    if (jsonString != null) {
      final object = jsonDecode(jsonString) as Map<String, dynamic>;
      return object;
    }
    return null;
  }
}
