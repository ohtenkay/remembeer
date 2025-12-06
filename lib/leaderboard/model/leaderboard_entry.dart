import 'package:remembeer/user/model/user_model.dart';

class LeaderboardEntry {
  final UserModel user;
  final double beersConsumed;
  final double alcoholConsumedMl;
  final int rankByBeers;
  final int rankByAlcohol;

  const LeaderboardEntry({
    required this.user,
    required this.beersConsumed,
    required this.alcoholConsumedMl,
    required this.rankByBeers,
    required this.rankByAlcohol,
  });
}
