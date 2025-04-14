import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';




final ThemeData redTheme = ThemeData(
  primaryColor: primary,
  //const Color.fromARGB(255, 180, 132, 129), // Primary color
  colorScheme:  ColorScheme.light(
    primary: primary,
    //Color.fromARGB(255, 180, 132, 129), // Primary color
    secondary: Colors.redAccent, // Accent color
  ),
  scaffoldBackgroundColor: Colors.white, // Background color
  appBarTheme: const AppBarTheme(
    color: Colors.amber,
    //Color.fromARGB(255, 172, 62, 54), // AppBar color
    titleTextStyle: TextStyle(
      color: Colors.black, // AppBar text color
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  buttonTheme:  ButtonThemeData(
    buttonColor: buttonColor,

    //Color.fromARGB(255, 172, 62, 54), // Button color
    textTheme:ButtonTextTheme.normal,
  ),
);
