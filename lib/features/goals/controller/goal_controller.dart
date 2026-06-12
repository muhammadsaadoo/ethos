import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/goals/repository/goal_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GoalController extends GetxController {
  final GoalRepository repository;

  GoalController(this.repository);

  final RxList<GoalModel> goals = <GoalModel>[].obs;

  final String userId = 'dummy_user_1';

  // Form
  final formKey = GlobalKey<FormState>();

  final goalNameController = TextEditingController();
  final targetAmountController = TextEditingController();
  final initialContributionController = TextEditingController();

  final selectedCategory = 'Travel'.obs;
  final selectedDate = Rxn<DateTime>();

  final isLoading = false.obs;

  // null = creating new, non-null = editing existing
  final editingGoalId = RxnString();

  /// Category Map
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
    loadGoals();
  }

  Future<void> loadGoals() async {
    final data = await repository.getGoals(userId);
    goals.value = data;
  }

  /// Pre-fills the form fields with an existing goal for editing
  void loadGoalForEdit(GoalModel goal) {
    goalNameController.text = goal.goalName;
    targetAmountController.text = goal.targetAmount.toStringAsFixed(0);
    initialContributionController.text = goal.savedAmount > 0
        ? goal.savedAmount.toStringAsFixed(0)
        : '';
    selectedCategory.value = goal.category;
    selectedDate.value = goal.deadline;
    editingGoalId.value = goal.id;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: selectedDate.value ?? DateTime.now(),
    );
    if (date != null) {
      selectedDate.value = date;
    }
  }

  Future<void> createGoal() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Please select a target date');
      return;
    }

    try {
      isLoading.value = true;

      final isEditing = editingGoalId.value != null;

      final goal = GoalModel(
        id: isEditing ? editingGoalId.value! : const Uuid().v4(),
        userId: userId,
        goalName: goalNameController.text.trim(),
        category: selectedCategory.value,
        targetAmount: double.tryParse(targetAmountController.text.trim()) ?? 0,
        savedAmount:
            double.tryParse(initialContributionController.text.trim()) ?? 0,
        deadline: selectedDate.value!,
        isSynced: false,
      );

      if (isEditing) {
        await repository.updateGoal(goal);
        final idx = goals.indexWhere((g) => g.id == goal.id);
        if (idx != -1) goals[idx] = goal;
      } else {
        await repository.addGoal(goal);
        goals.insert(0, goal);
      }

      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        isEditing ? 'Goal updated successfully' : 'Goal created successfully',
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGoal(GoalModel goal) async {
    try {
      await repository.deleteGoal(goal);
      goals.removeWhere((g) => g.id == goal.id);
      Get.snackbar('Deleted', 'Goal removed successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addDummyGoal() async {
    final goal = GoalModel(
      id: const Uuid().v4(),
      userId: userId,
      goalName: 'Buy iPhone',
      category: 'Electronics',
      targetAmount: 200000,
      savedAmount: 50000,
      deadline: DateTime.now().add(const Duration(days: 90)),
    );
    await repository.addGoal(goal);
    goals.add(goal);
  }

  void clearForm() {
    goalNameController.clear();
    targetAmountController.clear();
    initialContributionController.clear();
    selectedCategory.value = 'Travel';
    selectedDate.value = null;
    editingGoalId.value = null;
  }

  @override
  void onClose() {
    goalNameController.dispose();
    targetAmountController.dispose();
    initialContributionController.dispose();
    super.onClose();
  }
}
