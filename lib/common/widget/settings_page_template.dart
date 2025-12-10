import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SettingsPageTemplate extends StatelessWidget {
  final Widget title;
  final Widget child;
  final VoidCallback? onFabPressed;
  final IconData fabIcon;
  final EdgeInsetsGeometry padding;

  const SettingsPageTemplate({
    super.key,
    required this.title,
    required this.child,
    this.onFabPressed,
    this.fabIcon = Icons.save,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: title,
      padding: padding,
      floatingActionButton: onFabPressed != null
          ? FloatingActionButton(
              heroTag: null,
              onPressed: onFabPressed,
              child: Icon(fabIcon),
            )
          : null,
      child: child,
    );
  }
}
