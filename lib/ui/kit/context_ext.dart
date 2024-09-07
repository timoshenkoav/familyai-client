import 'package:familyai/l10n/cb_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSnackError({String? message}) {
    final locale = CbLocale.of(this)!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(message??locale.unexpected_error),
      ));
    });
  }
  void showDialogError({String? message}) {
    final locale = CbLocale.of(this)!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(context: this, builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(25),
          actionsPadding: EdgeInsets.zero,
          content: Text(
            message ?? locale.unexpected_error,
            style: const TextStyle(
                color: Colors.black
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(this).pop();
            }, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: const Text("OK"),
            ))
          ],
        );
      },);
    });
  }
}