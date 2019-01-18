import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(240, 70, 40, 1.0);
const highlightColor = Color.fromRGBO(237, 101, 47, 1.0);
const secondaryColor = Color.fromRGBO(46, 134, 171, 1.0);

final theme = ThemeData(
    brightness: Brightness.light,
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(20.0, 20.0))),
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary),
    splashColor: Colors.white,
    primaryColor: primaryColor,
    highlightColor: highlightColor,
    accentColor: secondaryColor,
    accentColorBrightness: Brightness.dark,
    iconTheme: IconThemeData(color: primaryColor),
    accentIconTheme: IconThemeData(color: Colors.white),
    fontFamily: 'Quicksand');
