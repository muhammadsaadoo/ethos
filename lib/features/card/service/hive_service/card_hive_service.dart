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
}
