// ===================== CONTROLLER =====================

import 'package:expence_management/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthService authService = AuthService();

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

    // CLEAR OLD ERRORS

    // fullNameError.value = '';
    // emailError.value = '';
    // passwordError.value = '';
    // confirmPasswordError.value = '';

    // VALIDATE

    fullNameError.value = validateFullName(fullName) ?? '';

    emailError.value = validateEmail(email) ?? '';

    passwordError.value = validatePassword(password) ?? '';

    confirmPasswordError.value =
        validateConfirmPassword(password, confirmPassword) ?? '';

    // print(fullNameError);

    // STOP IF ERROR EXISTS

    if (fullNameError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        passwordError.value.isNotEmpty ||
        confirmPasswordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      await authService.signup(
        fullName: fullName,
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint(e.toString());
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
