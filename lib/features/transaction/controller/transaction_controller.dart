import 'dart:async';

import 'package:expence_management/features/card/controller/card_controller.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final TransactionRepository repository;

  TransactionController(this.repository);

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final CardController cardController = Get.find();
  // List get cards => await cardController.loadCards();

  final String userId = 'dummy_user_1';

  // ===================== WEEKLY CACHE =====================
  final RxList<double> weeklySpending = List<double>.filled(7, 0.0).obs;

  StreamSubscription? _sub;
  // final CardController cardController = Get.find();

  List<CardModel> get cards => cardController.cards;

  // ======================================================
  @override
  Future<void> onInit() async {
    super.onInit();
    bindTransactions();
  }

  // ======================================================
  // LOAD
  // ======================================================

  void bindTransactions() {
    _sub?.cancel();

    _sub = repository.watchTransactions(userId).listen((data) {
      transactions.assignAll(
        [...data]..sort((a, b) => b.date.compareTo(a.date)),
      );

      _calculateWeeklySpending();
    });
  }

  // void bindCards() {
  //   _cardSub?.cancel();

  //   _cardSub = repository.watchCards(userId).listen((data) {
  //     cards.assignAll(data);
  //   });
  // }

  // ======================================================
  // ADD DUMMY TRANSACTION
  // ======================================================

  // Future<void> addDummyTransaction(String cardId) async {
  //   final tx = TransactionModel(
  //     id: const Uuid().v4(),
  //     userId: userId,
  //     cardId: cardId,
  //     amount: 500,
  //     category: 'Food',
  //     date: DateTime.now(),
  //     note: 'Dummy transaction',
  //     isExpense: true,
  //   );

  //   await repository.addTransaction(tx);

  //   transactions.insert(0, tx);

  //   _calculateWeeklySpending();
  // }

  // ======================================================
  // DELETE
  // ======================================================

  Future<void> deleteTransaction(TransactionModel tx) async {
    await repository.deleteTransaction(tx);

    await cardController.loadCards();

    transactions.removeWhere((e) => e.id == tx.id);

    _calculateWeeklySpending();
  }

  // ======================================================
  // RECENT
  // ======================================================

  List<TransactionModel> get recentTransactions {
    return transactions.take(3).toList();
  }

  // ======================================================
  // DATE LABEL
  // ======================================================

  String getDateLabel(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) return 'Today';

    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

  // ======================================================
  // WEEKLY SPENDING (FOR CHART)
  // ======================================================

  void _calculateWeeklySpending() {
    final now = DateTime.now();

    final List<double> temp = List.filled(7, 0.0);

    for (final tx in transactions) {
      if (!tx.isExpense) continue;

      final diff = now.difference(tx.date).inDays;

      if (diff >= 0 && diff < 7) {
        final index = 6 - diff;

        if (index >= 0 && index < 7) {
          temp[index] += tx.amount;
        }
      }
    }

    weeklySpending.assignAll(temp);
  }

  // ======================================================
  // TOTALS (OPTIONAL DASHBOARD USE)
  // ======================================================

  double get totalIncome {
    return transactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get balance => totalIncome - totalExpense;
  // final RxString selectedFilter = "".obs;

  final RxList<String> filters = <String>[
    "Freeze",
    "Limits",
    "Pin",
    "More",
  ].obs;
  final Map<String, IconData> filterIcons = {
    "Freeze": Icons.ac_unit,
    "Limits": Icons.tune,
    "Pin": Icons.key_outlined,
    "More": Icons.settings,
  };

  final RxString selectedFilter = "Freeze".obs;

  void editTransaction(TransactionModel tx) {}
}
