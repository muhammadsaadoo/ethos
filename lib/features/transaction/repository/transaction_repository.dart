import 'package:expence_management/core/network/network_service.dart';
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

  TransactionRepository({
    required this.hiveService,
    required this.firestoreService,
  });

  Future<void> addTransaction(TransactionModel tx) async {
    await hiveService.addTransaction(tx);

    if (await NetworkService.isConnected()) {
      final synced = tx.copyWith(isSynced: true);

      await firestoreService.addTransaction(synced);

      await hiveService.update(synced);
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
}
