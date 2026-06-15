import 'package:expence_management/core/network/network_service.dart';
import 'package:expence_management/features/monthly_budget/model/budget_model.dart';
import 'package:expence_management/features/monthly_budget/service/budget_firestore_service.dart';
import 'package:expence_management/features/monthly_budget/service/budget_hive_service.dart';

class BudgetRepository {
  final BudgetHiveService hiveService;
  final BudgetFirestoreService firestoreService;

  BudgetRepository({required this.hiveService, required this.firestoreService});

  /// ADD BUDGET
  Future<void> addBudget(BudgetModel budget) async {
    // 1. Check duplicate in local Hive first
    final existing = hiveService
        .getBudgets(budget.userId)
        .any(
          (b) =>
              b.category.toLowerCase() == budget.category.toLowerCase() &&
              b.month == budget.month,
        );

    if (existing) {
      throw Exception(
        "${budget.category} budget already exists for this month",
      );
    }

    // 2. Save locally
    await hiveService.addBudget(budget);

    // 3. Sync online if connected
    if (await NetworkService.isConnected()) {
      final synced = BudgetModel(
        id: budget.id,
        userId: budget.userId,
        month: budget.month,
        category: budget.category,
        targetAmount: budget.targetAmount,
        isSynced: true,
      );

      await firestoreService.addBudget(synced);
      await hiveService.update(synced);
    }
  }

  /// GET BUDGETS
  Future<List<BudgetModel>> getBudgets(String userId) async {
    if (await NetworkService.isConnected()) {
      final data = await firestoreService.getBudgets(userId);

      for (final b in data) {
        await hiveService.update(b);
      }

      return data;
    }

    return hiveService.getBudgets(userId);
  }

  /// SYNC UNSYNCED
  Future<void> syncPending() async {
    if (!await NetworkService.isConnected()) return;

    final unsynced = hiveService.getUnsynced();

    for (final b in unsynced) {
      final synced = BudgetModel(
        id: b.id,
        userId: b.userId,
        month: b.month,
        category: b.category,
        targetAmount: b.targetAmount,
        isSynced: true,
      );

      await firestoreService.addBudget(synced);
      await hiveService.update(synced);
    }
  }

  /// UPDATE BUDGET
  Future<void> updateBudget(BudgetModel budget) async {
    await hiveService.update(
      BudgetModel(
        id: budget.id,
        userId: budget.userId,
        month: budget.month,
        category: budget.category,
        targetAmount: budget.targetAmount,
        isSynced: false,
      ),
    );

    if (await NetworkService.isConnected()) {
      await firestoreService.updateBudget(budget);

      await hiveService.update(budget.copyWith(isSynced: true));
    }
  }

  /// DELETE BUDGET
  Future<void> deleteBudget(BudgetModel budget) async {
    await hiveService.delete(budget.id);

    if (await NetworkService.isConnected()) {
      await firestoreService.deleteBudget(
        userId: budget.userId,
        budgetId: budget.id,
      );
    }
  }

  Future<void> clearAllData(String userId) async {
    await hiveService.clearAll();

    if (await NetworkService.isConnected()) {
      await firestoreService.clearAll(userId);
    }
  }
}
