import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> showMessage({
    BuildContext? context,
    String? title,
    String? message,
    String? positiveButtonText,
    Function? onPositiveButtonPressed,
    String? negativeButtonText,
    Function? onNegativeButtonPressed,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: message != null ? Text(message) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onNegativeButtonPressed != null) {
                  onNegativeButtonPressed();
                }
              },
              child: Text(negativeButtonText ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPositiveButtonPressed != null) {
                  onPositiveButtonPressed();
                }
              },
              child: Text(positiveButtonText ?? 'OK'),
            ),
          ],
        );
      },
    );
  }
}
