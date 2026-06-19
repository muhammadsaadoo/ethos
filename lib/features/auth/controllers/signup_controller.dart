// ===================== CONTROLLER =====================

import 'package:expence_management/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';

class SignupController extends GetxController {
  // final AuthService authService = AuthService();
  final AuthService authService;

  // ================= TEXT CONTROLLERS =================

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ================= OBSERVABLES =================

  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  RxString fullNameError = ''.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;

  SignupController(this.authService);

  // ================= VALIDATION =================

  String? validateFullName(String value) {
    if (value.trim().isEmpty) {
      return "Full name is required";
    }

    if (value.length < 3) {
      return "Enter valid full name";
    }

    return null;
  }

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

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Confirm password is required";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }

  // ================= SIGNUP =================

  Future<void> signup() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // ================= CLEAR OLD ERRORS =================
    fullNameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    // ================= VALIDATE =================
    final fullNameErr = validateFullName(fullName);
    final emailErr = validateEmail(email);
    final passwordErr = validatePassword(password);
    final confirmPasswordErr = validateConfirmPassword(
      password,
      confirmPassword,
    );

    fullNameError.value = fullNameErr ?? '';
    emailError.value = emailErr ?? '';
    passwordError.value = passwordErr ?? '';
    confirmPasswordError.value = confirmPasswordErr ?? '';

    // ================= STOP IF INVALID =================
    if (fullNameErr != null ||
        emailErr != null ||
        passwordErr != null ||
        confirmPasswordErr != null) {
      return;
    }

    try {
      isLoading.value = true;

      await authService.signup(
        fullName: fullName,
        email: email,
        password: password,
      );
      Get.back();

      Get.snackbar(
        "Success",
        "Account created successfully",
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
      // Get.back()
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
