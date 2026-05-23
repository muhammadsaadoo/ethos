import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// import '../../../data/models/transaction_model.dart';
// import '../../../data/repositories/transaction_repository.dart';

class TransactionController extends GetxController {
  final TransactionRepository repository;

  TransactionController(this.repository);

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  final String userId = 'dummy_user_1';

  Future<void> loadTransactions() async {
    final data = await repository.getTransactions(userId);

    transactions.value = data;
  }

  Future<void> addDummyTransaction(String cardId) async {
    final tx = TransactionModel(
      id: const Uuid().v4(),
      userId: userId,
      cardId: cardId,
      amount: 500,
      category: 'Food',
      date: DateTime.now(),
      note: 'Dummy transaction',
      isExpense: true,
    );

    await repository.addTransaction(tx);

    transactions.add(tx);
  }
}
