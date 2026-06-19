import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/goals/controller/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateGoalScreen extends GetView<GoalController> {
  const CreateGoalScreen({super.key});

  static const Color reusablecolor = AppColors.slateText;

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
        ),
        title: Obx(
          () => Text(
            controller.editingGoalId.value != null ? 'Edit Goal' : 'New Goal',
            style: const TextStyle(color: AppColors.black, fontSize: 16),
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
              const SizedBox(height: 20),
              _buildGoalNameField(),
              const SizedBox(height: 16),
              _buildDateField(context),
              const SizedBox(height: 24),
              const Text(
                "Category",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(),
              const SizedBox(height: 16),
              _buildInitialContribution(),
              const SizedBox(height: 32),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: _shadow,
      ),
      child: Column(
        children: [
          const Text(
            "TARGET AMOUNT",
            style: TextStyle(
              color: reusablecolor,
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
                const Text(
                  "\$ ",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppColors.actionGreen,
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
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.actionGreen,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "10,000",
                      hintStyle: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
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

  Widget _buildGoalNameField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: _shadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Goal Name",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: reusablecolor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: controller.goalNameController,
                decoration: const InputDecoration(
                  hintText: "European Tour",
                  hintStyle: TextStyle(color: AppColors.bodyText, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                style: const TextStyle(color: AppColors.blackOverlay87),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter goal name';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: _shadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Target Date",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: reusablecolor,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => controller.pickDate(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.bodyText,
                          size: 15,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          controller.selectedDate.value == null
                              ? "mm/dd/yyyy"
                              : DateFormat(
                                  'MM/dd/yyyy',
                                ).format(controller.selectedDate.value!),
                          style: const TextStyle(
                            color: AppColors.bodyText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      height: 226,
      color: AppColors.white,
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
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.actionGreen
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
                          ? AppColors.actionGreen
                          : reusablecolor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.actionGreen
                            : reusablecolor,
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

  Widget _buildInitialContribution() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Initial Contribution",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.bodyText,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Optional starting amount",
                style: TextStyle(color: reusablecolor, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 128,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Text(
                  "\$",
                  style: TextStyle(
                    color: reusablecolor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextFormField(
                    controller: controller.initialContributionController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.neutralText,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: "0.00",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (double.tryParse(value) == null) return 'Invalid';
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
          onPressed: controller.isLoading.value ? null : controller.createGoal,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  // Show "Update Goal" when editing, "Create Goal" when new
                  controller.editingGoalId.value != null
                      ? 'Update Goal'
                      : 'Create Goal',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
