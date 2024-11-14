import 'package:flutter/material.dart';

// login theme
const primaryColor = Color(0xFFFFA726); // Orange color
const backgroundColor = Colors.white;

final headingTextStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final subheadingTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.grey[600],
);

final inputTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

final buttonTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

// ! Common color
const Color commonDivierClr = Color(0xFFBDBDBD);
const Color blueClr = Color.fromARGB(255, 4, 92, 255);

// ! Color for Light Theme

const Color whiteClr = Colors.white;
const Color lightGrayCustom = Color(0xFFF5F5F5);

// ! Color for dark Theme
const Color darkgreyAllClr = Color(0xFF121212);
// const Color darkIconClr = Color(0xFFE0E0E0);
const Color darkgreyTextfieldClr = Color(0xFF1E1E1E);

class MyTheme {
  static final light = ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: whiteClr,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteClr),
      datePickerTheme: const DatePickerThemeData(
        todayBackgroundColor: WidgetStatePropertyAll(blueClr),
        todayForegroundColor: WidgetStatePropertyAll(whiteClr),
        rangeSelectionOverlayColor: WidgetStatePropertyAll(blueClr),
        headerBackgroundColor: blueClr,
        headerForegroundColor: whiteClr,
        backgroundColor: whiteClr,
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(blueClr),
        ),
        cancelButtonStyle:
            ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: whiteClr,
        dayPeriodTextColor: blueClr,
        dayPeriodColor: lightGrayCustom,
        hourMinuteTextColor: darkgreyAllClr,
        hourMinuteColor: lightGrayCustom,
        entryModeIconColor: blueClr,
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(blueClr),
        ),
        cancelButtonStyle:
            ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.black)),
        dialTextColor: darkgreyAllClr,
        dialBackgroundColor: lightGrayCustom,
        dialHandColor: blueClr,
        dialTextStyle: TextStyle(color: Colors.black),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: blueClr,
      scaffoldBackgroundColor: whiteClr);
  // ! Dark Theme Configurations
  // themeMode:ThemeMode.system,
  static final dark = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkgreyAllClr,
      iconTheme: IconThemeData(color: whiteClr),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: darkgreyAllClr),
    // checkboxTheme: CheckboxThemeData(
    //     shape: CircleBorder(side: BorderSide(color: Colors.white))),
    datePickerTheme: const DatePickerThemeData(
      todayBackgroundColor: WidgetStatePropertyAll(blueClr),
      todayForegroundColor: WidgetStatePropertyAll(whiteClr),
      rangeSelectionOverlayColor: WidgetStatePropertyAll(blueClr),
      headerBackgroundColor: blueClr,
      headerForegroundColor: whiteClr,
      backgroundColor: darkgreyTextfieldClr,
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(blueClr),
      ),
      cancelButtonStyle:
          ButtonStyle(foregroundColor: WidgetStatePropertyAll(whiteClr)),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: darkgreyAllClr,
      dayPeriodTextColor: blueClr,
      dayPeriodColor: darkgreyTextfieldClr,
      hourMinuteTextColor: whiteClr,
      hourMinuteColor: darkgreyTextfieldClr,
      entryModeIconColor: blueClr,
      timeSelectorSeparatorColor: WidgetStatePropertyAll(blueClr),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(blueClr),
      ),
      cancelButtonStyle:
          ButtonStyle(foregroundColor: WidgetStatePropertyAll(whiteClr)),
      dialTextColor: whiteClr,
      dialBackgroundColor: darkgreyTextfieldClr,
      dialHandColor: blueClr,
      dialTextStyle: TextStyle(color: Colors.black),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkgreyAllClr,
  );
}