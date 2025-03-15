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
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkNavy,
          foregroundColor: AppColors.teal,
          shadowColor: AppColors.darkNavy,
          elevation: 0,
        ),
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
              side: BorderSide(color: AppColors.darkNavy, width: 5),
            ),
            backgroundColor: AppColors.darkNavy,
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
              side: BorderSide(color: AppColors.teal),
            ),
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
        navigationBarTheme: NavigationBarThemeData(
            // height: 70,
            shadowColor: AppColors.teal,
            iconTheme: WidgetStatePropertyAll(
              IconThemeData(
                color: AppColors.teal,
                size: 25,
              ),
            ),
            elevation: 2,
            backgroundColor: AppColors.darkNavy,
            indicatorShape:
                CircleBorder(side: BorderSide(color: AppColors.teal)),
            indicatorColor: AppColors.teal.withValues(alpha: 0.0),
            labelTextStyle: WidgetStatePropertyAll(
              AppTextTheme.montSerrat.bodyMedium!.copyWith(
                color: AppColors.teal,
              ),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected),
      );
}
