import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
// import '../../models/transaction_model.dart';

class TransactionFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addTransaction(TransactionModel tx) async {
    await firestore
        .collection('users')
        .doc(tx.userId)
        .collection('transactions')
        .doc(tx.id)
        .set(tx.toJson());
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .get();

    return snapshot.docs
        .map((e) => TransactionModel.fromJson(e.data()))
        .toList();
  }
}
