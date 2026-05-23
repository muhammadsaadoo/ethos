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
}
