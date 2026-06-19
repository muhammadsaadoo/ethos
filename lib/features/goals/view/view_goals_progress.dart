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
    AppColors.iconBgBlue,
    AppColors.iconBgGreen,
    AppColors.iconBgOrange,
    AppColors.iconBgPurple,
    AppColors.iconBgRed,
    AppColors.iconBgSky,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // backgroundColor: AppColors.pageBackground,
        backgroundColor: Get.isDarkMode
            ? Colors.black
            : AppColors.pageBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? Colors.white : AppColors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Goals',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.goals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag_outlined, size: 56, color: AppColors.grey),
                SizedBox(height: 12),
                Text(
                  'No goals yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create your first goal to get started',
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.goals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
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
              color: Theme.of(context).primaryColor,
              // color: Get.isDarkMode ? AppColors.white : AppColors.black,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            Get.toNamed(AppRoutes.creategoals);
          },
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0, // Handled by our custom Container decoration shadow
          icon: Icon(
            Icons.add,
            color: Get.isDarkMode ? Colors.black : AppColors.white,
          ),
          label: Text(
            'Create Goal', // Add your desired text string here
            style: TextStyle(
              color: Get.isDarkMode ? Colors.black : AppColors.white,
            ),
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
        backgroundColor: Get.isDarkMode ? AppColors.darkCard : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Goal',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${goal.goalName}"? This action cannot be undone.',
          style: TextStyle(
            color: Get.isDarkMode
                ? AppColors.darkSubtitle
                : AppColors.slateText,
            fontSize: 14,
          ),
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
    final goalCtrl = Get.find<GoalController>();
    goalCtrl.loadGoalForEdit(goal);
    Get.to(() => const CreateGoalScreen(), arguments: goal);
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
                child: Icon(icon, size: 22, color: AppColors.iconText),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '$_progressPercent%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? AppColors.mintAccent
                            : AppColors.neutralText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColors.slateText,
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
                              color: AppColors.iconText,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Edit Goal',
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
                              'Delete Goal',
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
            ],
          ),

          const SizedBox(height: 20),

          // Goal name
          Text(
            goal.goalName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Get.isDarkMode ? Colors.white : AppColors.black,
            ),
          ),

          const SizedBox(height: 2),

          // Category + deadline
          Row(
            children: [
              Text(
                goal.category,
                style: TextStyle(
                  fontSize: 13,
                  color: Get.isDarkMode
                      ? AppColors.darkSubtitle
                      : AppColors.headingText,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.disabledText,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM d, yyyy').format(goal.deadline),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.disabledText,
                ),
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
              backgroundColor: Get.isDarkMode
                  ? AppColors.black.withAlpha(200)
                  : AppColors.borderMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                Get.isDarkMode ? AppColors.mintAccent : AppColors.primary,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppColors.darkSubtitle
                      : AppColors.black,
                ),
              ),
              Text(
                'of \$${_format(goal.targetAmount)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.disabledText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
