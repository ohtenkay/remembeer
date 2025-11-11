import 'package:flutter/material.dart';

// NOTE: This could be extended to support Future as well.
class AsyncBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context) waitingBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const AsyncBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.waitingBuilder = _defaultWaitingBuilder,
    this.errorBuilder = _defaultErrorBuilder,
  });

  static Widget _defaultWaitingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget _defaultErrorBuilder(BuildContext context, Object error) {
    return Center(child: Text('Error: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // ignore: null_check_on_nullable_type_parameter
          return errorBuilder(context, snapshot.error!);
        }

        if (!snapshot.hasData) {
          return waitingBuilder(context);
        }

        // ignore: null_check_on_nullable_type_parameter
        return builder(context, snapshot.data!);
      },
    );
  }
}
