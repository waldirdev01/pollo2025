import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Icon? leading;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: leading,
      title: Text(title ?? ''),
      backgroundColor: AppUiConfig.themeCustom.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
