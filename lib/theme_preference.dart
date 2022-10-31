
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum PreferencesValues {
  darkMode,
  material3,
  colorSeed,
}


class ThemePreferences {

  static const defaultValues = {
    PreferencesValues.darkMode: false,
    PreferencesValues.material3: true,
    PreferencesValues.colorSeed: 0xff6750a4,
  };

  setThemeValue<T>(PreferencesValues prefVal, T newVal) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (newVal.runtimeType) {
      case String:
        preferences.setString(prefVal.name, newVal as String);
        break;
      case int:
        preferences.setInt(prefVal.name, newVal as int);
        break;
      case bool:
        preferences.setBool(prefVal.name, newVal as bool);
        break;
    }
  }

  getThemeValue<T>(PreferencesValues prefVal) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var defaultValue = defaultValues[prefVal];
    switch (defaultValue.runtimeType) {
      case String:
        return preferences.getString(prefVal.name) ?? defaultValue as String;
      case int:
        return preferences.getInt(prefVal.name) ?? defaultValue as int;
      case bool:
        return preferences.getBool(prefVal.name) ?? defaultValue as bool;
      case ThemeMode:
        return preferences.getString(prefVal.name) ?? (defaultValue as ThemeMode).name;
    }
  }
}

class ThemeProvider extends ChangeNotifier {
  final ThemePreferences _preferences = ThemePreferences();
  bool _isDark = ThemePreferences.defaultValues[PreferencesValues.darkMode] as bool;
  bool _isMaterial3 = ThemePreferences.defaultValues[PreferencesValues.material3] as bool;

  bool get isMaterial3 => _isMaterial3;
  bool get isDark => _isDark;

  ThemeProvider() {
    initPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setThemeValue(PreferencesValues.darkMode, value);
    notifyListeners();
  }

  set isMaterial3(bool value) {
    _isMaterial3 = value;
    _preferences.setThemeValue(PreferencesValues.material3, value);
    notifyListeners();
  }

  initPreferences() async {
    _isDark = await _preferences.getThemeValue(PreferencesValues.darkMode);
    _isMaterial3 = await _preferences.getThemeValue(PreferencesValues.material3);
    notifyListeners();
  }
}