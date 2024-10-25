import 'package:flutter/material.dart';

class SnackBarInfo {
  SnackBarInfo.show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: isSuccess ? const Color(0xFF00B69B) : const Color(0xFFEF3826),
        ),
      ),
      backgroundColor: isSuccess
          ? const Color(0xFF00B69B).withOpacity(0.1)
          : const Color(0xFFEF3826).withOpacity(0.1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
