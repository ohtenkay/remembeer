import 'package:flutter/material.dart';

class LoadingStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;

  const LoadingStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO(metju-ac): Show a propper error widget not revealing internals.
          return Center(child: Text('Error: ${snapshot.error!}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // ignore: null_check_on_nullable_type_parameter
        return builder(context, snapshot.data!);
      },
    );
  }
}
