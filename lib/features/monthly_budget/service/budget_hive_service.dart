import 'package:expence_management/features/monthly_budget/model/budget_model.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';

class BudgetHiveService {
  final Box<BudgetModel> box = Hive.box<BudgetModel>(HiveBoxes.budget);

  Future<void> addBudget(BudgetModel budget) async {
    await box.put(budget.id, budget);
  }

  List<BudgetModel> getBudgets(String userId) {
    return box.values.where((e) => e.userId == userId).toList();
  }

  List<BudgetModel> getUnsynced() {
    return box.values.where((e) => e.isSynced == false).toList();
  }

  Future<void> update(BudgetModel budget) async {
    await box.put(budget.id, budget);
  }

  Future<void> delete(String budgetId) async {
    await box.delete(budgetId);
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
