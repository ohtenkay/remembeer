import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final FloatingActionButton? floatingActionButton;

  const PageTemplate({
    super.key,
    this.title,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              centerTitle: true,
              title: title,
            )
          : null,
      body: Padding(padding: const EdgeInsets.all(8.0), child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}
