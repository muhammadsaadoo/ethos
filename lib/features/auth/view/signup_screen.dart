import 'package:expence_management/features/auth/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 235, 236),

      body: Stack(
        children: [
          // ================= GREEN TOP HALF CIRCLE =================
          Positioned(
            top: -180,
            left: -60,
            right: -60,

            child: Container(
              height: 585,

              decoration: const BoxDecoration(
                //background: #006C49;
                color: Color(0xFF006C49),

                shape: BoxShape.circle,
              ),

              child: const Padding(
                padding: EdgeInsets.only(top: 220),

                child: Align(
                  alignment: Alignment.topCenter,

                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "Ethos",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= FORM CARD =================
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Align(
              alignment: Alignment.center,

              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ================= HEADINGS =================
                      Center(
                        child: const Text(
                          "Create Account",

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Join Ethos Finance to manage your wealth",

                          style: TextStyle(
                            //background: #3C4A42;
                            height: 1.5,
                            fontSize: 16,
                            color: Color(0xFF3C4A42),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        "Full Nme",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),

                      // ================= FULL NAME =================
                      Obx(
                        () => buildTextField(
                          controller: controller.fullNameController,
                          hintText: "Alex Morgan",
                          icon: Icons.person_outline,
                          errorText: controller.fullNameError.value,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),

                      // ================= EMAIL =================
                      Obx(
                        () => buildTextField(
                          controller: controller.emailController,
                          hintText: "alex@example.com",
                          icon: Icons.email_outlined,

                          errorText: controller.emailError.value,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),

                      // ================= PASSWORD =================
                      Obx(
                        () => buildTextField(
                          controller: controller.passwordController,
                          hintText: "********",
                          icon: Icons.lock_outline,

                          obscureText: !controller.isPasswordVisible.value,

                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                            },

                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          errorText: controller.passwordError.value,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),

                      // ================= CONFIRM PASSWORD =================
                      Obx(
                        () => buildTextField(
                          controller: controller.confirmPasswordController,

                          hintText: "********",

                          icon: Icons.lock_outline,

                          obscureText:
                              !controller.isConfirmPasswordVisible.value,

                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value;
                            },

                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          errorText: controller.confirmPasswordError.value,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= SIGNUP BUTTON =================
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.signup,

                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),

                            decoration: BoxDecoration(
                              color: const Color(0xFF006C49),

                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: Center(
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,

                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: const Text(
                                        "Create Account",

                                        style: TextStyle(
                                          color: Colors.white,

                                          fontSize: 14,

                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================= SIGNIN TEXT =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              //background: #3C4A42;
                              color: Color(0xFF3C4A42),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {},

                            child: const Text(
                              "Sign In",

                              style: TextStyle(
                                color: Color(0xFF006C49),

                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== TEXTFIELD =====================

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        errorText: errorText != null && errorText.isNotEmpty ? errorText : null,

        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        hintText: hintText,
        hintStyle: TextStyle(
          //background: #BBCABF;
          color: Color(0xFFBBCABF), // Set your desired hint color here
          fontSize: 16, // Optional: adjust size if needed
        ),

        prefixIcon: Icon(icon),

        suffixIcon: suffixIcon,

        filled: true,

        //background: #EDEEEF;
        fillColor: const Color(0xFFEDEEEF),

        contentPadding: const EdgeInsets.symmetric(vertical: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),

          borderSide: const BorderSide(color: Color(0xFF006C49)),
        ),
      ),
    );
  }
}
