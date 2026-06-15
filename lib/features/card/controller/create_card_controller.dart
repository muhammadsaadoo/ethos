import 'package:expence_management/features/card/controller/card_controller.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateCardController extends GetxController {
  final CardController cardController = Get.find<CardController>();

  final formKey = GlobalKey<FormState>();

  final cardNameCtrl = TextEditingController();
  final holderNameCtrl = TextEditingController();
  final cardNumberCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  final isLoading = false.obs;

  /// Preview values
  final cardName = ''.obs;
  final holderName = ''.obs;
  final cardNumber = ''.obs;
  final expiryDate = ''.obs;

  // ================= CREATE CARD =================

  Future<void> createCard() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final cleanCardNumber = cardNumberCtrl.text.replaceAll(' ', '').trim();
      final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;

      final card = CardModel(
        id: const Uuid().v4(),
        userId: cardController.userId,
        cardName: cardNameCtrl.text.trim(),
        totalAmount: amount,
        cardNumber: cleanCardNumber,
        expiryDate: expiryCtrl.text.trim(),
        cvv: cvvCtrl.text.trim(),
        cardHolderName: holderNameCtrl.text.trim(),
      );

      await cardController.repository.addCard(card);
      // await Future.delayed(const Duration(seconds: 3));

      Get.back();

      Get.snackbar(
        "Success",
        "Card created successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
      _resetForm();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CLEANUP =================

  @override
  void onClose() {
    cardNameCtrl.dispose();
    holderNameCtrl.dispose();
    cardNumberCtrl.dispose();
    expiryCtrl.dispose();
    cvvCtrl.dispose();
    amountCtrl.dispose();
    super.onClose();
  }

  // ================= VALIDATION HELPERS =================

  String? validateCardName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Card name is required";
    }
    if (value.trim().length < 3) {
      return "Card name too short";
    }
    return null;
  }

  String? validateHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Card holder name is required";
    }
    if (value.trim().length < 3) {
      return "Enter valid name";
    }
    return null;
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Card number is required";
    }

    final clean = value.replaceAll(' ', '');

    if (clean.length != 16) {
      return "Card number must be 16 digits";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(clean)) {
      return "Only numbers allowed";
    }

    return null;
  }

  String? validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return "Expiry is required";
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
      return "Format MM/YY";
    }

    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return "CVV is required";
    }

    if (value.length != 3) {
      return "CVV must be 3 digits";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only numbers allowed";
    }

    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final text = value.trim();

    final regex = RegExp(r'^\d+(\.\d+)?$');

    if (!regex.hasMatch(text)) {
      return "Enter valid number";
    }

    final amount = double.parse(text);

    if (amount <= 0) {
      return "Must be greater than 0";
    }

    return null;
  }

  void _resetForm() {
    cardNameCtrl.clear();
    holderNameCtrl.clear();
    cardNumberCtrl.clear();
    expiryCtrl.clear();
    cvvCtrl.clear();
    amountCtrl.clear();

    cardName.value = '';
    holderName.value = '';
    cardNumber.value = '';
    expiryDate.value = '';
  }
}
