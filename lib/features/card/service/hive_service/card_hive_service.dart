import 'package:expence_management/core/constants/hive_boxes.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:hive/hive.dart';

// import '../../../core/constants/hive_boxes.dart';
// import '../../models/card_model.dart';

class CardHiveService {
  final Box<CardModel> box = Hive.box<CardModel>(HiveBoxes.cards);

  Future<void> addCard(CardModel card) async {
    await box.put(card.id, card);
  }

  List<CardModel> getCards(String userId) {
    return box.values.where((e) => e.userId == userId).toList();
  }

  Future<void> updateCard(CardModel card) async {
    await box.put(card.id, card);
  }

  List<CardModel> getUnsyncedCards() {
    return box.values.where((e) => e.isSynced == false).toList();
  }

  Future<void> clearAll() async {
    await box.clear();
  }

  Future<void> deleteCard(String cardId) async {
    await box.delete(cardId);
  }

  // Future<void> deleteTransactionsByCard(String cardId) async {
  //   final keysToDelete = box.values
  //       .where((tx) => tx.cardId == cardId)
  //       .map((tx) => tx.id)
  //       .toList();

  //   for (final id in keysToDelete) {
  //     await box.delete(id);
  //   }
  // }

  Stream<List<CardModel>> watchCards(String userId) async* {
    // Emit current state first so UI isn't blank on start
    yield box.values.where((e) => e.userId == userId).toList();

    yield* box.watch().map((_) {
      return box.values.where((e) => e.userId == userId).toList();
    });
  }
}
