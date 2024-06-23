import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkMode=ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme:const FloatingActionButtonThemeData(foregroundColor: Colors.white,backgroundColor: Colors.deepOrange) ,
  scaffoldBackgroundColor: HexColor('#393939'),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: HexColor('#393939'),
        statusBarIconBrightness: Brightness.light
    ),
    titleTextStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,),
    surfaceTintColor: HexColor('#393939'),
    elevation: 0,
    backgroundColor: HexColor('#393939'),
    actionsIconTheme: const IconThemeData(color: Colors.white),
  ),
) ;

ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme:const FloatingActionButtonThemeData(foregroundColor: Colors.white,backgroundColor: Colors.blueAccent) ,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark
    ),
    titleTextStyle: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold,),
    surfaceTintColor: Colors.white,
    elevation: 0,
    backgroundColor: Colors.white,
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
);