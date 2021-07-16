import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> themeVal = new ValueNotifier(true); //dark mode switch
ValueNotifier<Brightness> bright = new ValueNotifier(Brightness.light); //
bool switchVal;
Color bodyColor = Color(0x34343434),
    boxColor = Color(0x33333333),
    textColor = Colors.white,
    mainColor = Colors.blueGrey,
    shadowColor = Color(0x00000000),
    greyColor = Color(0x66666666),
    blackColor = Color(0x11111111);
String mood = "dark";
void dark() {
  bodyColor = Color(0x34343434);
  boxColor = Color(0x33333333);
  textColor = Colors.white;
  mainColor = Colors.blueGrey;
  shadowColor = Color(0x00000000);
}

void light() {
  bodyColor = Color(0xeeeeeeee);
  boxColor = Colors.white;
  textColor = Colors.black;
  mainColor = Colors.blueGrey;
  shadowColor = Colors.grey;
}

void theme() {
  if (switchVal == true) {
    dark();
  } else {
    light();
  }
}

SharedPreferences prefs;
void saveTheme(bool val) async {
  prefs = await SharedPreferences.getInstance();
  prefs.setBool("mood", switchVal);
  switchVal = val;
}

getTheme() async {
  prefs = await SharedPreferences.getInstance();
  switchVal = prefs.getBool("mood");
  return switchVal;
}

bool Portrait(MediaQueryData media) {
  Orientation orientation = media.orientation;
  return orientation == Orientation.portrait ? true : false;
}

int userId = 0;
void saveUserId(int val) async {
  prefs = await SharedPreferences.getInstance();
  prefs.setInt("UserId", val);
  userId = val;
}

Future<int> getUserId() async {
  prefs = await SharedPreferences.getInstance();
  userId = await prefs.getInt("UserId");
  return userId;
}

void saveThemeH(bool val) async {
  prefs = await SharedPreferences.getInstance();
  prefs.setBool("switchVal", val);
  themeVal.value = val;
  bright.value = val ? Brightness.dark : Brightness.light;
  themeVal.notifyListeners();
  bright.notifyListeners();
}

getThemeH() async {
  prefs = await SharedPreferences.getInstance();
  themeVal.value = prefs.getBool("switchVal");
  bright.value =prefs.getBool("switchVal")!=null ?
     ( prefs.getBool("switchVal")?Brightness.dark : Brightness.light):Brightness.dark;
  await themeVal.notifyListeners();
  await bright.notifyListeners();
}
