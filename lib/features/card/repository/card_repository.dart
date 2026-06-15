// import '../../core/network/network_service.dart';
// import '../models/card_model.dart';
// import '../services/firestore/card_firestore_service.dart';
// import '../services/hive/card_hive_service.dart';

import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/service/firestore_service/card_firestore_service.dart';
import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:expence_management/features/transaction/service/transaction_hive_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CardRepository {
  final CardHiveService hiveService;
  final CardFirestoreService firestoreService;
  final TransactionHiveService transactionHiveService;

  CardRepository({
    required this.hiveService,
    required this.firestoreService,
    required this.transactionHiveService,
  });

  // Future<void> addCard(CardModel card) async {
  //   if (await NetworkService.isConnected()) {
  //     final syncedCard = card.copyWith(isSynced: true);
  //     await firestoreService.addCard(syncedCard);
  //     await hiveService.addCard(syncedCard); // single write, already synced
  //   } else {
  //     await hiveService.addCard(card); // single write, unsynced
  //   }
  // }
  Future<void> addCard(CardModel card) async {
    if (await NetworkService.isConnected()) {
      final syncedCard = card.copyWith(isSynced: true);
      await firestoreService.addCard(syncedCard);
      await hiveService.addCard(syncedCard);
    } else {
      await hiveService.addCard(card);
    }

    // Create initial balance transaction if amount > 0
    if (card.totalAmount > 0) {
      final initialTx = TransactionModel(
        id: const Uuid().v4(),
        userId: card.userId,
        cardId: card.id,
        amount: card.totalAmount,
        category: "Initial Balance",
        date: DateTime.now(),
        note: "Opening balance",
        isExpense: false,
        isSynced: false,
      );

      await Get.find<TransactionRepository>().addTransaction(initialTx);
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

  Future<void> clearAllData(String userId) async {
    await hiveService.clearAll();

    if (await NetworkService.isConnected()) {
      await firestoreService.clearAll(userId);
    }
  }

  Stream<List<CardModel>> watchCards(String userId) async* {
    if (await NetworkService.isConnected()) {
      final remote = await firestoreService.getCards(userId);
      for (final c in remote) {
        await hiveService.updateCard(c);
      }
    }

    yield* hiveService.watchCards(userId);
  }

  // Stream<List<CardModel>> watchCards(String userId) async* {
  //   if (await NetworkService.isConnected()) {
  //     final remote = await firestoreService.getCards(userId);

  //     for (final c in remote) {
  //       await hiveService.updateCard(c);
  //     }

  //     yield remote;

  //     yield* hiveService.watchCards(userId);
  //   } else {
  //     yield* hiveService.watchCards(userId);
  //   }
  // }
}
