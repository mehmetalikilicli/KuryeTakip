import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWidgets {
  InputDecoration dropdownDecoration(Color borderColor, Color errorBorderColor, String hint, IconData iconData, Color iconColor) {
    return InputDecoration(
      isCollapsed: true,
      errorStyle: const TextStyle(color: CupertinoColors.systemRed),
      contentPadding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
      border: _inputBorder(borderColor, 0.5, 8),
      enabledBorder: _inputBorder(borderColor, 0.5, 8),
      focusedBorder: _inputBorder(borderColor, 1, 8),
      errorBorder: _inputBorder(borderColor, 0.5, 8),
      focusedErrorBorder: _inputBorder(borderColor, 1, 8),
      hintText: hint,
      prefixIcon: Icon(iconData, color: iconColor),
    );
  }

  InputDecoration timeDecoration(Color borderColor, Color errorBorderColor, String hint) {
    return InputDecoration(
      isCollapsed: true,
      errorStyle: const TextStyle(color: CupertinoColors.systemRed, fontSize: 10),
      contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      border: _inputBorder(borderColor, 0.5, 8),
      enabledBorder: _inputBorder(borderColor, 0.5, 8),
      focusedBorder: _inputBorder(borderColor, 1, 8),
      errorBorder: _inputBorder(borderColor, 0.5, 8),
      focusedErrorBorder: _inputBorder(borderColor, 1, 8),
      //hintText: hint,
      // constraints: const BoxConstraints(minHeight: 30, maxHeight: 30),
    );
  }

  InputDecoration dateDecoration(Color borderColor, Color errorBorderColor, String hint) {
    return InputDecoration(
      isCollapsed: true,
      errorStyle: const TextStyle(color: CupertinoColors.systemRed, fontSize: 10),
      contentPadding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
      border: _inputBorder(borderColor, 0.5, 8),
      enabledBorder: _inputBorder(borderColor, 0.5, 8),
      focusedBorder: _inputBorder(borderColor, 1, 8),
      errorBorder: _inputBorder(borderColor, 0.5, 8),
      focusedErrorBorder: _inputBorder(borderColor, 1, 8),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12),
      // constraints: const BoxConstraints(minHeight: 30, maxHeight: 30),
    );
  }

  InputDecoration noteDecoration(Color borderColor, Color errorBorderColor, String hint) {
    return InputDecoration(
      isCollapsed: true,
      errorStyle: const TextStyle(color: CupertinoColors.systemRed, fontSize: 10),
      contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      border: _inputBorder(borderColor, 0.5, 8),
      enabledBorder: _inputBorder(borderColor, 0.5, 8),
      focusedBorder: _inputBorder(borderColor, 1, 8),
      errorBorder: _inputBorder(borderColor, 0.5, 8),
      focusedErrorBorder: _inputBorder(borderColor, 1, 8),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14),
      filled: true,
      //isDense: true,
      // constraints: const BoxConstraints(minHeight: 30, maxHeight: 30),
    );
  }

  InputBorder _inputBorder(Color color, double width, double radius) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: color, width: width));
  }
}
