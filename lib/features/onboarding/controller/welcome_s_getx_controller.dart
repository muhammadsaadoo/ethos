import 'package:expence_management/features/onboarding/model/onboard_screens_data.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:task_project/features/auth/view/login_screen.dart';
// import 'package:task_project/presentation/screens/utils/onboard_screens_data.dart';

class WelcomeSGetxController extends GetxController {
  var signUpMessage = "".obs;
  // ✅ All reactive variables
  final RxInt currentIndex = 0.obs;
  final RxInt pageNumber = 1.obs;

  final PageController pageController = PageController();

  final List<OnboardScreensData> pagesData = [
    OnboardScreensData(
      image: "assets/images/first.png",
      title: "Manage all your expenses in One place",
      description: "",
    ),
    OnboardScreensData(
      image: "assets/images/second.png",
      title: "Visualize your spending habits",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
    ),
    OnboardScreensData(
      image: "assets/images/third.png",
      title: "Reach your financial goals faster",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ✅ Called when user swipes the PageView
  void onPageChanged(int index) {
    currentIndex.value = index;
    pageNumber.value = index + 1;
  }

  // ✅ Next button logic
  void nextPage() {
    if (currentIndex.value < pagesData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      // ❌ Don't update currentIndex here
      // onPageChanged() will fire automatically via onPageChanged callback
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  // ✅ Prev button logic
  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      // ❌ Don't update currentIndex here either
      // onPageChanged() fires automatically
    }
  }

  // ✅ Skip button
  void skip() {
    Get.offAllNamed(AppRoutes.login);
  }
}

// import 'package:get/get.dart';

// class WelcomeSGetxController extends GetxController {
//   var signUpMessage = "".obs;
//   var currentIndex = 0.obs;
//   var pageNumber = 1.obs;
//   void increment() {
//     print("$pageNumber");
//     currentIndex++;
//     print("$pageNumber");
//   }
// }
