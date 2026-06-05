import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/transaction/controller/add_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'add_transaction_controller.dart'; // uncomment in your project

// ─────────────────────────────────────────────────────────────────────────────
//  Design tokens
// ─────────────────────────────────────────────────────────────────────────────
const _bg = Color(0xFF0F0F14);
const _surface = Color(0xFF1A1A24);
const _surfaceAlt = Color(0xFF22222F);
const _accent = Color(0xFF6C63FF);
const _accentSoft = Color(0x336C63FF);
const _income = Color(0xFF22C55E);
const _expense = Color(0xFFEF4444);
const _textPri = Color(0xFFFFFFFF);
const _textSec = Color(0xFF8E8EA0);
const _border = Color(0xFF2E2E3E);

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────
class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final ctrl = Get.put(AddTransactionController());

    return Scaffold(
      extendBody: false,
      // background: #FBFCFCCC;
      backgroundColor: const Color(0xFFF8F9FA),
      // ── App Bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        //         background: linear-gradient(0deg, #FFFFFF, #FFFFFF),
        // linear-gradient(0deg, #FBFCFC, #FBFCFC);
        backgroundColor: const Color(0xFFF8F9FA),

        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   color: _surface,
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: _border),
            // ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
        //     decoration: BoxDecoration(
        //       color: _accentSoft,
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     child: const Icon(Icons.history_rounded, color: _accent, size: 20),
        //   ),
        // ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _CardSelector(ctrl: ctrl),
            const SizedBox(height: 24),
            _TypeSwitcher(ctrl: ctrl),
            const SizedBox(height: 24),
            _AmountDisplay(ctrl: ctrl),
            const SizedBox(height: 24),
            _SpendingProgress(ctrl: ctrl),
            const SizedBox(height: 48),
            _CategoryRow(ctrl: ctrl),
            const SizedBox(height: 20),
            _NumPad(ctrl: ctrl),
            const SizedBox(height: 16),
            _ConfirmButton(ctrl: ctrl),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // ── Bottom Nav ────────────────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Card Selector
