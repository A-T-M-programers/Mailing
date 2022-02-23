import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn){
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemesApp{
  static final darkTheame = ThemeData(
    textTheme: TextTheme(headline1: TextStyle(color: Colors.white),headline2:TextStyle(color: Colors.white54) ),
    cardColor: Colors.grey.shade900,
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.grey.shade900,
    shadowColor: Colors.white12,
    colorScheme: ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    textTheme: TextTheme(headline1: TextStyle(color: Colors.black),headline2: TextStyle(color: Colors.black54)),
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    shadowColor: Colors.black12,
    colorScheme: ColorScheme.light(),
  );
}