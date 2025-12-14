import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/session/model/session.dart';

class DrinkListData {
  final List<Drink> drinks;
  final List<Session> sessions;

  const DrinkListData({required this.drinks, required this.sessions});
}
