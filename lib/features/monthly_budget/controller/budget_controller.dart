import 'package:expence_management/features/auth/services/user_session_service.dart';
import 'package:expence_management/features/home/controller/home_controller.dart';
import 'package:expence_management/features/monthly_budget/model/budget_model.dart';
import 'package:expence_management/features/monthly_budget/repository/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';

class BudgetController extends GetxController {
  final BudgetRepository repository;

  BudgetController(this.repository);

  final RxList<BudgetModel> budgets = <BudgetModel>[].obs;

  // final String userId = 'dummy_user_1';
  final userId = Get.find<UserSessionService>().userId;

  final HomeController homeController = Get.find<HomeController>();

  /// Form
  final formKey = GlobalKey<FormState>();

  final targetAmountController = TextEditingController();

  final selectedCategory = 'Food'.obs;

  /// Format: 2026-06
  final selectedMonth =
      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}'
          .obs;

  final isLoading = false.obs;

  final editingBudgetId = RxnString();

  void selectMonth(String month) {
    selectedMonth.value = month;
  }

  // =========================================================
  // CATEGORY CONFIG
  // =========================================================

  final Map<String, IconData> categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Transport': Icons.directions_car_rounded,
    'Bills': Icons.receipt_long_rounded,
    'Health': Icons.favorite_rounded,
    'Education': Icons.school_rounded,
    'Salary': Icons.account_balance_wallet_rounded,
    'Gift': Icons.card_giftcard_rounded,
    'Travel': Icons.flight_rounded,
    'Entertainment': Icons.movie_rounded,
    'Sports': Icons.sports_soccer_rounded,
    'Investment': Icons.trending_up_rounded,
    'Groceries': Icons.local_grocery_store_rounded,
    'Rent': Icons.home_rounded,
    'Other': Icons.category_rounded,
  };

  List<Map<String, dynamic>> get categories => categoryIcons.entries
      .map((e) => {'title': e.key, 'icon': e.value})
      .toList();

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    final data = await repository.getBudgets(userId);
    print(data);
    budgets.assignAll(data);
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void loadBudgetForEdit(BudgetModel budget) {
    targetAmountController.text = budget.targetAmount.toStringAsFixed(0);

    selectedCategory.value = budget.category;
    selectedMonth.value = budget.month;

    editingBudgetId.value = budget.id;
  }

  Future<void> saveBudget() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final isEditing = editingBudgetId.value != null;

      final budget = BudgetModel(
        id: isEditing ? editingBudgetId.value! : const Uuid().v4(),
        userId: userId,
        month: selectedMonth.value,
        category: selectedCategory.value,
        targetAmount: double.tryParse(targetAmountController.text.trim()) ?? 0,
        isSynced: false,
      );

      if (isEditing) {
        await repository.updateBudget(budget);

        final index = budgets.indexWhere((b) => b.id == budget.id);

        if (index != -1) {
          budgets[index] = budget;
        }
      } else {
        await repository.addBudget(budget);
        budgets.insert(0, budget);
      }

      clearForm();

      Get.back();

      Get.snackbar(
        'Success',
        isEditing
            ? 'Budget updated successfully'
            : 'Budget created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.actionGreen,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Budget Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBudget(BudgetModel budget) async {
    try {
      await repository.deleteBudget(budget);

      budgets.removeWhere((b) => b.id == budget.id);

      Get.snackbar('Deleted', 'Budget removed successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void clearForm() {
    targetAmountController.clear();

    selectedCategory.value = 'Food';

    selectedMonth.value =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';

    editingBudgetId.value = null;
  }

  @override
  void onClose() {
    targetAmountController.dispose();
    super.onClose();
  }

  // =========================================================
  // MONTH FILTERING
  // =========================================================

  List<BudgetModel> get currentMonthBudgets {
    return budgets
        .where((budget) => budget.month == selectedMonth.value)
        .toList();
  }

  String get selectedMonthLabel {
    final parts = selectedMonth.value.split('-');

    if (parts.length != 2) return selectedMonth.value;

    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));

    return "${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }

  // =========================================================
  // BUDGET ANALYTICS
  // =========================================================

  double getSpentForBudget(BudgetModel budget) {
    final parts = budget.month.split('-');

    if (parts.length != 2) return 0;

    final year = int.tryParse(parts[0]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 0;

    return homeController.transactions
        .where(
          (tx) =>
              tx.isExpense &&
              tx.category == budget.category &&
              tx.date.year == year &&
              tx.date.month == month,
        )
        .fold<double>(0, (sum, tx) => sum + tx.amount);
  }

  double getBudgetProgress(BudgetModel budget) {
    final spent = getSpentForBudget(budget);

    if (budget.targetAmount <= 0) return 0;

    return (spent / budget.targetAmount).clamp(0.0, 1.0);
  }

  double getRemainingBudget(BudgetModel budget) {
    return budget.targetAmount - getSpentForBudget(budget);
  }

  // =========================================================
  // MONTH SUMMARY
  // =========================================================

  double get totalMonthlyBudget {
    return currentMonthBudgets.fold(
      0.0,
      (sum, budget) => sum + budget.targetAmount,
    );
  }

  double get totalMonthlySpending {
    return currentMonthBudgets.fold(
      0.0,
      (sum, budget) => sum + getSpentForBudget(budget),
    );
  }

  double get totalRemainingBudget {
    return totalMonthlyBudget - totalMonthlySpending;
  }

  double get monthlyProgress {
    if (totalMonthlyBudget <= 0) return 0;

    return (totalMonthlySpending / totalMonthlyBudget).clamp(0.0, 1.0);
  }
}

// class BudgetController extends GetxController {
//   final BudgetRepository repository;

//   BudgetController(this.repository);

//   final RxList<BudgetModel> budgets = <BudgetModel>[].obs;

//   final String userId = 'dummy_user_1';

//   /// Form
//   final formKey = GlobalKey<FormState>();

//   final targetAmountController = TextEditingController();

//   final selectedCategory = 'Food'.obs;

//   /// Example: June 2026
//   // final selectedMonth = '${DateTime.now().month}-${DateTime.now().year}'.obs;

//   final isLoading = false.obs;
//   final selectedMonth = ''.obs;

//   void selectMonth(String month) {
//     selectedMonth.value = month;
//   }

//   /// null = create mode
//   /// value = edit mode
//   final editingBudgetId = RxnString();

//   final Map<String, IconData> categoryIcons = {
//     'Food': Icons.restaurant_rounded,
//     'Shopping': Icons.shopping_bag_rounded,
//     'Transport': Icons.directions_car_rounded,
//     'Bills': Icons.receipt_long_rounded,
//     'Health': Icons.favorite_rounded,
//     'Education': Icons.school_rounded,
//     'Salary': Icons.account_balance_wallet_rounded,
//     'Gift': Icons.card_giftcard_rounded,
//     'Travel': Icons.flight_rounded,
//     'Entertainment': Icons.movie_rounded,
//     'Sports': Icons.sports_soccer_rounded,
//     'Investment': Icons.trending_up_rounded,
//     'Groceries': Icons.local_grocery_store_rounded,
//     'Rent': Icons.home_rounded,
//     'Other': Icons.category_rounded,
//   };

//   List<Map<String, dynamic>> get categories => categoryIcons.entries
//       .map((e) => {'title': e.key, 'icon': e.value})
//       .toList();

//   @override
//   void onInit() {
//     super.onInit();
//     loadBudgets();
//   }

//   Future<void> loadBudgets() async {
//     final data = await repository.getBudgets(userId);
//     budgets.assignAll(data);
//   }

//   void selectCategory(String category) {
//     selectedCategory.value = category;
//   }

//   // void selectMonth(String month) {
//   //   selectedMonth.value = month;
//   // }

//   /// Load budget for editing
//   void loadBudgetForEdit(BudgetModel budget) {
//     targetAmountController.text = budget.targetAmount.toStringAsFixed(0);

//     selectedCategory.value = budget.category;
//     selectedMonth.value = budget.month;

//     editingBudgetId.value = budget.id;
//   }

//   Future<void> saveBudget() async {
//     if (!formKey.currentState!.validate()) return;

//     try {
//       isLoading.value = true;

//       final isEditing = editingBudgetId.value != null;

//       final budget = BudgetModel(
//         id: isEditing ? editingBudgetId.value! : const Uuid().v4(),
//         userId: userId,
//         month: selectedMonth.value,
//         category: selectedCategory.value,
//         targetAmount: double.tryParse(targetAmountController.text.trim()) ?? 0,
//         isSynced: false,
//       );

//       if (isEditing) {
//         await repository.updateBudget(budget);

//         final index = budgets.indexWhere((b) => b.id == budget.id);

//         if (index != -1) {
//           budgets[index] = budget;
//         }
//       } else {
//         await repository.addBudget(budget);
//         budgets.insert(0, budget);
//       }

//       clearForm();
//       Get.back();

//       Get.snackbar(
//         'Success',
//         isEditing
//             ? 'Budget updated successfully'
//             : 'Budget created successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.actionGreen,
//         colorText: AppColors.white,
//         margin: const EdgeInsets.all(12),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Budget Error',
//         e.toString().replaceAll("Exception: ", ""),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.red,
//         colorText: AppColors.white,
//         margin: const EdgeInsets.all(12),
//         icon: const Icon(Icons.error, color: AppColors.white),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> deleteBudget(BudgetModel budget) async {
//     try {
//       await repository.deleteBudget(budget);

//       budgets.removeWhere((b) => b.id == budget.id);

//       Get.snackbar('Deleted', 'Budget removed successfully');
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   void clearForm() {
//     targetAmountController.clear();

//     selectedCategory.value = 'Food';

//     selectedMonth.value = '${DateTime.now().month}-${DateTime.now().year}';

//     editingBudgetId.value = null;
//   }

//   @override
//   void onClose() {
//     targetAmountController.dispose();
//     super.onClose();
//   }
// }
