import 'package:flutter/material.dart';

enum LeaderboardIcon {
  trophy('trophy', Icons.emoji_events),
  medal('medal', Icons.military_tech),
  star('star', Icons.star),
  diamond('diamond', Icons.diamond),
  flame('flame', Icons.local_fire_department),
  bolt('bolt', Icons.bolt),
  rocket('rocket', Icons.rocket_launch),
  target('target', Icons.gps_fixed),
  beer('beer', Icons.sports_bar),
  wine('wine', Icons.wine_bar),
  cocktail('cocktail', Icons.local_bar),
  coffee('coffee', Icons.coffee),
  heart('heart', Icons.favorite),
  sad('sad', Icons.sentiment_very_dissatisfied),
  party('party', Icons.celebration),
  music('music', Icons.music_note),
  gamepad('gamepad', Icons.sports_esports),
  pet('pet', Icons.pets),
  nature('nature', Icons.eco),
  sun('sun', Icons.wb_sunny),
  moon('moon', Icons.nightlight_round),
  flag('flag', Icons.flag),
  shield('shield', Icons.shield),
  lightbulb('lightbulb', Icons.lightbulb);

  final String name;
  final IconData icon;

  const LeaderboardIcon(this.name, this.icon);

  static LeaderboardIcon fromName(String name) {
    return LeaderboardIcon.values.firstWhere(
      (e) => e.name == name,
      orElse: () => LeaderboardIcon.trophy,
    );
  }
}
