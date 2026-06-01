// ======================= CONTROLLER =======================

import 'package:expence_management/features/auth/services/login_service.dart';
import 'package:expence_management/features/dummy_data_service.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // final LoginService service = LoginService();
  final LoginService service;
  final DummyDataService dummyDataService = DummyDataService();

  // ================= CONTROLLERS =================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ================= OBS =================

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  // ================= ERRORS =================

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  LoginController(this.service);

  // ================= VALIDATION =================

  String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Email is required";
    }

    if (!GetUtils.isEmail(value.trim())) {
      return "Enter valid email";
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be 6 characters";
    }

    return null;
  }

  // ================= LOGIN =================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // CLEAR OLD ERRORS

    emailError.value = '';
    passwordError.value = '';

    // VALIDATE

    emailError.value = validateEmail(email) ?? '';
    passwordError.value = validatePassword(password) ?? '';

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      await service.login(email: email, password: password);
      print("test start..................");
      // dummyDataService.runCompleteTest();
      // await dummyDataService.runCleanTestFlow();
      print("test end.................");

      Get.offAllNamed(AppRoutes.mainScreen);
    } catch (e) {
      print(e.toString());
      String message = _handleAuthError(e);

      Get.snackbar(
        "Login Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB00020),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  String _handleAuthError(dynamic e) {
    final error = e.toString();

    if (error.contains("user-not-found")) {
      return "No account found with this email.";
    } else if (error.contains("credential is incorrect")) {
      return "Incorrect email or password";
    }

    return "Something went wrong. Please try again.";
  }

  void goToSignup() => Get.toNamed(AppRoutes.signup);
}
