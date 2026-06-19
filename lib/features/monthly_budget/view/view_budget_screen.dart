import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/monthly_budget/controller/budget_controller.dart';
import 'package:expence_management/features/monthly_budget/model/budget_model.dart';
import 'package:expence_management/features/monthly_budget/view/create_budget_screen.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewBudgetScreen extends GetView<BudgetController> {
  const ViewBudgetScreen({super.key});

  static const List<Color> _iconBgColors = [
    AppColors.iconBgBlue,
    AppColors.iconBgGreen,
    AppColors.iconBgOrange,
    AppColors.iconBgPurple,
    AppColors.iconBgRed,
    AppColors.iconBgSky,
  ];

  String _formatMonth(String value) {
    if (value.contains('-')) {
      final parts = value.split('-');
      if (parts.length == 2) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        if (year != null && month != null) {
          return DateFormat('MMMM yyyy').format(DateTime(year, month));
        }
      }
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   centerTitle: true,
      //   backgroundColor: AppColors.pageBackground,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: AppColors.black),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: const Text(
      //     'My Budgets',
      //     style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
      //   ),
      // ),
      body: SafeArea(
        child: Obx(() {
          final budgets = controller.currentMonthBudgets;

          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 56,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No budgets yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Create your first budget to get started',
                    style: TextStyle(fontSize: 13, color: AppColors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              SizedBox(height: 12),
              Text(
                "My Budgets",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              //background: #3C4A42;
              SizedBox(height: 8),
              Text(
                "Track Your spendings against your budget",
                style: TextStyle(
                  fontSize: 16,
                  // color: AppColors.lightSecondaryText,
                  color: Get.isDarkMode
                      ? AppColors.darkSubtitle
                      : AppColors.lightSecondaryText,
                ),
              ),
              SizedBox(height: 24),
              _buildSummaryCard(),
              const SizedBox(height: 20),
              // _buildProgressCard(),
              const SizedBox(height: 20),
              ...List.generate(budgets.length, (index) {
                final budget = budgets[index];
                final iconBg = _iconBgColors[index % _iconBgColors.length];
                final icon =
                    controller.categoryIcons[budget.category] ??
                    Icons.category_rounded;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BudgetCard(
                    budget: budget,
                    icon: icon,
                    iconBgColor: iconBg,
                    progress: controller.getBudgetProgress(budget),
                    spent: controller.getSpentForBudget(budget),
                    formattedMonth: _formatMonth(budget.month),
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                // color: AppColors.primary.withAlpha(150),
                color: Theme.of(context).primaryColor.withAlpha(150),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              Get.toNamed(AppRoutes.createbudget);
            },
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            icon: Icon(
              Icons.add,
              color: Get.isDarkMode ? AppColors.black : AppColors.white,
            ),
            label: Text(
              'Create Budget',
              style: TextStyle(
                color: Get.isDarkMode ? AppColors.black : AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Monthly Budget',
            style: TextStyle(
              fontSize: 14,
              // color: AppColors.slateText,
              //background: #3C4A42;
              color: Get.isDarkMode
                  ? AppColors.darkSubtitle
                  : AppColors.slateText,

              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "\$${controller.totalMonthlySpending}",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppColors.mintAccent
                      : AppColors.black,
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "/ \$${controller.totalMonthlyBudget}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode
                        ? AppColors.white
                        : AppColors.slateText,
                  ),
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                //background: #10B9811A;
                width: 78,
                height: 32,
                decoration: BoxDecoration(
                  // color: AppColors.successSoft,
                  color: Get.isDarkMode
                      ? AppColors.black
                      : AppColors.successSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(controller.monthlyProgress * 100).round()}% spent',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    // color: Get.isDarkMode ? AppColors.white : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: controller.monthlyProgress,
                  backgroundColor: Get.isDarkMode
                      ? AppColors.black.withAlpha(200)
                      : AppColors.borderMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.totalMonthlySpending >
                            controller.totalMonthlyBudget
                        ? AppColors.red
                        : Get.isDarkMode
                        ? AppColors.mintAccent
                        : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${NumberFormat('#,##0', 'en_US').format(0)}',
                    style: const TextStyle(color: AppColors.disabledText),
                  ),

                  Text(
                    controller.totalMonthlySpending >
                            controller.totalMonthlyBudget
                        ? '\$${NumberFormat('#,##0', 'en_US').format(controller.totalMonthlySpending - controller.totalMonthlyBudget)} Over'
                        : '\$${NumberFormat('#,##0', 'en_US').format(controller.totalMonthlyBudget - controller.totalMonthlySpending)} Remaining',
                    style: TextStyle(
                      color:
                          controller.totalMonthlySpending >
                              controller.totalMonthlyBudget
                          ? AppColors.red
                          : AppColors.disabledText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     _SummaryItem(
          //       label: '',
          //       amount: controller.totalMonthlyBudget,
          //       color: AppColors.actionGreen,
          //     ),
          //     _SummaryItem(
          //       label: '',
          //       amount: controller.totalMonthlySpending,
          //       color: const Color(0xffEF4444),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Get.isDarkMode ? AppColors.white : AppColors.bodyText,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _formatMonth(controller.selectedMonth.value),
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode
                      ? AppColors.darkSubtitle
                      : AppColors.bodyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildProgressCard() {
  //   return
  // }
}

// class _SummaryItem extends StatelessWidget {
//   final String label;
//   final double amount;
//   final Color color;

//   const _SummaryItem({
//     required this.label,
//     required this.amount,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 13, color: AppColors.slateText),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '\$${NumberFormat('#,##0', 'en_US').format(amount)}',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final IconData icon;
  final Color iconBgColor;
  final double progress;
  final double spent;
  final String formattedMonth;

  const _BudgetCard({
    required this.budget,
    required this.icon,
    required this.iconBgColor,
    required this.progress,
    required this.spent,
    required this.formattedMonth,
  });

  String _format(double amount) =>
      NumberFormat('#,##0', 'en_US').format(amount);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Budget',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the ${budget.category} budget? This action cannot be undone.',
          style: TextStyle(
            color: Get.isDarkMode ? AppColors.white : AppColors.slateText,
            fontSize: 14,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Get.isDarkMode
                      ? AppColors.mintAccent
                      : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Get.isDarkMode ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                final controller = Get.find<BudgetController>();
                controller.deleteBudget(budget);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.destructive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEdit() {
    final controller = Get.find<BudgetController>();
    controller.loadBudgetForEdit(budget);
    Get.to(() => const CreateBudgetScreen(), arguments: budget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(icon, size: 22, color: AppColors.iconText),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      budget.category,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Get.isDarkMode
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Get.isDarkMode ? AppColors.white : AppColors.slateText,
                  size: 20,
                ),
                color: Get.isDarkMode ? AppColors.black : AppColors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _openEdit();
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Get.isDarkMode
                              ? AppColors.white
                              : AppColors.iconText,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Edit Budget',
                          style: TextStyle(
                            fontSize: 14,
                            color: Get.isDarkMode
                                ? AppColors.white
                                : AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.destructive,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete Budget',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.destructive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                "\$${_format(spent)}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppColors.mintAccent
                      : AppColors.black,
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "/ \$${budget.targetAmount}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode
                        ? AppColors.white
                        : AppColors.slateText,
                  ),
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 16),
              Text(
                '${((spent / budget.targetAmount) * 100).toStringAsFixed(0)}% of budget used',
                style: TextStyle(
                  fontSize: 13,
                  // color: AppColors.disabledText,
                  color: Get.isDarkMode
                      ? AppColors.primary
                      : AppColors.disabledText,
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progress,
                  backgroundColor: Get.isDarkMode
                      ? AppColors.black.withAlpha(200)
                      : AppColors.borderMuted,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spent > budget.targetAmount
                        ? AppColors.red
                        : Get.isDarkMode
                        ? AppColors.mintAccent
                        : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   '\$${NumberFormat('#,##0', 'en_US').format(0)}',
                  //   style: const TextStyle(color: AppColors.disabledText),
                  // ),
                  // Text(
                  //   '\$${_format(budget.targetAmount - spent)} left',
                  //   style: const TextStyle(
                  //     fontSize: 13,
                  //     color: AppColors.disabledText,
                  //   ),
                  // ),
                  Text(
                    spent > budget.targetAmount
                        ? '\$${NumberFormat('#,##0', 'en_US').format(spent - budget.targetAmount)} Over'
                        : '\$${NumberFormat('#,##0', 'en_US').format(budget.targetAmount - spent)} Remaining',
                    style: TextStyle(
                      color: spent > budget.targetAmount
                          ? AppColors.red
                          : AppColors.disabledText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Text(
          //       formattedMonth,
          //       style: const TextStyle(fontSize: 13, color: AppColors.headingText),
          //     ),
          //     const SizedBox(width: 8),
          //     Container(
          //       width: 3,
          //       height: 3,
          //       decoration: const BoxDecoration(
          //         color: AppColors.disabledText,
          //         shape: BoxShape.circle,
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       '\$${_format(spent)} spent',
          //       style: const TextStyle(fontSize: 13, color: AppColors.disabledText),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 16),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(100),
          //   child: LinearProgressIndicator(
          //     value: progress,
          //     minHeight: 6,
          //     backgroundColor: AppColors.borderMuted,
          //     valueColor: const AlwaysStoppedAnimation<Color>(
          //       AppColors.primary,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '\$${_format(spent)}',
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //         color: AppColors.black,
          //       ),
          //     ),
          //     Text(
          //       'of \$${_format(budget.targetAmount)}',
          //       style: const TextStyle(fontSize: 13, color: AppColors.disabledText),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
