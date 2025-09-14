import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final Box settingsBox;

  ThemeCubit(this.settingsBox)
      : super(ThemeInitial(
    settingsBox.get('isDarkMode', defaultValue: false) ? ThemeMode.dark : ThemeMode.light,
  ));

  void toggleTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeChanged(newTheme));
    settingsBox.put('isDarkMode', !isDark);
  }
}
