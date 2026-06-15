import 'dart:async';

import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/transaction/controller/transaction_controller.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends GetView<TransactionController> {
  const TransactionScreen({super.key});

  String _getMonthName(int monthNumber) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[monthNumber - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Cards",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.createcard);
                    },
                    child: const Text("Add Card"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ================= CARDS (TEMP PLACEHOLDER) =================
              SizedBox(
                height: 190,
                child: Obx(() {
                  if (controller.cards.isEmpty) {
                    return const Center(child: Text("No cards available"));
                  }

                  return PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.cards.length,
                    onPageChanged: (index) {
                      controller.selectedCardIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      final card = controller.cards[index];

                      final last4 = card.cardNumber.length >= 4
                          ? card.cardNumber.substring(
                              card.cardNumber.length - 4,
                            )
                          : card.cardNumber;

                      return AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: controller.selectedCardIndex.value == index
                            ? 1
                            : 0.92,
                        child: yourCardWidget(card, last4),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.cards.length, (index) {
                    final isActive =
                        controller.selectedCardIndex.value == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isActive ? 20 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                );
              }),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(controller.filters.length, (index) {
                  final label = controller.filters[index];

                  return Obx(() {
                    final isSelected = controller.selectedFilter.value == label;

                    return filterItem(
                      icon: controller.filterIcons[label] ?? Icons.help_outline,
                      text: label,
                      isSelected: isSelected,
                      onTap: () {
                        controller.selectedFilter.value = label;
                      },
                    );
                  });
                }),
              ),

              const SizedBox(height: 20),

              // ================= RECENT HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.search),
                ],
              ),

              const SizedBox(height: 10),

              // ================= TRANSACTIONS =================
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: controller.cardTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = controller.cardTransactions[index];

                      return AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),

                          child: SwipeTransactionCard(
                            key: ValueKey(tx.id),
                            cardId: tx.id,
                            openCardId: controller.openCardId,
                            onEdit: () => controller.editTransaction(tx),
                            onDelete: () async {
                              final result = await Get.dialog<bool>(
                                AlertDialog(
                                  title: const Text('Delete Transaction'),
                                  content: const Text(
                                    'Are you sure you want to delete this transaction?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (result == true) {
                                controller.deleteTransaction(tx);

                                Get.snackbar(
                                  'Deleted',
                                  'Transaction removed successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },

                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D565E74),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // ICON
                                  Container(
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                      color: tx.isExpense
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      controller.getCategoryIcon(tx.category),
                                      color: tx.isExpense
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // TITLE + DATE
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.category,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          // 1. Get the 3-letter month abbreviation and the day number
                                          '${_getMonthName(tx.date.month)} ${tx.date.day}',
                                          style: const TextStyle(
                                            fontSize: 12,

                                            // background: #565E74;
                                            color: Color(0xFF565E74),
                                          ),
                                        ),

                                        Text(
                                          DateFormat('hh:mm a').format(
                                            tx.date,
                                          ), // Shows time like 10:30 AM
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // AMOUNT
                                  Text(
                                    "\$${tx.amount}",
                                    style: TextStyle(
                                      color: tx.isExpense
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ================= BUTTON =================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "View All Activity",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SINGLE FILTER ITEM =================
  Widget filterItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 88,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0D565E74),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // INNER CIRCLE (ONLY THIS CHANGES)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                //background: #10B9811A;
                color: isSelected
                    ? const Color(0xFF10B981).withAlpha(30)
                    //background: #EDEEEF;
                    : const Color(0xFFEDEEEF),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            // TEXT changes color only
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String lable;

  const _ActionIcon({required this.icon, required this.lable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // alignment: Alignment.center,
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              Text(lable, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class SwipeTransactionCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String cardId;
  final Rxn<String> openCardId;

  const SwipeTransactionCard({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    required this.cardId,
    required this.openCardId,
  });

  @override
  State<SwipeTransactionCard> createState() => _SwipeTransactionCardState();
}

class _SwipeTransactionCardState extends State<SwipeTransactionCard>
    with SingleTickerProviderStateMixin {
  double offsetX = 0;

  late AnimationController _controller;
  Animation<double>? _animation;
  late StreamSubscription _openCardSubscription;

  final double maxSwipe = 70;
  final double threshold = 45;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    /// Listen for changes to openCardId
    /// If another card opens, reset this card
    _openCardSubscription = widget.openCardId.listen((openId) {
      if (openId != null && openId != widget.cardId && offsetX != 0) {
        reset();
      }
    });
  }

  void animateTo(double target) {
    _animation =
        Tween(begin: offsetX, end: target).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {
            offsetX = _animation!.value;
          });
        });

    _controller.forward(from: 0);
  }

  void reset() => animateTo(0);
  void openLeft() => animateTo(maxSwipe);
  void openRight() => animateTo(-maxSwipe);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ================= BACKGROUND =================
        Positioned.fill(
          child: Row(
            children: [
              // LEFT (EDIT)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      // reset();
                      widget.onEdit();
                      reset();
                    },
                    child: const _ActionIcon(icon: Icons.edit, lable: 'Edit'),
                  ),
                ),
              ),

              // RIGHT (DELETE)
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      // reset();
                      widget.onDelete();
                      reset();
                    },
                    child: const _ActionIcon(
                      icon: Icons.delete,
                      lable: 'Delete',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ================= FOREGROUND =================
        Transform.translate(
          offset: Offset(offsetX, 0),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                offsetX += details.delta.dx;

                if (offsetX > maxSwipe) offsetX = maxSwipe;
                if (offsetX < -maxSwipe) offsetX = -maxSwipe;
              });
            },

            onHorizontalDragEnd: (_) {
              if (offsetX > threshold) {
                widget.openCardId.value = widget.cardId;
                openLeft();
              } else if (offsetX < -threshold) {
                widget.openCardId.value = widget.cardId;
                openRight();
              } else {
                reset();
                widget.openCardId.value = null;
              }
            },

            child: widget.child,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _openCardSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }
}

Widget yourCardWidget(card, last4) {
  return Container(
    width: 380,
    margin: const EdgeInsets.only(right: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Color(0xFF2E3132), Color(0xFF006C49)],
      ),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Available Balance",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Icon(Icons.credit_card, color: Colors.white),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "\$${card.totalAmount}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "**** **** **** $last4",
              style: const TextStyle(color: Colors.white70, letterSpacing: 2),
            ),
            const Text(
              "VISA",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        Text(card.cardHolderName, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}
