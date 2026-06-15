import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_management/features/monthly_budget/model/budget_model.dart';

class BudgetFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addBudget(BudgetModel budget) async {
    await firestore
        .collection('users')
        .doc(budget.userId)
        .collection('monthly_budgets')
        .doc(budget.id)
        .set(budget.toJson());
  }

  Future<List<BudgetModel>> getBudgets(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_budgets')
        .get();

    return snapshot.docs
        .map((doc) => BudgetModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await firestore
        .collection('users')
        .doc(budget.userId)
        .collection('monthly_budgets')
        .doc(budget.id)
        .update(budget.toJson());
  }

  Future<void> deleteBudget({
    required String userId,
    required String budgetId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_budgets')
        .doc(budgetId)
        .delete();
  }

  Future<void> clearAll(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_budgets')
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
