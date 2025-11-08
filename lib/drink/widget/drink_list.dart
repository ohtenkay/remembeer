import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/loading_stream_builder.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/widget/drink_tile.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkList extends StatelessWidget {
  DrinkList({super.key});

  final _drinkController = get<DrinkController>();

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder(
      stream: _drinkController.entitiesStream,
      builder: (context, drinks) {
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (_, _) => Divider(),
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              return DrinkTile(drink: drink);
            },
          ),
        );
      },
    );
  }
}
