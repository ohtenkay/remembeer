import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BeerIcon extends StatelessWidget {
  final Color? color;
  final double size;

  const BeerIcon({
    super.key,
    this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/beer.svg',
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
