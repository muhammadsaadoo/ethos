import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
// import '../../models/transaction_model.dart';

class TransactionHiveService {
  final Box<TransactionModel> box = Hive.box<TransactionModel>(
    HiveBoxes.transactions,
  );

  Future<void> addTransaction(TransactionModel tx) async {
    await box.put(tx.id, tx);
    // tx.cardId
    // subtract amount from card
  }

  List<TransactionModel> getTransactions(String userId) {
    return box.values.where((e) => e.userId == userId).toList();
  }

  List<TransactionModel> getByCard(String cardId) {
    return box.values.where((e) => e.cardId == cardId).toList();
  }

  List<TransactionModel> getUnsynced() {
    return box.values.where((e) => e.isSynced == false).toList();
  }

  Future<void> update(TransactionModel tx) async {
    await box.put(tx.id, tx);
  }

  Future<void> clearAll() async {
    await box.clear();
  }

  Stream<List<TransactionModel>> watchTransactions(String userId) {
    return box.watch().map((event) {
      return box.values.where((e) => e.userId == userId).toList();
    });
  }

  Future<void> deleteTransactionsByCard(String cardId) async {
    final keysToDelete = box.values
        .where((tx) => tx.cardId == cardId)
        .map((tx) => tx.id)
        .toList();

    for (final id in keysToDelete) {
      await box.delete(id);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    await box.delete(transactionId);
  }

  Future<void> replaceUserTransactions(
    String userId,
    List<TransactionModel> transactions,
  ) async {
    final existingIds = box.values
        .where((e) => e.userId == userId)
        .map((e) => e.id)
        .toList();

    await box.deleteAll(existingIds);

    for (final tx in transactions) {
      await box.put(tx.id, tx);
    }
  }
}
