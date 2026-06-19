import 'package:expence_management/features/auth/services/user_session_service.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:expence_management/features/dummy_data_service.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';

// class CardModel {
//   final String id, name, lastFour;
//   CardModel({required this.id, required this.name, required this.lastFour});
// }
// ───────────────────────────────────────────────────────────────────────────

class AddTransactionController extends GetxController {
  final selectedCategory = 'Food'.obs;

  /// Category Map
  /// Store category name in DB
  /// Retrieve icon using categoryIcons[name]
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

  /// Categories shown on Add Transaction screen
  List<Map<String, dynamic>> get defaultCategories => [
    {'label': 'Food', 'icon': categoryIcons['Food']!.codePoint},
    {'label': 'Shopping', 'icon': categoryIcons['Shopping']!.codePoint},
    {'label': 'Transport', 'icon': categoryIcons['Transport']!.codePoint},
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  IconData getCategoryIcon(String category) {
    return categoryIcons[category] ?? Icons.category_rounded;
  }

  DummyDataService service = DummyDataService();
  // ── Dependencies ──────────────────────────────────────────────────────────
  final uuid = const Uuid();
  // final String userId = "dummy_user_1";
  final userId = Get.find<UserSessionService>().userId;
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

  final Rxn<TransactionModel> editingTransaction = Rxn<TransactionModel>();

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
  // final List<Map<String, dynamic>> defaultCategories = const [
  //   {'label': 'Food', 'icon': 0xe56c}, // Icons.restaurant
  //   {'label': 'Transport', 'icon': 0xe531}, // Icons.directions_car
  //   {'label': 'Shopping', 'icon': 0xe59c}, // Icons.shopping_bag
  // ];

  // final RxString selectedCategory = ''.obs;

  // ── Note ─────────────────────────────────────────────────────────────────
  final RxString note = ''.obs;

  // ── Loading ───────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadCards();
    _loadEditArguments();

    if (selectedCard.value == null && cards.isNotEmpty) {
      selectedCard.value = cards.first;
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void selectCard(CardModel card) => selectedCard.value = card;

  void toggleExpense(bool expense) => isExpense.value = expense;

  // void selectCategory(String category) => selectedCategory.value = category;

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
        backgroundColor: AppColors.expense,
        colorText: AppColors.white,
      );
      return;
    }

    isLoading.value = true;
    bool isUpdated = false;
    print(
      'confirmTransaction called, editingTransaction=${editingTransaction.value?.id}',
    );
    try {
      if (editingTransaction.value != null) {
        isUpdated = true;
        await _updateTransaction(selectedCard.value!.id);
        print('transaction updated successfully');
        // Get.snackbar('Success', 'Transaction updated successfully');
      } else {
        await _createTransaction(selectedCard.value!.id);
        print('transaction added successfully');
        // Get.snackbar('Success', 'Transaction added successfully');
        print("check snakbar");
      }
      _resetForm();
      Get.back(result: true);
      Get.snackbar(
        'Success',
        isUpdated
            ? 'transaction updated successfully'
            : 'transaction created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.actionGreen,
        colorText: AppColors.white,
      );
    } catch (e, stack) {
      print('confirmTransaction failed: $e\n$stack');
      Get.snackbar('Error', 'Failed to save transaction: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    print("form reset");
    amountRaw.value = '0';
    selectedCategory.value = '';
    note.value = '';
    editingTransaction.value = null;
    // selectedCard keeps its value for convenience
    // Get.back();
  }

  void _loadEditArguments() {
    final arg = Get.arguments;
    if (arg is TransactionModel) {
      editingTransaction.value = arg;
      selectedCategory.value = arg.category;
      note.value = arg.note;
      isExpense.value = arg.isExpense;
      amountRaw.value = arg.amount.toStringAsFixed(2);

      final selected = cards.isNotEmpty
          ? cards.firstWhere(
              (card) => card.id == arg.cardId,
              orElse: () => cards.first,
            )
          : null;
      selectedCard.value = selected;
    }
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

  Future<void> _updateTransaction(String cardId) async {
    final oldTx = editingTransaction.value!;
    final updatedTx = oldTx.copyWith(
      cardId: cardId,
      amount: double.tryParse(amountRaw.value) ?? 0,
      category: selectedCategory.value,
      date: DateTime.now(),
      note: note.value,
      isExpense: isExpense.value,
      isSynced: false,
    );

    await transactionRepository.editTransaction(
      oldTx: oldTx,
      updatedTx: updatedTx,
    );
  }
}
