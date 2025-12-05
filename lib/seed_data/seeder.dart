import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

Future<void> seedDatabase() async {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference drinkTypeCollection = firestore.collection(
    'drink_types',
  );
  final batch = firestore.batch();

  final content = await rootBundle.loadString(
    'assets/seed_data/drink_types.json',
  );
  final List<dynamic> drinkTypesJson = jsonDecode(content);

  for (final drinkTypeJson in drinkTypesJson) {
    final drinkType = DrinkType.fromJson(drinkTypeJson as Map<String, dynamic>);
    final docRef = drinkTypeCollection.doc(drinkType.id);

    batch.set(docRef, drinkType.toJson().withServerCreateTimestamps());
  }

  await batch.commit();
}
