import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent {}
class ToggleTheme extends ThemeEvent {
  final bool isDark;
  ToggleTheme(this.isDark);
}
class LoadTheme extends ThemeEvent {}

// States
class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.light)) {
    on<LoadTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('is_dark_mode') ?? false;
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    });

    on<ToggleTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', event.isDark);
      emit(ThemeState(event.isDark ? ThemeMode.dark : ThemeMode.light));
    });
  }
}
