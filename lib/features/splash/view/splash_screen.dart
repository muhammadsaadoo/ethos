import 'package:expence_management/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131B2E),

      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          right: 20,
          left: 20,
          bottom: 20,
        ),

        child: Column(
          children: [
            // ===================== TOP BUTTON =====================
            Padding(
              padding: const EdgeInsets.only(top: 18),

              child: Align(
                alignment: Alignment.centerRight,

                child: Container(
                  width: 83,
                  height: 29,

                  decoration: BoxDecoration(
                    color: const Color(0x1AF8F9FA),

                    border: Border.all(
                      color: const Color(0x1AF8F9FA),
                      width: 1,
                    ),

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [
                      Icon(Icons.sunny, color: Colors.white, size: 15),

                      SizedBox(width: 5),

                      Text(
                        "LIGHT",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ===================== LOGO =====================
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF006C49),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              child: Image.asset(
                "assets/images/image.png",
                width: 160,
                height: 160,
              ),
            ),

            // ===================== TITLE =====================
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),

              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFF4EDEA3)],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  );
                },

                child: const Text(
                  "Ethos",

                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 82),

            // ===================== DESCRIPTION =====================
            const SizedBox(
              width: 210,

              child: Text(
                "Master Your Money\nOwn Your Future.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  height: 1.5,
                  fontSize: 18,
                  color: Color(0xFFBEC6E0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // ===================== LOADER =====================
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: const Color(0x1AF8F9FA),

                border: Border.all(color: const Color(0x1AF8F9FA), width: 1),

                borderRadius: BorderRadius.circular(30),

                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),

              child: const Padding(
                padding: EdgeInsets.all(13),

                child: SizedBox(
                  width: 20,
                  height: 20,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,

                    valueColor: AlwaysStoppedAnimation(Color(0xFF6FFBBE)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
