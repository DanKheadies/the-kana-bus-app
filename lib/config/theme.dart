import 'package:flutter/material.dart';

ThemeData lightTheme() {
  // return ThemeData.light().copyWith();
  return darkTheme();
}

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: textWhite),
      backgroundColor: deepPurple,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: backgroundBlack),
    colorScheme: const ColorScheme.dark().copyWith(
      brightness: Brightness.dark,
      primary: kanaColor,
      secondary: romajiColor,
      tertiary: englishColor,
      surface: textGrey,
      surfaceBright: textWhite,
      surfaceContainer: backgroundBlack,
      surfaceContainerHigh: backgroundBlacker,
      error: errorColor,
    ),
    dialogTheme: DialogThemeData(backgroundColor: backgroundBlacker),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: actionBlue,
    ),
    iconTheme: const IconThemeData(color: textWhite),
    // iconButtonTheme: IconButtonThemeData(
    //   style: IconButton.styleFrom(foregroundColor: textWhite),
    // ),
    primaryColor: actionBlue,
    scaffoldBackgroundColor: backgroundBlacker,
    snackBarTheme: SnackBarThemeData(
      actionTextColor: actionBlue,
      backgroundColor: backgroundBlack,
      contentTextStyle: TextStyle(color: textGrey),
    ),
  );
}

const actionBlue = Color(0xFF7cacf8);
const backgroundBlack = Color(0xFF212121);
const backgroundBlacker = Color(0xFF121212);
const deepPurple = Colors.deepPurple;
const englishColor = Color(0xFFff9003);
const errorColor = Color(0xFFff897d);
const kanaColor = Color(0xFFb87cf8);
const romajiColor = Color(0xFF7cf8c6);
const textGrey = Color(0xFFa6a6a6);
const textWhite = Color(0xFFe8e8e8);
