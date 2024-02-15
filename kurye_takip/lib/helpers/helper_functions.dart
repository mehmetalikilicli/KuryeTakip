import 'package:flutter/material.dart';

class HelpFunctions {
  static void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
