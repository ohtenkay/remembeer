class UserStats {
  final double totalBeersConsumed;
  final double totalAlcoholConsumed;
  final double beersConsumedLast30Days;
  final double alcoholConsumedLast30Days;
  final int streakDays;
  final bool isStreakActive;

  const UserStats({
    required this.totalBeersConsumed,
    required this.totalAlcoholConsumed,
    required this.beersConsumedLast30Days,
    required this.alcoholConsumedLast30Days,
    required this.streakDays,
    required this.isStreakActive,
  });
}
