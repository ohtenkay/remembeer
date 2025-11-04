import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

mixin DrinkFields {
  late String userId;
  late DateTime consumedAt;
  late DrinkType drinkType;
  late double volumeInMilliliters;
  GeoPoint? location;
}
