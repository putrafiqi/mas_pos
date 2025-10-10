import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  AppSnackBar({super.key, required this.message, this.isError = false})
    : super(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),

        backgroundColor: isError ? Colors.red : Colors.lightGreen,
      );
  final String message;
  final bool isError;
}
