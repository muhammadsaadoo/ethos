import 'package:expence_management/features/auth/bindings/login_bindings.dart';
import 'package:expence_management/features/auth/bindings/signup_bindings.dart';
import 'package:expence_management/features/auth/view/login_screen.dart';
import 'package:expence_management/features/auth/view/signup_screen.dart';
import 'package:expence_management/features/card/bindings/card_bindings.dart';
import 'package:expence_management/features/goals/bindings/goal_bindings.dart';
import 'package:expence_management/features/home/bindings/home_bindings.dart';
import 'package:expence_management/features/home/view/home_screen.dart';
import 'package:expence_management/features/navbar/bindings/navbar_bindings.dart';
import 'package:expence_management/features/navbar/main_screen.dart';
import 'package:expence_management/features/splash/view/splash_screen.dart';
import 'package:expence_management/features/transaction/bindings/transaction_bindings.dart';
import 'package:get/get.dart';

// import '../features/auth/login/binding/login_binding.dart';
// import '../features/auth/signup/binding/signup_binding.dart';

// import '../features/auth/login/view/login_screen.dart';
// import '../features/auth/signup/view/signup_screen.dart';
// import '../features/home/view/home_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(), // Your second binding class
        // Add more bindings here as needed
      ],
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
      binding: SignupBinding(),
    ),

    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      // binding: HomeBindings(),
    ),

    // GetPage(
    //   name: AppRoutes.mainScreen,
    //   page: () => MainScreen(),
    //   // binding: HomeBindings(),
    // ),
    GetPage(
      name: AppRoutes.mainScreen,
      page: () => const MainScreen(),
      bindings: [
        NavbarBindings(),
        HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
      ],
      // 👈 Hooks bindings automatically on route load
    ),
  ];
}
