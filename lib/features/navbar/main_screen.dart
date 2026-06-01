import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/home/view/home_screen.dart';
import 'package:expence_management/features/navbar/controller/nav_controller.dart';
import 'package:expence_management/features/navbar/glass_app_bar.dart';
// import 'package:expence_management/features/navbar/navbar_controller.dart'; // Import your controller
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Locate the injected controller dependency
    final NavController controller = Get.find<NavController>();

    final List<Widget> screens = [
      HomeScreen(),
      const Center(child: Text("Transactions Screen")),
      const Center(child: Text("Analytics Screen")),
      const Center(child: Text("Profile Screen")),
    ];

    // final List<Widget> screens = const [
    //   HomeScreen(),
    //   TransactionsScreen(),
    //   AnalyticsScreen(),
    //   ProfileScreen(),
    // ];

    return Scaffold(
      backgroundColor: Color(0XFFF8F9FA),
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
        decoration: const BoxDecoration(
          color: Color(0xCCF8F9FA),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
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
  }

  // 4. Pass the controller instance into the helper nav item builder
  Widget navItem(
    IconData icon,
    String label,
    int index,
    NavController controller,
  ) {
    bool isSelected = controller.selectedIndex.value == index;

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
              color: isSelected ? AppColors.primary : Color(0xFF3C4A42),
              shadows: isSelected
                  ? [const Shadow(color: Color(0x804EDEA3), blurRadius: 40)]
                  : [],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Color(0xFF3C4A42),
                fontWeight: FontWeight.w600,
                shadows: isSelected
                    ? [
                        const Shadow(
                          color: Color(0x804EDEA3),
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
