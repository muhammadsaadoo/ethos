import 'package:expence_management/features/auth/view/login_screen.dart';
import 'package:expence_management/features/onboarding/view/third_screen.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
          ),
        ),

        child: Column(
          children: [
            // ================= TOP SKIP =================
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),

                child: Align(
                  alignment: Alignment.topRight,

                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) =>
                            false, // This line forces the removal of ALL previous routes
                      );
                    },

                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: "liberation-serif",
                        color: Color(0xFF006C49),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ================= CENTER IMAGE =================
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x26006C49),
                    blurRadius: 100,
                    offset: Offset(5, 10),
                  ),
                ],
              ),

              child: Image.asset("assets/images/second.png"),
            ),

            // const Spacer(),
            SizedBox(height: 30),
            const Spacer(),

            // ================= BOTTOM CONTAINER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 20,
                    offset: Offset(0, -2),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // ================= TEXT =================
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "Visualize your spending habits",
                      style: TextStyle(
                        fontFamily: "liberation-serif",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),

                    child: Column(
                      children: const [
                        // ================= BIG LINE =================
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "expense and take control expense and take control of your finances easily.Stay organized and manage your money better every day.",

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontFamily: "liberation-serif",
                              fontSize: 14, // BIG
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // ================= DOTS + NEXT =================
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        // DOTS
                        Row(
                          children: [
                            buildDot(),
                            const SizedBox(width: 8),
                            buildDot(isActive: true),
                            const SizedBox(width: 8),
                            buildDot(),
                          ],
                        ),

                        // NEXT BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ThirdScreen(),
                              ),
                            );
                          },

                          child: Container(
                            width: 56,
                            height: 56,
                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: const Color(0xFF006C49),

                              borderRadius: BorderRadius.circular(30),

                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33006C49),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  // ================= DOT WIDGET =================
  Widget buildDot({bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      width: isActive ? 32 : 8,
      height: 8,

      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF006C49) : const Color(0xFFE1E3E4),

        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
