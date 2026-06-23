import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/card/controller/create_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCardScreen extends GetView<CreateCardController> {
  const CreateCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Get.isDarkMode
            ? AppColors.black
            : AppColors.pageBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create card',
          style: TextStyle(
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// ================= CARD PREVIEW =================
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 210,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.success, AppColors.primary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(0.07),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -70,
                        left: -30,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(0.05),
                          ),
                        ),
                      ),

                      // Card content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: name + chip
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.cardName.value.isEmpty
                                    ? "Card Name"
                                    : controller.cardName.value,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              // EMV Chip
                              Container(
                                width: 36,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.cardGoldLight,
                                      AppColors.cardGold,
                                    ],
                                  ),
                                ),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  padding: const EdgeInsets.all(5),
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 3,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    6,
                                    (_) => Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withOpacity(
                                          0.25,
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Card number
                          Text(
                            controller.cardNumber.value.isEmpty
                                ? "**** **** **** ****"
                                : controller.cardNumber.value,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 19,
                              letterSpacing: 3,
                              fontFamily: 'monospace',
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Bottom row: holder, expiry, logo
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Card holder
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "CARD HOLDER",
                                      style: TextStyle(
                                        color: AppColors.white54,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      controller.holderName.value.isEmpty
                                          ? "CARD HOLDER"
                                          : controller.holderName.value
                                                .toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Expiry
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "EXPIRES",
                                    style: TextStyle(
                                      color: AppColors.white54,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.expiryDate.value.isEmpty
                                        ? "MM/YY"
                                        : controller.expiryDate.value,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 16),

                              // Mastercard logo
                              SizedBox(
                                width: 46,
                                height: 28,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.cardNetworkRed,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.cardNetworkOrange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// ================= FORM CONTAINER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Get.isDarkMode
                          ? AppColors.darkCard
                          : AppColors.black,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldLabel("Card Name"),
                    textField(
                      controller: controller.cardNameCtrl,
                      hint: "Debit",
                      icon: Icons.credit_card,
                      onChanged: (v) => controller.cardName.value = v,
                      validator: controller.validateCardName,
                    ),

                    const SizedBox(height: 16),

                    fieldLabel("Card Holder Name"),
                    textField(
                      controller: controller.holderNameCtrl,
                      hint: "Saad",
                      icon: Icons.person_outline,
                      onChanged: (v) => controller.holderName.value = v,
                      validator: controller.validateHolderName,
                    ),

                    const SizedBox(height: 16),

                    fieldLabel("Card Number"),
                    textField(
                      controller: controller.cardNumberCtrl,
                      hint: "0000 0000 0000 0000",
                      icon: Icons.numbers,
                      keyboard: TextInputType.number,
                      onChanged: (v) => controller.cardNumber.value = v,
                      validator: controller.validateCardNumber,
                    ),

                    const SizedBox(height: 16),

                    /// EXPIRY + CVV LABEL ROW
                    Row(
                      children: [
                        Expanded(child: fieldLabel("Expiry")),
                        const SizedBox(width: 12),
                        Expanded(child: fieldLabel("CVV")),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: textField(
                            controller: controller.expiryCtrl,
                            hint: "MM/YY",
                            icon: Icons.date_range,
                            onChanged: (v) => controller.expiryDate.value = v,
                            validator: controller.validateExpiry,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: textField(
                            controller: controller.cvvCtrl,
                            hint: "123",
                            icon: Icons.lock_outline,
                            keyboard: TextInputType.number,
                            validator: controller.validateCVV,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    fieldLabel("Initial Balance"),
                    textField(
                      controller: controller.amountCtrl,
                      hint: "1000",
                      icon: Icons.account_balance_wallet,
                      keyboard: TextInputType.number,
                      validator: controller.validateAmount,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= BUTTON =================
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? () {} // 👈 keep enabled to avoid disabled styling
                        : controller.createCard,

                    icon: controller.isLoading.value
                        ? const SizedBox()
                        : Icon(
                            Icons.add,
                            color: Get.isDarkMode
                                ? AppColors.black
                                : AppColors.white,
                          ),

                    label: controller.isLoading.value
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Get.isDarkMode
                                  ? AppColors.black
                                  : AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Create Card",
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? AppColors.black
                                  : AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) => Theme.of(context).primaryColor,
                      ),

                      shadowColor: WidgetStateProperty.resolveWith(
                        (states) => Get.isDarkMode
                            ? AppColors.mintAccent
                            : AppColors.successGlow,
                      ),

                      elevation: WidgetStateProperty.resolveWith((states) => 6),

                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= LABEL =================
  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode ? AppColors.darkSubtitle : AppColors.grey700,
        ),
      ),
    );
  }

  /// ================= TEXT FIELD =================
  Widget textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    const borderColor = AppColors.inputHintMedium;

    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey.withAlpha(150)),

        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Get.isDarkMode ? AppColors.black : AppColors.fieldFill,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
      ),
    );
  }
}
