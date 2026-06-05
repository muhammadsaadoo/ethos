import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// class CardModel {
//   final String id, name, lastFour;
//   CardModel({required this.id, required this.name, required this.lastFour});
// }
// ───────────────────────────────────────────────────────────────────────────

class AddTransactionController extends GetxController {
  // ── Dependencies ──────────────────────────────────────────────────────────
  final uuid = const Uuid();
  final String userId = "dummy_user_1";
  // Inject your real repository here:
  final TransactionRepository transactionRepository = Get.find();
  final CardRepository cardRepository = Get.find();
  // AddTransactionController(this.transactionRepository);
  final RxList<CardModel> cards = <CardModel>[].obs;

  Future<void> _loadCards() async {
    print("cards loading...");
    final result = await cardRepository.getCards(userId);
    cards.assignAll(result.cast<CardModel>());
    if (cards.isNotEmpty) selectedCard.value = cards.first;
  }

  // ── State ─────────────────────────────────────────────────────────────────

  /// Cards available for selection
  // final RxList<CardModel> cards = <CardModel>[
  //   CardModel(id: 'card_1', name: 'Visa Platinum', lastFour: '4242'),
  //   CardModel(id: 'card_2', name: 'MasterCard Gold', lastFour: '8731'),
  //   CardModel(id: 'card_3', name: 'Amex Blue', lastFour: '3309'),
  // ].obs;

  /// Currently selected card
  final Rx<CardModel?> selectedCard = Rx<CardModel?>(null);

  /// true = Expense, false = Income
  final RxBool isExpense = true.obs;

  /// Raw digit string built by the custom keypad
  final RxString amountRaw = '0'.obs;

  /// Formatted display value  e.g. "124.50"
  String get amountDisplay {
    if (amountRaw.value == '0') return '0.00';
    final val = double.tryParse(amountRaw.value) ?? 0;
    return val.toStringAsFixed(2);
  }

  /// Spending limit used to drive the progress bar (customise as needed)
  RxDouble get spendingLimit => (selectedCard.value?.totalAmount ?? 0.0).obs;

  double get progressRatio {
    if (selectedCard.value == null) return 0.0;
    final val = double.tryParse(amountRaw.value) ?? 0;
    return (val / spendingLimit.value).clamp(0.0, 1.0);
  }

  // ── Categories ────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> defaultCategories = const [
    {'label': 'Food', 'icon': 0xe56c}, // Icons.restaurant
    {'label': 'Transport', 'icon': 0xe531}, // Icons.directions_car
    {'label': 'Shopping', 'icon': 0xe59c}, // Icons.shopping_bag
  ];

  final RxString selectedCategory = ''.obs;

  // ── Note ─────────────────────────────────────────────────────────────────
  final RxString note = ''.obs;

  // ── Loading ───────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadCards();

    if (cards.isNotEmpty) selectedCard.value = cards.first;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void selectCard(CardModel card) => selectedCard.value = card;

  void toggleExpense(bool expense) => isExpense.value = expense;

  void selectCategory(String category) => selectedCategory.value = category;

  /// Appends a digit or decimal point via the custom keypad
  void onKeypadTap(String key) {
    if (key == 'backspace') {
      if (amountRaw.value.length <= 1) {
        amountRaw.value = '0';
      } else {
        amountRaw.value = amountRaw.value.substring(
          0,
          amountRaw.value.length - 1,
        );
      }
      return;
    }

    if (key == '.') {
      if (amountRaw.value.contains('.')) return; // only one decimal
      amountRaw.value = '${amountRaw.value}.';
      return;
    }

    // Limit decimal places to 2
    if (amountRaw.value.contains('.')) {
      final parts = amountRaw.value.split('.');
      if (parts[1].length >= 2) return;
    }

    if (amountRaw.value == '0') {
      amountRaw.value = key;
    } else {
      amountRaw.value = '${amountRaw.value}$key';
    }
  }

  // ── Core transaction method (wired to your real repo) ────────────────────
  Future<void> confirmTransaction() async {
    if (selectedCard.value == null) {
      Get.snackbar('Error', 'Please select a card');
      return;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }
    final amount = double.tryParse(amountRaw.value) ?? 0;
    if (amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    // ── Balance check (only for expenses) ──
    if (isExpense.value && amount > (selectedCard.value?.totalAmount ?? 0)) {
      Get.snackbar(
        'Insufficient Balance',
        'Amount exceeds card balance of \$${selectedCard.value!.totalAmount.toStringAsFixed(2)}',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _createTransaction(selectedCard.value!.id);
      _resetForm();
      Get.back(result: true);
      Get.snackbar('Success', 'Transaction added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add transaction: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    amountRaw.value = '0';
    selectedCategory.value = '';
    note.value = '';
    // selectedCard keeps its value for convenience
  }

  Future<List> getCards() async {
    return await cardRepository.getCards(userId);
    // cards.assignAll(result);
  }

  Future<TransactionModel> _createTransaction(String cardId) async {
    final tx = TransactionModel(
      id: uuid.v4(),
      userId: userId, // replace with real userId
      cardId: cardId,
      amount: double.tryParse(amountRaw.value) ?? 0,
      category: selectedCategory.value,
      date: DateTime.now(),
      note: note.value,
      isExpense: isExpense.value,
      isSynced: false,
    );
    await transactionRepository.addTransaction(tx);
    print(tx.toJson());

    return tx;
  }
}
