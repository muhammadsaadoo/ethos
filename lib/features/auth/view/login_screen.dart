import 'dart:ui';

import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:expence_management/features/auth/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================= SCREEN =======================
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,

          child: Stack(
            children: [
              // ================= GREEN CARD =================
              Positioned(
                top: 0,
                left: 0,
                right: 0,

                child: Container(
                  height: 353,

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.success],
                    ),

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primarySoft,
                        blurRadius: 30,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Stack(
                    children: [
                      // ================= BACKGROUND IMAGE (FIGMA SPEC) =================
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,

                        child: Center(
                          child: Opacity(
                            opacity: 0.5, // ✅ Figma opacity

                            child: Image.asset(
                              "assets/images/login_background_image.png",

                              width: 429,
                              height: 388,

                              fit: BoxFit.cover,

                              colorBlendMode:
                                  BlendMode.screen, // ✅ Figma blend mode
                            ),
                          ),
                        ),
                      ),

                      // ================= CONTENT =================
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            // LOGO
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blackOverlay10,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 12,
                                    sigmaY: 12,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.whiteSoft,
                                      border: Border.all(
                                        color: AppColors.whiteSoft,
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/images/login_logo.png",
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              "Securely access your portfolio",
                              style: TextStyle(
                                color: AppColors.mintAccent,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= WHITE FORM CARD =================
              Positioned(
                top: 330,
                left: 0,
                right: 0,
                bottom: 0,

                child: Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.blackOverlay08,
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ================= HEADINGS =================

                        // ================= EMAIL =================
                        const Text(
                          "Email Address",

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Obx(
                          () => buildTextField(
                            controller: controller.emailController,

                            hintText: "alex@example.com",

                            icon: Icons.email_outlined,

                            errorText: controller.emailError.value,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ================= PASSWORD =================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Password",

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},

                              child: Text(
                                "Forgot?",

                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Obx(
                          () => buildTextField(
                            controller: controller.passwordController,

                            hintText: "********",

                            icon: Icons.lock_outline,

                            obscureText: !controller.isPasswordVisible.value,

                            errorText: controller.passwordError.value,

                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isPasswordVisible.value =
                                    !controller.isPasswordVisible.value;
                              },

                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),

                        // const SizedBox(height: 10),

                        // ================= FORGOT PASSWORD =================
                        const SizedBox(height: 30),

                        // ================= LOGIN + FINGERPRINT =================
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => GestureDetector(
                                  onTap: controller.isLoading.value
                                      ? null
                                      : controller.login,

                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,

                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors
                                              .primarySoft, // #006C4926
                                          blurRadius: 20,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),

                                    child: Center(
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              width: 22,
                                              height: 22,

                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Get.isDarkMode
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            )
                                          : Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Login Securly",

                                                    style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Colors.black
                                                          : Colors.white,

                                                      fontSize: 16,

                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    color: Get.isDarkMode
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // ================= FINGERPRINT BUTTON =================
                            Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(14),

                              decoration: BoxDecoration(
                                // background: #E7E8E9
                                color: Get.isDarkMode
                                    ? AppColors.darkCard
                                    : AppColors.transparent,

                                // color: AppColors.transparent,
                                // AppColors.darkCard,
                                shape: BoxShape.circle,

                                // border: 1px solid #BBCABF33
                                border: Border.all(
                                  color: AppColors.inputHintSoft,
                                  width: 1,
                                ),

                                // box-shadow: 0px 1px 2px 0px #0000000D
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blackOverlay05,
                                    // color: Get.isDarkMode
                                    //     ? Colors.black
                                    //     : AppColors.blackOverlay05,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),

                              child: Icon(
                                Icons.fingerprint,

                                //background: #006C49;
                                color: Theme.of(context).primaryColor,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.inputHint,
                                thickness: 0.5,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),

                              child: Text(
                                "OR CONNECT VIA",

                                style: TextStyle(
                                  fontSize: 12,
                                  // color: AppColors.lightSecondaryText,
                                  color: Get.isDarkMode
                                      ? AppColors.darkSubtitle
                                      : AppColors.lightSecondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Divider(
                                color: Get.isDarkMode
                                    ? AppColors.darkSubtitle
                                    : AppColors.lightSecondaryText,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ================= GOOGLE BUTTON =================
                        socialButton(
                          text: "Continue with Google",
                          icon: Icons.g_mobiledata,
                        ),

                        const SizedBox(height: 14),

                        // ================= APPLE BUTTON =================
                        socialButton(
                          text: "Continue with Apple",
                          icon: Icons.apple,
                        ),

                        // const SizedBox(height: 30),

                        // ================= CREATE ACCOUNT =================
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "Don't have an account? ",

                                style: TextStyle(
                                  // color: AppColors.lightSecondaryText,
                                  color: Get.isDarkMode
                                      ? AppColors.darkSubtitle
                                      : AppColors.lightSecondaryText,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  controller.goToSignup();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => SignupScreen(),
                                  //   ),
                                  // );
                                },

                                child: Text(
                                  "Create Account",

                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,

                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================= TEXTFIELD =======================

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        errorText: errorText != null && errorText.isNotEmpty ? errorText : null,

        // Only override what's different from the theme
        contentPadding: const EdgeInsets.symmetric(vertical: 16),

        // Override the border radius while keeping theme colors
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.transparent),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.expense),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
      ),
    );
  }

  // ======================= SOCIAL BUTTON =======================

  Widget socialButton({required String text, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkCard : AppColors.white,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: Get.isDarkMode ? AppColors.transparent : AppColors.borderMuted,
          width: 2,
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon),

          const SizedBox(width: 10),

          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
