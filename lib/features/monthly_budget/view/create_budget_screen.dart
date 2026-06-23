import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/monthly_budget/controller/budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateBudgetScreen extends GetView<BudgetController> {
  const CreateBudgetScreen({super.key});

  static const Color reusablecolor = AppColors.slateText;

  String _formatMonth(String value) {
    try {
      final parts = value.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final date = DateTime(year, month);
      return DateFormat('MMMM yyyy').format(date);
    } catch (_) {
      return value;
    }
  }

  static const _shadow = [
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: 20.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 4.0),
    ),
  ];

  /*
  here is my screen for create goals
  i want to create budgetscreen same like this
  exclude Goal Name, initial conrtibution)

   */

  // Detect edit mode from controller
  // bool get _isEditing => controller.editingGoalId.value != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Get.isDarkMode ? AppColors.black : AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
        ),
        title: Obx(
          () => Text(
            controller.editingBudgetId.value != null
                ? 'Edit Budget'
                : 'New Budget',
            style: TextStyle(
              color: Get.isDarkMode ? AppColors.white : AppColors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTargetAmountCard(),
              const SizedBox(height: 25),

              _buildDateField(context), // enter Month
              const SizedBox(height: 24),
              const Text(
                "Category",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(),
              const SizedBox(height: 40),

              _buildCreateButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: _shadow,
      ),
      child: Column(
        children: [
          Text(
            "TARGET AMOUNT",
            style: TextStyle(
              color: Get.isDarkMode ? AppColors.white : AppColors.black,
              letterSpacing: 1.5,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "\$ ",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode
                        ? AppColors.mintAccent
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: TextFormField(
                    controller: controller.targetAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode
                          ? AppColors.mintAccent
                          : AppColors.actionGreen,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "10,000",
                      fillColor: Get.isDarkMode
                          ? AppColors.darkCard
                          : AppColors.white,
                      hintStyle: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode
                            ? AppColors.darkSubtitle
                            : AppColors.darkSubtitle,
                      ),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter target amount';
                      }
                      if (double.tryParse(value.replaceAll(',', '')) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    // Simple list of month names for the UI selection
    final List<String> months = [
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: _shadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Month",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Get.isDarkMode ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Open a bottom sheet showing only the months
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      height: 350, // Fixed height for smooth scrolling
                      child: Column(
                        children: [
                          const Text(
                            "Choose Month",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: months.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    months[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    // Formats index to 1-indexed string matching your logic (e.g. "2026-05")
                                    final int monthNumber = index + 1;
                                    final int currentYear = DateTime.now().year;
                                    final formattedMonth =
                                        "$currentYear-${monthNumber.toString().padLeft(2, '0')}";

                                    controller.selectMonth(formattedMonth);
                                    Navigator.pop(context); // Close sheet
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppColors.black : AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Get.isDarkMode
                            ? AppColors.white
                            : AppColors.black,
                        size: 15,
                      ),
                      const SizedBox(width: 12),
                      Obx(
                        () => Text(
                          controller.selectedMonth.value.isEmpty
                              ? "Select month"
                              : _formatMonth(controller.selectedMonth.value),
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDateField(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(5),
  //       boxShadow: _shadow,
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Select Month",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 12,
  //               color: reusablecolor,
  //             ),
  //           ),
  //           const SizedBox(height: 8),

  //           InkWell(
  //             borderRadius: BorderRadius.circular(20),
  //             onTap: () async {
  //               final DateTime? picked = await showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime.now(),
  //                 firstDate: DateTime(2020),
  //                 lastDate: DateTime(2100),
  //                 helpText: "Select Month",
  //                 builder: (context, child) {
  //                   return Theme(
  //                     data: Theme.of(context).copyWith(
  //                       dialogTheme: const DialogThemeData(
  //                         shape: RoundedRectangleBorder(),
  //                       ),
  //                     ),
  //                     child: child!,
  //                   );
  //                 },
  //               );

  //               if (picked != null) {
  //                 final monthOnly =
  //                     "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
  //                 controller.selectMonth(monthOnly);
  //               }
  //             },
  //             child: Container(
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: AppColors.fieldFill,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 12,
  //                   vertical: 12,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     const Icon(
  //                       Icons.calendar_today_outlined,
  //                       color: AppColors.bodyText,
  //                       size: 15,
  //                     ),
  //                     const SizedBox(width: 12),

  //                     Obx(
  //                       () => Text(
  //                         controller.selectedMonth.value.isEmpty
  //                             ? "Select month"
  //                             : _formatMonth(controller.selectedMonth.value),
  //                         style: const TextStyle(
  //                           color: AppColors.bodyText,
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDateField(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(5),
  //       boxShadow: _shadow,
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Target Date",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 12,
  //               color: reusablecolor,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Obx(
  //             () => InkWell(
  //               borderRadius: BorderRadius.circular(20),
  //               onTap: () => controller.pickDate(context),
  //               child: Container(
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: AppColors.fieldFill,
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 12,
  //                     vertical: 12,
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       const Icon(
  //                         Icons.calendar_today_outlined,
  //                         color: AppColors.bodyText,
  //                         size: 15,
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Text(
  //                         controller.selectedDate.value == null
  //                             ? "mm/dd/yyyy"
  //                             : DateFormat(
  //                                 'MM/dd/yyyy',
  //                               ).format(controller.selectedDate.value!),
  //                         style: const TextStyle(
  //                           color: AppColors.bodyText,
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategoryGrid() {
    return Container(
      height: 350,
      color: Get.isDarkMode ? AppColors.darkBackground : AppColors.white,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final item = controller.categories[index];
          return Obx(() {
            final isSelected =
                controller.selectedCategory.value == item['title'];
            return GestureDetector(
              onTap: () => controller.selectCategory(item['title'] as String),
              child: Container(
                width: 171,
                height: 87,
                decoration: BoxDecoration(
                  boxShadow: _shadow,
                  color: isSelected
                      ? AppColors.actionGreen.withOpacity(0.08)
                      : Get.isDarkMode
                      ? AppColors.darkCard
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected
                        ? Get.isDarkMode
                              ? AppColors.mintAccent
                              : AppColors.actionGreen
                        : Get.isDarkMode
                        ? AppColors.darkCard
                        : AppColors.grey200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 26,
                      color: isSelected
                          ? Get.isDarkMode
                                ? AppColors.mintAccent
                                : AppColors.actionGreen
                          : Get.isDarkMode
                          ? AppColors.white
                          : AppColors.black,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? Get.isDarkMode
                                  ? AppColors.mintAccent
                                  : AppColors.actionGreen
                            : Get.isDarkMode
                            ? AppColors.white
                            : AppColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.blackOverlay10,
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: -2.0,
            ),
            BoxShadow(
              color: AppColors.blackOverlay10,
              offset: Offset(0.0, 4.0),
              blurRadius: 6.0,
              spreadRadius: -1.0,
            ),
          ],
        ),
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.saveBudget,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.isDarkMode
                ? AppColors.mintAccent
                : AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Get.isDarkMode ? AppColors.black : AppColors.white,
                  ),
                )
              : Text(
                  // Show "Update Goal" when editing, "Create Goal" when new
                  controller.editingBudgetId.value != null
                      ? 'Update Budget'
                      : 'Create Budget',
                  style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? AppColors.black : AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
