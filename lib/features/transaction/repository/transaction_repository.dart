import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/card/service/firestore_service/card_firestore_service.dart';
import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/service/transaction_firestore_service.dart';
import 'package:expence_management/features/transaction/service/transaction_hive_service.dart';

// import '../../core/network/network_service.dart';
// import '../models/transaction_model.dart';
// import '../services/firestore/transaction_firestore_service.dart';
// import '../services/hive/transaction_hive_service.dart';

class TransactionRepository {
  final TransactionHiveService hiveService;
  final TransactionFirestoreService firestoreService;
  final CardHiveService cardHiveService;
  final CardFirestoreService cardFirestoreService;
  // final CardHiveService cardHiveService;

  TransactionRepository({
    required this.hiveService,
    required this.firestoreService,
    required this.cardHiveService,
    required this.cardFirestoreService,
  });

  Future<void> addTransaction(TransactionModel tx) async {
    await hiveService.addTransaction(tx);
    print("add transaction");
    print(tx.amount);

    if (tx.category != "Initial Balance") {
      await _updateCardBalance(tx);
    }

    if (await NetworkService.isConnected()) {
      final synced = tx.copyWith(isSynced: true);

      await firestoreService.addTransaction(synced);

      await hiveService.update(synced);
    }
  }

  Future<void> editTransaction({
    required TransactionModel oldTx,
    required TransactionModel updatedTx,
  }) async {
    final isOnline = await NetworkService.isConnected();
    final txToSave = updatedTx.copyWith(isSynced: isOnline);

    await hiveService.updateTransaction(txToSave);

    await _updateCardBalanceForEdit(oldTx, txToSave);

    if (isOnline) {
      await firestoreService.updateTransaction(txToSave);
      await hiveService.update(txToSave);
    }
  }

  Future<void> _updateCardBalanceForEdit(
    TransactionModel oldTx,
    TransactionModel updatedTx,
  ) async {
    if (oldTx.cardId == updatedTx.cardId) {
      await _adjustCardBalanceForSameCard(oldTx, updatedTx);
      return;
    }

    if (oldTx.category != "Initial Balance") {
      await _reverseCardBalance(oldTx);
    }

    if (updatedTx.category != "Initial Balance") {
      await _updateCardBalance(updatedTx);
    }
  }

  Future<void> _adjustCardBalanceForSameCard(
    TransactionModel oldTx,
    TransactionModel updatedTx,
  ) async {
    final cards = cardHiveService.getCards(updatedTx.userId);
    final card = cards.firstWhere((c) => c.id == updatedTx.cardId);

    double updatedAmount = card.totalAmount;

    if (oldTx.category != "Initial Balance") {
      updatedAmount += oldTx.isExpense ? oldTx.amount : -oldTx.amount;
    }

    if (updatedTx.category != "Initial Balance") {
      updatedAmount += updatedTx.isExpense
          ? -updatedTx.amount
          : updatedTx.amount;
    }

    if (updatedAmount != card.totalAmount) {
      final updatedCard = card.copyWith(totalAmount: updatedAmount);
      await cardHiveService.updateCard(updatedCard);
      if (await NetworkService.isConnected()) {
        await cardFirestoreService.updateCard(updatedCard);
      }
    }
  }

  Future<void> _updateCardBalance(TransactionModel tx) async {
    final cards = cardHiveService.getCards(tx.userId);

    final card = cards.firstWhere((c) => c.id == tx.cardId);

    double updatedAmount = card.totalAmount; //50000
    print("initial card amount  $updatedAmount");

    if (tx.isExpense) {
      updatedAmount -= tx.amount; // if expence the subtract
    } else {
      updatedAmount += tx.amount; // updated amount add
    }

    print("after ytansaction  $updatedAmount");

    final updatedCard = card.copyWith(totalAmount: updatedAmount);

    await cardHiveService.updateCard(updatedCard);

    if (await NetworkService.isConnected()) {
      await cardFirestoreService.updateCard(updatedCard);
    }
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    if (await NetworkService.isConnected()) {
      final data = await firestoreService.getTransactions(userId);

      for (final tx in data) {
        await hiveService.update(tx);
      }

      return data;
    }

    return hiveService.getTransactions(userId);
  }

  Future<void> syncPending() async {
    if (!await NetworkService.isConnected()) return;

    final unsynced = hiveService.getUnsynced();

    for (final tx in unsynced) {
      final synced = tx.copyWith(isSynced: true);

      await firestoreService.addTransaction(synced);

      await hiveService.update(synced);
    }
  }

  Stream<List<TransactionModel>> watchTransactions(String userId) async* {
    if (await NetworkService.isConnected()) {
      final data = await firestoreService.getTransactions(userId);

      // Replace local data instead of appending
      await hiveService.replaceUserTransactions(userId, data);

      // Only listen to Hive
      yield* hiveService.watchTransactions(userId);
    } else {
      yield* hiveService.watchTransactions(userId);
    }
  }

  Future<void> deleteTransaction(TransactionModel tx) async {
    // 1. remove locally
    await hiveService.deleteTransaction(tx.id);

    // 2. fix card balance
    await _reverseCardBalance(tx);

    // 3. delete from firestore if online
    if (await NetworkService.isConnected()) {
      await firestoreService.deleteTransaction(
        userId: tx.userId,
        transactionId: tx.id,
      );
    }
  }

  Future<void> clearAllData(String userId) async {
    await hiveService.clearAll();

    if (await NetworkService.isConnected()) {
      await firestoreService.clearAll(userId);
    }
  }

  Future<void> _reverseCardBalance(TransactionModel tx) async {
    final cards = cardHiveService.getCards(tx.userId);

    final card = cards.firstWhere((c) => c.id == tx.cardId);

    double updated = card.totalAmount;

    if (tx.isExpense) {
      // expense removed → add money back
      updated += tx.amount;
    } else {
      // income removed → subtract money
      updated -= tx.amount;
    }

    final updatedCard = card.copyWith(totalAmount: updated);

    await cardHiveService.updateCard(updatedCard);

    if (await NetworkService.isConnected()) {
      await cardFirestoreService.updateCard(updatedCard);
    }
  }
}
