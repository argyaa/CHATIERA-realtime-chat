import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  final pref = GetStorage();
  final _storageKey = 'isDarkMode';

  void getThemeMode() {
    isSavedDarkMode() ? emit(true) : emit(false);
  }

  bool isSavedDarkMode() {
    return pref.read(_storageKey) ?? false;
  }

  void changeThemeMode() {
    isSavedDarkMode() ? emit(true) : emit(false);
  }
}
