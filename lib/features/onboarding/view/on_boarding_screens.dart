import 'dart:ui';

import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
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
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(backgroundColor: Colors.white),
      body: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),

                child: Container(
                  height: size.height * 0.70,

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,

                    //   colors: Theme.of(context).scaffoldBackgroundColor,
                    // ),
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
                        ? Center(
                            child: Text(
                              "Ethos Finance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
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
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontFamily: "liberation-serif",
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
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
                            // style:  TextStyle(
                            //   fontFamily: "liberation-serif",
                            //   fontSize: 24,
                            //   fontWeight: FontWeight.w700,
                            //   color: AppColors.black,
                            // ),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontFamily: "liberation-serif",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data.description,
                              textAlign: TextAlign.center,
                              // style: const TextStyle(
                              //   fontFamily: "liberation-serif",
                              //   fontSize: 14,
                              //   fontWeight: FontWeight.w600,
                              //   color: AppColors.onboardingSubtitle,
                              //   height: 1.5,
                              // ),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontFamily: "liberation-serif",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 80),
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
                                // style: const TextStyle(
                                //   fontFamily: "liberation-serif",
                                //   fontSize: 18,
                                //   fontWeight: FontWeight.w600,
                                //   color: AppColors.onboardingIcon,
                                // ),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontFamily: "liberation-serif",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
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
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  controller.currentIndex.value ==
                                          controller.pagesData.length - 1
                                      ? "Get Started"
                                      : "Next",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Get.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
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
        color: currentIndex == index
            ? Get.theme.primaryColor
            : AppColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
