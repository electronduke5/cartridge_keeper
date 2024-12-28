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
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: isSuccess
          ? const Color(0xFF00B69B).withValues(alpha: 0.5)
          : const Color(0xFFEF3826).withValues(alpha: 0.5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
