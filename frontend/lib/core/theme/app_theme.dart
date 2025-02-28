import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_text_theme.dart';

class AppTheme {
  static get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Montserrat',
        textTheme: AppTextTheme.montSerrat,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 5, color: AppColors.primary),
          ),
          hintStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w400,
          ),
          hintFadeDuration: const Duration(microseconds: 1),
          filled: true,
          fillColor: AppColors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.black,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.teal,
            minimumSize: Size(double.infinity, 55),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: AppColors.primary, width: 5),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.teal,
            minimumSize: Size(double.infinity, 55),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.black,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.primary)),
            iconColor: AppColors.primary,
            foregroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 55),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.primary,
          contentTextStyle: AppTextTheme.montSerrat.bodyMedium!
              .copyWith(color: AppColors.teal),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.teal, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}
