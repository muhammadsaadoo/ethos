// import '../../core/network/network_service.dart';
// import '../models/card_model.dart';
// import '../services/firestore/card_firestore_service.dart';
// import '../services/hive/card_hive_service.dart';

import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/service/firestore_service/card_firestore_service.dart';
import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';

class CardRepository {
  final CardHiveService hiveService;
  final CardFirestoreService firestoreService;

  CardRepository({required this.hiveService, required this.firestoreService});

  Future<void> addCard(CardModel card) async {
    await hiveService.addCard(card);

    if (await NetworkService.isConnected()) {
      final syncedCard = card.copyWith(isSynced: true);

      await firestoreService.addCard(syncedCard);

      await hiveService.updateCard(syncedCard);
    }
  }

  Future<List<CardModel>> getCards(String userId) async {
    if (await NetworkService.isConnected()) {
      final firestoreCards = await firestoreService.getCards(userId);

      for (final card in firestoreCards) {
        await hiveService.updateCard(card);
      }

      return firestoreCards;
    }

    return hiveService.getCards(userId);
  }

  Future<void> syncPendingCards() async {
    if (!await NetworkService.isConnected()) {
      return;
    }

    final unsyncedCards = hiveService.getUnsyncedCards();

    for (final card in unsyncedCards) {
      final syncedCard = card.copyWith(isSynced: true);

      await firestoreService.addCard(syncedCard);

      await hiveService.updateCard(syncedCard);
    }
  }
}
