import 'package:flutter/material.dart';

class AsyncBuilder<T> extends StatelessWidget {
  final Stream<T>? stream;
  final Future<T>? future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context) waitingBuilder;
  final Widget Function(BuildContext context, Object error) errorBuilder;

  const AsyncBuilder({
    super.key,
    this.stream,
    this.future,
    required this.builder,
    this.waitingBuilder = _defaultWaitingBuilder,
    this.errorBuilder = _defaultErrorBuilder,
  }) : assert(
         (stream == null) ^ (future == null),
         'Provide exactly one of `stream` or `future`.',
       );

  static Widget _defaultWaitingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget _defaultErrorBuilder(BuildContext context, Object error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _handleSnapshot(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) {
      return errorBuilder(context, snapshot.error!);
    }

    if (!snapshot.hasData) {
      return waitingBuilder(context);
    }

    // ignore: null_check_on_nullable_type_parameter
    return builder(context, snapshot.data!);
  }

  @override
  Widget build(BuildContext context) {
    if (stream != null) {
      return StreamBuilder<T>(stream: stream, builder: _handleSnapshot);
    }

    return FutureBuilder<T>(future: future, builder: _handleSnapshot);
  }
}
