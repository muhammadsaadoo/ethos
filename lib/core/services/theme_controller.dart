import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxService {
  static const String _themeKey = 'isDarkMode';
  late SharedPreferences _prefs;
  final RxBool isDarkMode = false.obs;

  Future<ThemeController> init() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkMode.value = _prefs.getBool(_themeKey) ?? false;
    return this;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await _prefs.setBool(_themeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
