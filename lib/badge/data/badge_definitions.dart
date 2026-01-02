import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/model/badge_definition.dart';

const badgeDefinitions = <BadgeDefinition>[
  BadgeDefinition(
    id: 'centurion',
    name: 'Centurion',
    description: 'Drink 100 beers in total',
    iconPath: 'assets/badges/centurion.png',
    category: BadgeCategory.beersTotal,
    goal: 100,
  ),
  BadgeDefinition(
    id: 'millennial',
    name: 'Millennial',
    description: 'Drink 1000 beers in total',
    iconPath: 'assets/badges/millennial.png',
    category: BadgeCategory.beersTotal,
    goal: 1000,
  ),

  BadgeDefinition(
    id: 'alchemist',
    name: 'Alchemist',
    description: 'Drink 1 liter of alcohol',
    iconPath: 'assets/badges/alchemist.png',
    category: BadgeCategory.alcoholTotal,
    goal: 1000,
  ),
  BadgeDefinition(
    id: 'ethanol_engine',
    name: 'Ethanol Engine',
    description: 'Drink 10 liters of alcohol',
    iconPath: 'assets/badges/ethanol_engine.png',
    category: BadgeCategory.alcoholTotal,
    goal: 10000,
  ),

  BadgeDefinition(
    id: 'finding_the_rhythm',
    name: 'Finding the Rhythm',
    description: 'Achieve 3-day streak',
    iconPath: 'assets/badges/finding_the_rhythm.png',
    category: BadgeCategory.streak,
    goal: 3,
  ),
  BadgeDefinition(
    id: 'habit_formed',
    name: 'Habit Formed',
    description: 'Achieve 7-day streak',
    iconPath: 'assets/badges/habit_formed.png',
    category: BadgeCategory.streak,
    goal: 7,
  ),

  BadgeDefinition(
    id: 'night_animal',
    name: 'Night animal',
    description: 'Have 10+ beers after 6 pm',
    iconPath: 'assets/badges/night_animal.png',
    category: BadgeCategory.onetimeEvent,
  ),
  BadgeDefinition(
    id: 'you_remembeered',
    name: 'You remembeered',
    description: 'Log drink 5+ days after drinking it',
    iconPath: 'assets/badges/you_remembeered.png',
    category: BadgeCategory.onetimeEvent,
  ),
  BadgeDefinition(
    id: 'early_riser',
    name: 'Early riser',
    description: 'Have a beer between 6 am and 8 am',
    iconPath: 'assets/badges/early_riser.png',
    category: BadgeCategory.onetimeEvent,
  ),
];
