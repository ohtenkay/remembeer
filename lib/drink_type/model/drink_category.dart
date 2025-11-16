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

  Map<String, int> get predefinedVolumes {
    return switch (this) {
      DrinkCategory.Beer => {
        'Tuplák': 1000,
        'Big': 500,
        'Small': 300,
      },
      DrinkCategory.Cider => {
        'Big': 500,
        'Small': 300,
      },
      DrinkCategory.Cocktail => {
        'Short Drink': 250,
        'Long Drink': 400,
      },
      DrinkCategory.Spirit => {
        'Shot': 40,
        'Small shot': 20,
      },
      DrinkCategory.Wine => {
        'Glass': 200,
        'Bottle': 750,
      },
    };
  }
}
