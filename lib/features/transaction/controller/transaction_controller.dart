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

  final PageController pageController = PageController();

  final RxInt selectedCardIndex = 0.obs;

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  final CardController cardController = Get.find();

  final String userId = 'dummy_user_1';

  final RxList<double> weeklySpending = List<double>.filled(7, 0.0).obs;

  StreamSubscription? _sub;

  // ================= CARDS =================
  List<CardModel> get cards => cardController.cards;

  CardModel? get selectedCard {
    // print("print all Cards.......");
    // for (var card in cards) {
    //   print(
    //     'Card ID: ${card.id}, Name: ${card.cardName}',
    //   ); // Customize with your CardModel fields
    // }
    if (cards.isEmpty) return null;
    if (selectedCardIndex.value >= cards.length) return null;
    return cards[selectedCardIndex.value];
  }

  List<TransactionModel> get cardTransactions {
    final cardId = selectedCard?.id;
    if (cardId == null) return [];

    return transactions.where((tx) => tx.cardId == cardId).toList();
  }

  @override
  void onInit() {
    super.onInit();
    bindTransactions();
  }

  // ================= STREAM =================
  void bindTransactions() {
    _sub?.cancel();

    _sub = repository.watchTransactions(userId).listen((data) {
      transactions.assignAll(
        [...data]..sort((a, b) => b.date.compareTo(a.date)),
      );

      _calculateWeeklySpending();
    });
  }

  // ================= DELETE =================
  Future<void> deleteTransaction(TransactionModel tx) async {
    await repository.deleteTransaction(tx);

    // ❌ REMOVED: cardController.loadCards();

    transactions.removeWhere((e) => e.id == tx.id);

    _calculateWeeklySpending();
  }

  // ================= RECENT =================
  List<TransactionModel> get recentTransactions {
    return transactions.take(3).toList();
  }

  // ================= DATE =================
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

  // ================= WEEKLY =================
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

  // ================= TOTALS =================
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

  // ================= FILTERS =================
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

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