// ─────────────────────────────────────────────────────────────────────────────
class _CardSelector extends StatelessWidget {
  const _CardSelector({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 198,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),

        // background: #FFFFFF; border: 1px solid #EDEEEF
        border: Border.all(color: Color(0xFFEDEEEF)),
      ),
      child: Obx(
        () => Row(
          children: [
            Container(
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                //background: #DAE2FD;
                color: Color(0xFFDAE2FD),
                // borderRadius: BorderRadius.circular(),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.credit_card_rounded, size: 11),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Pay from',
                  //   style: TextStyle(color: _textSec, fontSize: 11),
                  // ),
                  const SizedBox(height: 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<CardModel>(
                      value: ctrl.selectedCard.value,
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      ),
                      style: const TextStyle(
                        color: _textPri,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      isDense: true,
                      items: ctrl.cards
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c.cardName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (c) {
                        if (c != null) ctrl.selectCard(c);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Expense / Income Switcher
// ─────────────────────────────────────────────────────────────────────────────
class _TypeSwitcher extends StatelessWidget {
  const _TypeSwitcher({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expense = ctrl.isExpense.value;
      return Container(
        height: 44,
        width: 240,
        decoration: BoxDecoration(
          // background: #EDEEEF;
          color: Color(0xFFEDEEEF),
          borderRadius: BorderRadius.circular(30),
          // border: Border.all(color: _border),
        ),
        // padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _SwitchTab(
              label: 'Expense',
              // icon: Icons.arrow_upward_rounded,
              active: expense,
              activeColor: AppColors.primary,
              onTap: () => ctrl.toggleExpense(true),
            ),
            _SwitchTab(
              label: 'Income',
              // icon: Icons.arrow_downward_rounded,
              active: !expense,
              activeColor: AppColors.primary,
              onTap: () => ctrl.toggleExpense(false),
            ),
          ],
        ),
      );
    });
  }
}

class _SwitchTab extends StatelessWidget {
  const _SwitchTab({
    required this.label,
    // required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });
  final String label;
  // final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 50,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              // border: active
              //     ? Border.all(color: activeColor.withOpacity(0.4))
              //     : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(icon, size: 16, color: active ? activeColor : _textSec),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Amount Display
// ─────────────────────────────────────────────────────────────────────────────
class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // final color = ctrl.isExpense.value ? _expense : _income;
      return Container(
        // width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // decoration: BoxDecoration(
        //   color: _surface,
        //   borderRadius: BorderRadius.circular(24),
        //   border: Border.all(color: _border),
        //   boxShadow: [
        //     BoxShadow(
        //       // color: color.withOpacity(0.12),
        //       blurRadius: 32,
        //       spreadRadius: 2,
        //     ),
        //   ],
        // ),
        child: Column(
          children: [
            // Text(
            //   // ctrl.isExpense.value ? 'Total Expense' : 'Total Income',
            //   style: const TextStyle(color: _textSec, fontSize: 13),
            // ),
            // const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\$${ctrl.amountDisplay}",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                        shadows: [
                          Shadow(
                            color: AppColors.primary.withAlpha(70),
                            blurRadius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Spending Progress Bar
// ─────────────────────────────────────────────────────────────────────────────
class _SpendingProgress extends StatelessWidget {
  const _SpendingProgress({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ratio = ctrl.progressRatio;
      final color = ratio > 0.8 ? _expense : AppColors.primary;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   '${(ratio * 100).toStringAsFixed(0)}% of \$${ctrl.spendingLimit.value.toStringAsFixed(0)}',
                //   style: TextStyle(
                //     color: color,
                //     fontSize: 12,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
            // const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 7,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Category Row
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            ...ctrl.defaultCategories.map(
              (cat) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CategoryChip(
                    label: cat['label'] as String,
                    icon: IconData(
                      cat['icon'] as int,
                      fontFamily: 'MaterialIcons',
                    ),
                    selected: ctrl.selectedCategory.value == cat['label'],
                    onTap: () => ctrl.selectCategory(cat['label'] as String),
                  ),
                ),
              ),
            ),
            // "More" button — identical layout to _CategoryChip
            Expanded(
              child: GestureDetector(
                onTap: () => Get.toNamed('/categories'),
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFEDEEEF)),
                      ),
                      child: const Icon(
                        Icons.apps_rounded,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'More',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.white,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(30),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
              border: Border.all(
                color: selected ? AppColors.primary : Color(0xFFEDEEEF),
              ),
            ),
            child: Icon(icon, color: selected ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Custom NumPad
// ─────────────────────────────────────────────────────────────────────────────
class _NumPad extends StatelessWidget {
  const _NumPad({required this.ctrl});
  final AddTransactionController ctrl;

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', 'backspace'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        // borderRadius: BorderRadius.circular(24),
        // border: Border.all(color: _border),
      ),
      child: Column(
        // spacing: 10,
        children: _keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              spacing: 10,
              children: row.map((key) {
                final isBack = key == 'backspace';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => ctrl.onKeypadTap(key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          // borderRadius: BorderRadius.circular(14),
                          // border: Border.all(
                          //   color: isBack ? _accent.withOpacity(0.3) : _border,
                          // ),
                        ),
                        alignment: Alignment.center,
                        child: isBack
                            ? const Icon(
                                Icons.backspace_outlined,
                                color: Colors.black,
                                size: 24,
                              )
                            : Text(
                                key,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Confirm Button
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.ctrl});
  final AddTransactionController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = ctrl.isLoading.value;
      return GestureDetector(
        onTap: loading ? null : ctrl.confirmTransaction,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.primary,
            // gradient: LinearGradient(colors: AppColors.primary),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(100),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      'Confirm Transaction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F9FA),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          // border: const Border(top: BorderSide(color: _border)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavItem(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Wealth',
            ),
            _NavItem(icon: Icons.bar_chart_rounded, label: 'Activity'),
            _NavItem(
              icon: Icons.swap_horiz_rounded,
              label: 'Transact',
              active: true,
            ),
            _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });
  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: active
              ? BoxDecoration(
                  //background: #10B9814D;
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? AppColors.primary : _textSec,
                size: 22,
              ),
              Text(
                label,
                style: TextStyle(
                  color: active ? AppColors.primary : Colors.black,
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}
