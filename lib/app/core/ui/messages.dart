import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';

class Messages {
  final BuildContext context;
  Messages._(this.context);
  factory Messages.of(BuildContext context) => Messages._(context);

  void showError(String message) {
    _showMessager(message, Colors.red);
  }

  void showInfo(String message) {
    _showMessager(message, AppUiConfig.themeCustom.primaryColor);
  }

  void _showMessager(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
