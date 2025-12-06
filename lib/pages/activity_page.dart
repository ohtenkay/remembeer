import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

// TODO(metju-ac): move to proper location
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(child: Center(child: Text('Activity Page')));
  }
}
