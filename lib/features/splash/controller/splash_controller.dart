import 'dart:async';

import 'package:expence_management/features/onboarding/view/first_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    navigateToHome();
  }

  void navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Get.off(() => const FirstScreen());
    });
  }
}
