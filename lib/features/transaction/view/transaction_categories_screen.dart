import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/transaction/controller/add_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionCategoriesScreen extends GetView<AddTransactionController> {
  const TransactionCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = controller.categoryIcons.entries.toList();

    return Scaffold(
      extendBody: false,
      // background: #FBFCFCCC;
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightBackground,
        centerTitle: true,
        // elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          ' Select Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected =
                controller.selectedCategory.value == category.key;

            return GestureDetector(
              onTap: () {
                controller.selectCategory(category.key);
                Get.back();
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      //background: #EDEEEF;
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inputFill,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputFill,
                      ),
                    ),
                    child: Icon(
                      category.value,
                      color: isSelected ? AppColors.white : AppColors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.key,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
