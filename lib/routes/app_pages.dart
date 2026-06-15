import 'package:expence_management/features/auth/bindings/login_bindings.dart';
import 'package:expence_management/features/auth/bindings/signup_bindings.dart';
import 'package:expence_management/features/auth/middleware/auth_middleware.dart';
import 'package:expence_management/features/auth/view/login_screen.dart';
import 'package:expence_management/features/auth/view/signup_screen.dart';
import 'package:expence_management/features/card/bindings/card_bindings.dart';
import 'package:expence_management/features/card/view/create_card_screen.dart';
import 'package:expence_management/features/goals/bindings/goal_bindings.dart';
import 'package:expence_management/features/goals/view/create_goal_screen.dart';
import 'package:expence_management/features/goals/view/view_goals_progress.dart';
import 'package:expence_management/features/home/bindings/home_bindings.dart';
import 'package:expence_management/features/home/view/home_screen.dart';
import 'package:expence_management/features/monthly_budget/bindings/budget_bindings.dart';
import 'package:expence_management/features/monthly_budget/view/create_budget_screen.dart';
import 'package:expence_management/features/monthly_budget/view/view_budget_screen.dart';
import 'package:expence_management/features/navbar/bindings/navbar_bindings.dart';
import 'package:expence_management/features/navbar/main_screen.dart';
import 'package:expence_management/features/profile/view/profile_screen.dart';
import 'package:expence_management/features/splash/view/splash_screen.dart';
import 'package:expence_management/features/transaction/bindings/transaction_bindings.dart';
import 'package:expence_management/features/transaction/view/add_transaction_screen.dart';
import 'package:expence_management/features/transaction/view/transaction_categories_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// import '../features/auth/login/binding/login_binding.dart';
// import '../features/auth/signup/binding/signup_binding.dart';

// import '../features/auth/login/view/login_screen.dart';
// import '../features/auth/signup/view/signup_screen.dart';
// import '../features/home/view/home_screen.dart';

import 'app_routes.dart';

class AppPages {
  static String get initial {
    final user = FirebaseAuth.instance.currentUser;

    return user == null ? AppRoutes.login : AppRoutes.home;
  }

  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
        // CardBindings(),
        // TransactionBindings(),
        // GoalBindings(), // Your second binding class
        // Add more bindings here as needed
      ],
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
      binding: SignupBinding(),
      // middlewares: [AuthMiddleware()],
    ),

    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      // binding: HomeBindings(),
      middlewares: [AuthMiddleware()],
    ),

    // GetPage(
    //   name: AppRoutes.mainScreen,
    //   page: () => MainScreen(),
    //   // binding: HomeBindings(),
    // ),
    GetPage(
      name: AppRoutes.mainScreen, //route
      page: () => const MainScreen(), // load screen
      bindings: [
        NavbarBindings(),
        HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
        BudgetBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),
    GetPage(
      name: AppRoutes.addTransaction, //route
      page: () => const AddTransactionScreen(), // load screen
      // bindings: [
      //   // NavbarBindings(),
      //   // HomeBindings(),
      //   CardBindings(),
      //   TransactionBindings(),
      //   GoalBindings(),
      // ],
      // 👈 Hooks bindings automatically on route load
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.transaction_categories, //route
      page: () => const TransactionCategoriesScreen(), // load screen
      // bindings: [
      //   // NavbarBindings(),
      //   // HomeBindings(),
      //   CardBindings(),
      //   TransactionBindings(),
      //   GoalBindings(),
      // ],
      // 👈 Hooks bindings automatically on route load
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile, //route
      page: () => const ProfileScreen(), // load screen
      // bindings: [
      //   // NavbarBindings(),
      //   // HomeBindings(),
      //   CardBindings(),
      //   TransactionBindings(),
      //   GoalBindings(),
      // ],
      // 👈 Hooks bindings automatically on route load
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.creategoals, //route
      page: () => const CreateGoalScreen(), // load screen
      bindings: [
        // NavbarBindings(),
        // HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),
    GetPage(
      name: AppRoutes.viewgoals, //route
      page: () => const ViewGoalsProgress(), // load screen
      bindings: [
        // NavbarBindings(),
        // HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),
    GetPage(
      name: AppRoutes.createcard, //route
      page: () => const CreateCardScreen(), // load screen
      bindings: [
        // NavbarBindings(),
        // HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),

    GetPage(
      name: AppRoutes.createbudget, //route
      page: () => const CreateBudgetScreen(), // load screen
      bindings: [
        // NavbarBindings(),
        // HomeBindings(),
        // CardBindings(),
        // TransactionBindings(),
        // GoalBindings(),
        BudgetBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),

    GetPage(
      name: AppRoutes.viewbudget, //route
      page: () => const ViewBudgetScreen(), // load screen
      bindings: [
        NavbarBindings(),
        HomeBindings(),
        CardBindings(),
        TransactionBindings(),
        GoalBindings(),
        BudgetBindings(),
      ],
      middlewares: [AuthMiddleware()],
      // 👈 Hooks bindings automatically on route load
    ),
  ];
}
