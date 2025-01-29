import 'package:flutter/material.dart';

class AppUiConfig {
  AppUiConfig._();
  static ThemeData get themeCustom => ThemeData(
        primaryColor: const Color.fromARGB(255, 111, 94, 203),
        primaryColorLight: const Color.fromARGB(255, 178, 182, 205),
        elevatedButtonTheme: buttonThemCustom(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 111, 94, 203),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  static ElevatedButtonThemeData buttonThemCustom() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromARGB(255, 95, 113, 214),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 241, 242, 240),
          ),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ButtonStyle? get elevatedButtonThemeCustom => ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(themeCustom.primaryColor),
        textStyle: WidgetStateProperty.all<TextStyle>(buttonText),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static TextStyle get buttonText => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static IconThemeData iconThemeCustom() {
    return const IconThemeData(
      color: Color.fromARGB(255, 241, 242, 240),
    );
  }

  static SnackBarThemeData snackBarThemeCustom() {
    return SnackBarThemeData(
      backgroundColor: themeCustom.primaryColor,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

getColorByAbsences(int absences) {
  if (absences < 10) {
    return Colors.white;
  } else if (absences >= 10 && absences < 15) {
    return Colors.yellow;
  } else if (absences >= 15 && absences < 20) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
