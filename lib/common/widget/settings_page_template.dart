import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

const _fabBottomOffset = 40.0;

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
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return PageTemplate(
      title: title,
      padding: padding,
      floatingActionButton: onFabPressed != null
          ? Padding(
              padding: EdgeInsets.only(
                bottom: keyboardOpen ? 0 : _fabBottomOffset,
              ),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: onFabPressed,
                child: Icon(fabIcon),
              ),
            )
          : null,
      child: child,
    );
  }
}
