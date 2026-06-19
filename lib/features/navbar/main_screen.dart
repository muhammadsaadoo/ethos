import 'package:expence_management/core/services/theme_controller.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/home/view/home_screen.dart';
import 'package:expence_management/features/monthly_budget/view/view_budget_screen.dart';
import 'package:expence_management/features/navbar/controller/nav_controller.dart';
import 'package:expence_management/features/navbar/glass_app_bar.dart';
import 'package:expence_management/features/profile/view/profile_screen.dart';
import 'package:expence_management/features/transaction/view/transaction_screen.dart';
// import 'package:expence_management/features/navbar/navbar_controller.dart'; // Import your controller
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package

class MainScreen extends GetView {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Locate the injected controller dependency
    final NavController controller = Get.find<NavController>();

    final List<Widget> screens = [
      HomeScreen(),
      TransactionScreen(),
      // const Center(child: Text("Analytics Screen")),
      ViewBudgetScreen(),
      // const Center(child: Text("Profile Screen")),
      ProfileScreen(),
    ];

    // final List<Widget> screens = const [
    //   HomeScreen(),
    //   TransactionsScreen(),
    //   AnalyticsScreen(),
    //   ProfileScreen(),
    // ];

    return Obx(() {
      final themeController = Get.find<ThemeController>();
      return Scaffold(
        // backgroundColor: AppColors.lightBackground,
        backgroundColor: themeController.isDarkMode.value
            ? AppColors.black
            : AppColors.lightBackground,

        extendBody:
            true, // Allows your body screens to render beautifully behind custom rounded bars
        appBar: const GlassAppBar(),

        // 2. Wrap body in Obx so the active screen flips seamlessly when the index updates
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: screens,
            ),
          ),
        ),

        // ================= CUSTOM NAVBAR =================
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value
                ? AppColors.black
                : AppColors.lightBackgroundGlass,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackOverlay12,
                blurRadius: 15,
                spreadRadius: 2,
                offset: Offset(0, -5),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 24,
          ), // Added extra bottom safety padding for modern notch devices
          // 3. Wrap Row in Obx to instantly repaint active/inactive item text and icon color shades
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Icon
                navItem(Icons.home, "Home", 0, controller),
                navItem(
                  Icons.account_balance_wallet_outlined,
                  "Transactions",
                  1,
                  controller,
                ),
                navItem(Icons.auto_graph, "Analytics", 2, controller),
                navItem(Icons.person_2_outlined, "Profile", 3, controller),
              ],
            ),
          ),
        ),
      );
    });
  }

  // 4. Pass the controller instance into the helper nav item builder
  Widget navItem(
    IconData icon,
    String label,
    int index,
    NavController controller,
  ) {
    bool isSelected = controller.selectedIndex.value == index;
    final isDark = Get.find<ThemeController>().isDarkMode.value;

    return GestureDetector(
      onTap: () => controller.updateIndex(
        index,
      ), // 5. Update index via controller state method
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,

              //background: #3C4A42;
              color: isSelected
                  ? (isDark ? AppColors.mintAccent : AppColors.primary)
                  : (isDark ? AppColors.white : AppColors.lightSecondaryText),
              // : AppColors.lightSecondaryText,
              shadows: isSelected
                  ? [
                      Shadow(
                        // color: AppColors.glowGreenSoft,
                        color: isDark
                            ? AppColors.mintAccent
                            : AppColors.glowGreenSoft,
                        blurRadius: 40,
                      ),
                    ]
                  : [],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isDark ? AppColors.mintAccent : AppColors.primary)
                    : (isDark ? AppColors.white : AppColors.lightSecondaryText),
                // color: isSelected
                //     ? AppColors.primary
                //     : AppColors.lightSecondaryText,
                fontWeight: FontWeight.w600,
                shadows: isSelected
                    ? [
                        Shadow(
                          // color: AppColors.glowGreenSoft,
                          color: isDark
                              ? AppColors.glowGreenLight
                              : AppColors.glowGreenSoft,
                          blurRadius: 8.0,
                          offset: Offset.zero,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
