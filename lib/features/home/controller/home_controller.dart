import 'dart:async';

import 'package:expence_management/features/dummy_data_service.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final TransactionRepository transactionRepository = Get.find();
  DummyDataService service = DummyDataService();

  // ================= DASHBOARD DATA =================

  final totalBalance = 0.0.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final totalSavings = 0.0.obs;

  final categoryData = <CategoryUsage>[].obs;

  final weeklySpending = <double>[].obs;

  final monthlyFlow = <MonthlyFlow>[].obs;

  final isLoading = false.obs;

  // Replace later with AuthController.currentUser.id
  final String userId = "dummy_user_1";
  StreamSubscription? _txSub;

  void bindTransactions() async {
    print("bind Transactions Run");

    _txSub?.cancel();

    // 1. GET INITIAL DATA FIRST
    final initialData = await transactionRepository.getTransactions(userId);

    _recalculateAll(initialData);

    // 2. THEN START LISTENING
    _txSub = transactionRepository.watchTransactions(userId).listen((data) {
      debugPrint("STREAM TRIGGERED");
      debugPrint("Total TX: ${data.length}");

      _recalculateAll(data);
    });
  }

  void _recalculateAll(List<TransactionModel> data) {
    transactions.assignAll(data);

    _calculateSummary(data);
    _calculateCategoryUsage(data);
    _calculateWeeklySpending(data);
    _calculateMonthlyFlow(data);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await service.runDashboardTestData();

    // loadDashboardData();
    bindTransactions();
  }

  final transactions = <TransactionModel>[].obs;

  // var transactions;

  // =========================================================
  // ================= LOAD DASHBOARD ========================
  // =========================================================

  /*
  





   */

  // =========================================================
  // ================= SUMMARY ===============================
  // =========================================================

  void _calculateSummary(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;

    for (final tx in transactions) {
      if (tx.isExpense) {
        expense += tx.amount;
      } else {
        income += tx.amount;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;

    // temporary logic
    totalSavings.value = totalBalance.value;
  }

  // =========================================================
  // ================= CATEGORY ANALYTICS ====================
  // =========================================================

  void _calculateCategoryUsage(List<TransactionModel> transactions) {
    final expenseTransactions = transactions.where((e) => e.isExpense).toList();

    final totalExpenseAmount = expenseTransactions.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );

    if (totalExpenseAmount == 0) {
      categoryData.clear();
      return;
    }

    final Map<String, double> categoryTotals = {};

    for (final tx in expenseTransactions) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    final result = <CategoryUsage>[];

    int colorIndex = 0;

    categoryTotals.forEach((category, amount) {
      result.add(
        CategoryUsage(
          category,
          (amount / totalExpenseAmount) * 100,
          colors[colorIndex % colors.length],
        ),
      );

      colorIndex++;
    });

    categoryData.assignAll(result);
  }

  // =========================================================
  // ================= WEEKLY CHART ==========================
  // =========================================================

  void _calculateWeeklySpending(List<TransactionModel> transactions) {
    final now = DateTime.now();

    final weekly = List<double>.filled(7, 0);

    for (final tx in transactions) {
      if (!tx.isExpense) continue;

      final diff = now.difference(tx.date).inDays;

      if (diff < 7) {
        final weekdayIndex = tx.date.weekday - 1;

        weekly[weekdayIndex] += tx.amount;
      }
    }

    weeklySpending.assignAll(weekly);
  }

  // =========================================================
  // ================= MONTHLY FLOW ==========================
  // =========================================================

  void _calculateMonthlyFlow(List<TransactionModel> transactions) {
    final now = DateTime.now();

    final result = <MonthlyFlow>[];

    for (int i = 2; i >= 0; i--) {
      final targetMonth = DateTime(now.year, now.month - i);

      double income = 0;
      double expense = 0;

      for (final tx in transactions) {
        if (tx.date.month == targetMonth.month &&
            tx.date.year == targetMonth.year) {
          if (tx.isExpense) {
            expense += tx.amount;
          } else {
            income += tx.amount;
          }
        }
      }

      result.add(MonthlyFlow(_monthName(targetMonth.month), income, expense));
    }

    monthlyFlow.assignAll(result);
  }

  // =========================================================
  // ================= HELPERS ===============================
  // =========================================================

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month - 1];
  }

  List<FlSpot> get weeklySpots {
    return List.generate(
      weeklySpending.length,
      (index) => FlSpot(index.toDouble(), weeklySpending[index]),
    );
  }

  @override
  void onClose() {
    _txSub?.cancel();
    super.onClose();
  }
}

// =========================================================
// ================= MODELS =================================
// =========================================================

class CategoryUsage {
  final String name;
  final double percentage;
  final Color color;

  CategoryUsage(this.name, this.percentage, this.color);
}

class MonthlyFlow {
  final String month;
  final double income;
  final double expense;

  MonthlyFlow(this.month, this.income, this.expense);
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeController extends GetxController {
//   final totalBalance = 50000.00.obs;
//   final totalIncome = 75000.0.obs;
//   final totalExpense = 25000.0.obs;
//   final totalSavings = 50000.0.obs;

//   final categoryData = <CategoryUsage>[
//     // percentage
//     CategoryUsage("Food", 35, Colors.green),
//     CategoryUsage("Shopping", 25, Colors.blue),
//     CategoryUsage("Transport", 20, Colors.orange),
//     CategoryUsage("Bills", 20, Colors.red),
//   ].obs;

//   final weeklySpending = <double>[1200, 1800, 1400, 2500, 2200, 3000, 2700].obs;
//   List<FlSpot> get weeklySpots {
//     if (weeklySpending.isEmpty) return [];

//     return List.generate(weeklySpending.length, (index) {
//       final value = weeklySpending[index];

//       if (value.isNaN || value.isInfinite) {
//         return FlSpot(index.toDouble(), 0);
//       }

//       return FlSpot(index.toDouble(), value);
//     });
//   }

//   final monthlyFlow = <MonthlyFlow>[
//     MonthlyFlow("Jan", 60000, 45000),
//     MonthlyFlow("Feb", 55000, 35000),
//     MonthlyFlow("Mar", 70000, 50000),
//   ].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadDashboardData();
//   }

//   Future<void> loadDashboardData() async {
//     // later:
//     // cards = await cardRepo.getCards();
//     // transactions = await transactionRepo.getTransactions();
//     // goals = await goalRepo.getGoals();
//   }
// }

// class CategoryUsage {
//   final String name;
//   final double percentage;
//   final Color color;

//   CategoryUsage(this.name, this.percentage, this.color);
// }

// class MonthlyFlow {
//   final String month;
//   final double income;
//   final double expense;

//   MonthlyFlow(this.month, this.income, this.expense);
// }
