import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/goals/controller/goal_controller.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/goals/view/create_goal_screen.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewGoalsProgress extends GetView<GoalController> {
  const ViewGoalsProgress({super.key});

  static const List<Color> _iconBgColors = [
    Color(0xffEAEEF9),
    Color(0xffEAF4F0),
    Color(0xffFFF4E5),
    Color(0xffF3EAFD),
    Color(0xffFFEAEA),
    Color(0xffE5F6FF),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffF7F7F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Goals',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.goals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag_outlined, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No goals yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create your first goal to get started',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.goals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final goal = controller.goals[index];
            final iconBg = _iconBgColors[index % _iconBgColors.length];
            final icon =
                controller.categoryIcons[goal.category] ?? Icons.flag_rounded;
            return _GoalCard(goal: goal, icon: icon, iconBgColor: iconBg);
          },
        );
      }),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(150),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed(AppRoutes.creategoals);
          },
          backgroundColor: AppColors.primary,
          elevation: 0, // Handled by our custom Container decoration shadow
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Create Goal', // Add your desired text string here
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  final GoalModel goal;
  final IconData icon;
  final Color iconBgColor;

  const _GoalCard({
    required this.goal,
    required this.icon,
    required this.iconBgColor,
  });

  double get _progress =>
      (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
  int get _progressPercent => (_progress * 100).round();

  String _format(double amount) =>
      NumberFormat('#,##0', 'en_US').format(amount);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Goal',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          'Are you sure you want to delete "${goal.goalName}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF6C7A71), fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          // Cancel
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE1E3E4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Delete
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                final goalCtrl = Get.find<GoalController>();
                goalCtrl.deleteGoal(goal);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
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
    final goalCtrl = Get.find<GoalController>();
    goalCtrl.loadGoalForEdit(goal);
    Get.to(() => const CreateGoalScreen(), arguments: goal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: icon  +  percentage + 3-dots menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon, size: 22, color: const Color(0xff4A5568)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '$_progressPercent%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF6C7A71),
                      size: 20,
                    ),
                    color: Colors.white,
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
                          children: const [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: Color(0xFF4A5568),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Edit Goal',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF191C1D),
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
                              color: Color(0xFFE53935),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Delete Goal',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE53935),
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

          const SizedBox(height: 20),

          // Goal name
          Text(
            goal.goalName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 2),

          // Category + deadline
          Row(
            children: [
              Text(
                goal.category,
                style: const TextStyle(fontSize: 13, color: Color(0xFF26282B)),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xff9CA3AF),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM d, yyyy').format(goal.deadline),
                style: const TextStyle(fontSize: 13, color: Color(0xff9CA3AF)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: const Color(0xffE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Saved / Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_format(goal.savedAmount)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'of \$${_format(goal.targetAmount)}',
                style: const TextStyle(fontSize: 13, color: Color(0xff9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
