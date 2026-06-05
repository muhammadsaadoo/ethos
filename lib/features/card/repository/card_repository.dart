// import '../../core/network/network_service.dart';
// import '../models/card_model.dart';
// import '../services/firestore/card_firestore_service.dart';
// import '../services/hive/card_hive_service.dart';

import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/service/firestore_service/card_firestore_service.dart';
import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';
import 'package:expence_management/features/transaction/service/transaction_hive_service.dart';

class CardRepository {
  final CardHiveService hiveService;
  final CardFirestoreService firestoreService;
  final TransactionHiveService transactionHiveService;

  CardRepository({
    required this.hiveService,
    required this.firestoreService,
    required this.transactionHiveService,
  });

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

  Future<void> updateTotalAmount({
    required String cardId,
    required String userId,
    required double newAmount,
  }) async {
    final card = hiveService.getCards(userId).firstWhere((c) => c.id == cardId);

    final updatedCard = card.copyWith(totalAmount: newAmount);

    await hiveService.updateCard(updatedCard);

    if (await NetworkService.isConnected()) {
      await firestoreService.updateCard(updatedCard);
    }
  }

  Future<void> deleteCard({
    required String userId,
    required String cardId,
  }) async {
    // 1. delete card locally
    await hiveService.deleteCard(cardId);

    // 2. delete all local transactions
    await transactionHiveService.deleteTransactionsByCard(cardId);

    // 3. delete from firestore if online
    if (await NetworkService.isConnected()) {
      await firestoreService.deleteCard(userId: userId, cardId: cardId);
    }
  }

  Stream<List<CardModel>> watchCards(String userId) async* {
    if (await NetworkService.isConnected()) {
      final remote = await firestoreService.getCards(userId);

      for (final c in remote) {
        await hiveService.updateCard(c);
      }

      yield remote;

      yield* hiveService.watchCards(userId);
    } else {
      yield* hiveService.watchCards(userId);
    }
  }
}
