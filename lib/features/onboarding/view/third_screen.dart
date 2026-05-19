import 'dart:ui';

import 'package:expence_management/features/auth/view/signup_screen.dart';
import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ================= BASE BACKGROUND =================
          Container(color: const Color(0xFFF8F9FA)),

          // ================= GREEN BLUR GRADIENT =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),

                child: Container(
                  height: size.height * 0.70,

                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,

                      colors: [
                        Color.fromRGBO(16, 185, 129, 0.10),
                        Color.fromRGBO(16, 185, 129, 0.00),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= YOUR UI CONTENT =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),

                        child: const Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 73),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),

                    child: Image.asset(
                      "assets/images/third.png",
                      height: 400,
                      width: 380,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Reach your financial goals faster",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "liberation-serif",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
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

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDot(),
                      const SizedBox(width: 8),
                      buildDot(),
                      const SizedBox(width: 8),
                      buildDot(isActive: true),
                    ],
                  ),

                  const Spacer(),

                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                        (Route<dynamic> route) =>
                            false, // This line forces the removal of ALL previous routes
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),

                      decoration: BoxDecoration(
                        color: const Color(0xFF006C49),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33006C49),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      child: const Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontFamily: "liberation-serif",
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
