import 'package:expence_management/features/auth/view/login_screen.dart';
import 'package:expence_management/features/onboarding/view/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ================= TOP (GREY BACKGROUND ONLY) =================
          Expanded(
            child: Container(
              width: double.infinity,

              color: const Color.fromARGB(
                255,
                247,
                250,
                247,
              ), // grey only background

              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 4),

                    const Text(
                      "Ethos Finance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: "liberation-serif",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 108),

                    Image.asset(
                      "assets/images/first.png",
                      width: 440, // SAME AS YOUR CODE
                    ),

                    const Text(
                      "Master Your Money\nOwn Your Future.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "liberation-serif",
                        height: 1.5,
                        fontSize: 24,
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= BOTTOM (WHITE AREA ONLY) =================
          Container(
            height: 127,
            width: double.infinity,
            color: AppColors.white,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                // ================= DOT INDICATOR (UNCHANGED) =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDot(isActive: true),
                    const SizedBox(width: 10),
                    buildDot(),
                    const SizedBox(width: 10),
                    buildDot(),
                  ],
                ),

                const SizedBox(height: 20),

                // ================= BUTTONS (UNCHANGED) =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (Route<dynamic> route) =>
                                false, // This line forces the removal of ALL previous routes
                          );
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            color: AppColors.lightSecondaryText,
                            fontFamily: "liberation-serif",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},

                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shadowColor: AppColors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 11,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ).copyWith(
                              shadowColor: WidgetStateProperty.all(
                                AppColors.primaryGlow,
                              ),
                              elevation: WidgetStateProperty.all(14),
                            ),

                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SecondScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontFamily: "liberation-serif",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DOT WIDGET (UNCHANGED) =================
  Widget buildDot({bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32 : 6,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
