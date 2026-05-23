import 'dart:ui';

import 'package:expence_management/features/onboarding/controller/welcome_s_getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:task_project/features/welcome/getxcontroller/welcome_s_getx_controller.dart';

class OnBoardingScreens extends StatelessWidget {
  const OnBoardingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ✅ Single controller instance for the whole screen
    final WelcomeSGetxController controller = Get.put(WelcomeSGetxController());

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(color: const Color(0xFFF8F9FA)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                /// ── HEADER (page number + skip) ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Obx(
                    () => controller.currentIndex.value == 0
                        ? const Center(
                            child: Text(
                              "Ethos Finance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF006C49),
                                fontFamily: "liberation-serif",
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: controller.skip,
                                child: const Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontFamily: "liberation-serif",
                                    fontSize: 18,
                                    color: Color(0xFF006C49),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 80),

                /// ── PAGE VIEW ─────────────────────────────────────────────────
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.pagesData.length,
                    // ✅ This fires automatically on swipe AND on nextPage/prevPage
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      final data = controller.pagesData[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(data.image, height: 400, width: 500),
                          Text(
                            textAlign: TextAlign.center,
                            data.title,
                            style: const TextStyle(
                              fontFamily: "liberation-serif",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff000000),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              data.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "liberation-serif",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffA8A8A9),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 100),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.pagesData.length,
                      (index) =>
                          _buildDot(index, controller.currentIndex.value),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                /// ── BOTTOM ROW (Prev + Dots + Next) ──────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      // ── Prev button ──
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => InkWell(
                              onTap: controller.currentIndex.value > 0
                                  ? controller.previousPage
                                  : controller.skip, // your skip function
                              child: Text(
                                controller.currentIndex.value > 0
                                    ? "Prev"
                                    : "Skip",
                                style: const TextStyle(
                                  fontFamily: "liberation-serif",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffC4C4C4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Dot indicators ──

                      // ── Next / Get Started button ──
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Obx(
                            () => InkWell(
                              onTap: controller.nextPage,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006C49),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  controller.currentIndex.value ==
                                          controller.pagesData.length - 1
                                      ? "Get Started"
                                      : "Next",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
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
    );
  }

  // ✅ Pure function — takes current index as param, no setState needed
  Widget _buildDot(int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: currentIndex == index ? 40 : 10,
      decoration: BoxDecoration(
        //background: #E1E3E4;
        color: currentIndex == index ? Color(0xFF006C49) : Color(0XFFE1E3E4),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
