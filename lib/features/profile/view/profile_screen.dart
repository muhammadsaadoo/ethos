import 'package:expence_management/core/services/theme_controller.dart';
import 'package:expence_management/core/utils/shared_widgets/custom_card.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/auth/services/user_session_service.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // ================= PROFILE =================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      "assets/images/user_profile.png",
                    ),
                  ),

                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                "Muhammad Saad",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "saad@gmail.com",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                width: 191,
                height: 31,
                decoration: BoxDecoration(
                  //background: #FCFAF4;
                  color: const Color(0xFFFCFAF4),
                  borderRadius: BorderRadius.circular(30),
                  // Added a border with a width of 10
                  border: Border.all(
                    //border: 1px solid #EEE4CE
                    color: const Color(
                      0xFFEEE4CE,
                    ), // Change this to your preferred border color
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Row(
                    spacing: 10,
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.star, size: 14, color: Color(0xFFB08D44)),
                      Text(
                        "ETHOS GOLD MEMBER",

                        //background: #B08D44;
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB08D44),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ================= ACCOUNT =================
              _SectionTitle(title: "Account"),

              CustomCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: const [
                    _ArrowTile(
                      //background: #006C491A;
                      icon: Icons.person_outline,
                      title: "personal Info",
                      subtitle: "Manage Your Identity and details",
                      iconBgColor: Color(0x1A006C49),
                      iconColor: AppColors.primary,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(),
                    ),
                    // Divider(),
                    _ArrowTile(
                      icon: Icons.security_outlined,
                      title: "Security",
                      subtitle: "Password & protection",
                      iconBgColor: Color(0x4DDAE2FD),
                      iconColor: Color(0xFF494BD6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ================= ACCOUNT =================
              _SectionTitle(title: "Goals"),

              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.viewgoals),
                child: Container(
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: const [
                        _ArrowTile(
                          //background: #006C491A;
                          icon: Icons.person_outline,
                          title: "View Goals",
                          subtitle: "Manage Expence Through creaeting Goals",
                          iconBgColor: Color(0x1A006C49),
                          iconColor: AppColors.primary,
                        ),

                        // Divider(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= PREFERENCES =================
              _SectionTitle(title: "Preferences"),

              CustomCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        //Icon
                        buildCircleIcon(context, Icons.currency_exchange),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Currency",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DropdownButton<String>(
                          value: "USD",
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: "USD", child: Text("USD")),
                            DropdownMenuItem(value: "PKR", child: Text("PKR")),
                            DropdownMenuItem(value: "EUR", child: Text("EUR")),
                          ],
                          onChanged: (value) {},
                        ),
                      ],
                    ),

                    const Divider(),

                    Row(
                      children: [
                        buildCircleIcon(
                          context,
                          Icons.notifications_on_outlined,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Notifications",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Switch(value: true, onChanged: (value) {}),
                      ],
                    ),

                    const Divider(),

                    Obx(() {
                      final themeController = Get.find<ThemeController>();
                      return Row(
                        children: [
                          buildCircleIcon(context, Icons.dark_mode_outlined),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Dark Mode",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                          Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= SUPPORT =================
              _SectionTitle(title: "Support"),

              CustomCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Column(
                  children: [
                    _ArrowTile(
                      icon: Icons.download_outlined,
                      title: "Data & Privacy",
                      subtitle: "Download Your Transaction hostory",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= LOGOUT =================
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: GestureDetector(
                  onTap: () async {
                    // logout action here
                    await Get.find<UserSessionService>().logout();
                  },
                  // borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodySmall?.color;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 8),

        //background: #565E74;
        child: Text(title, style: TextStyle(fontSize: 12, color: color)),
      ),
    );
  }
}

class _ArrowTile extends StatelessWidget {
  const _ArrowTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconBgColor = const Color(0xFFF5F6F8),
    this.iconColor = Colors.black87,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: iconBgColor,
          // border: Border.all(color: theme.dividerColor),
        ),
        child: Center(child: Icon(icon, size: 22, color: iconColor)),
      ),

      //background: #191C1D;
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
      ),

      //background: #565E74;
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 13,
        ),
      ),

      //background: #E1E3E4;
      trailing: Icon(Icons.chevron_right, color: theme.dividerColor),
    );
  }
}

Widget buildCircleIcon(BuildContext context, IconData icon, {Color? bg}) {
  // final theme = Theme.of(context);
  // final defaultBg = bg ?? theme.cardColor;
  // final iconColor = theme.iconTheme.color;
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Get.isDarkMode
          ? Colors.black
          : Color(0xFFF3F4F5), //background: #F3F4F5;
      // border: Border.all(color: theme.dividerColor),
    ),
    child: Center(
      child: Icon(
        icon,
        size: 20,
        color: Get.isDarkMode ? Colors.white : AppColors.black,
      ),
    ),
  );
}
