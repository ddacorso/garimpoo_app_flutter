import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageShared {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  Future delete(String key) async {
    instance.remove(key);
  }

  Future getBool(String key) async {
    instance.getBool(key);
  }

  Future getString(String key) async {
    instance.getString(key);
  }

  Future putBool(String key, bool value) async {
    instance.setBool(key, value);
  }

  Future putString(String key, String value) async {
    instance.setString(key, value);
  }

  Future clear() async {
    instance.clear();
  }

  Future getAll() async {
    instance.getKeys();
  }
}
