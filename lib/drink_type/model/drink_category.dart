import 'package:flutter/material.dart';

enum DrinkCategory {
  Beer,
  Cider,
  Cocktail,
  Spirit,
  Wine,
}

extension DrinkCategoryExtension on DrinkCategory {
  String get displayName {
    return switch (this) {
      DrinkCategory.Beer => 'Beer',
      DrinkCategory.Cider => 'Cider',
      DrinkCategory.Cocktail => 'Cocktail',
      DrinkCategory.Spirit => 'Spirit',
      DrinkCategory.Wine => 'Wine',
    };
  }

  String get iconPath {
    return switch (this) {
      DrinkCategory.Beer => 'assets/icons/beer.svg',
      DrinkCategory.Cider => 'assets/icons/cider.svg',
      DrinkCategory.Cocktail => 'assets/icons/cocktail.svg',
      DrinkCategory.Spirit => 'assets/icons/spirit.svg',
      DrinkCategory.Wine => 'assets/icons/wine.svg',
    };
  }

  Color get defaultColor {
    return switch (this) {
      DrinkCategory.Beer => const Color(0xFFD1A700),
      DrinkCategory.Cider => const Color(0xFFFFEA00),
      DrinkCategory.Cocktail => const Color(0xFF19D808),
      DrinkCategory.Spirit => const Color(0xFF0080FF),
      DrinkCategory.Wine => const Color(0xFFC0392B),
    };
  }
}
