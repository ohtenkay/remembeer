import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';

class LeaderboardController extends Controller<Leaderboard, LeaderboardCreate> {
  LeaderboardController({required super.authService})
    : super(collectionPath: 'leaderboards', fromJson: Leaderboard.fromJson);

  Stream<List<Leaderboard>> get myLeaderboardsStream {
    return readCollection
        .where(deletedAtField, isNull: true)
        .where('memberIds', arrayContains: authService.authenticatedUser.uid)
        .snapshots()
        .map(
          (querySnapshot) => List.unmodifiable(
            querySnapshot.docs
                .map((docSnapshot) => docSnapshot.data())
                .toList(),
          ),
        );
  }

  Future<Leaderboard> findById(String id) async {
    final doc = await readCollection.doc(id).get();
    final data = doc.data();
    if (data == null || data.deletedAt != null) {
      throw StateError('Leaderboard with id $id not found.');
    }
    return data;
  }

  Future<Leaderboard?> findByInviteCode(String inviteCode) async {
    final snapshot = await readCollection
        .where(deletedAtField, isNull: true)
        .where('inviteCode', isEqualTo: inviteCode)
        .get();

    if (snapshot.docs.length > 1) {
      throw StateError(
        'Found ${snapshot.docs.length} leaderboards with invite code $inviteCode. Expected at most 1.',
      );
    }

    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }
}
