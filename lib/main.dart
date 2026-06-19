import 'package:expence_management/core/constants/hive_boxes.dart';
import 'package:expence_management/core/services/theme_controller.dart';
import 'package:expence_management/core/utils/theme/apptheme/theme_data.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/monthly_budget/model/budget_model.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/routes/app_pages.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  await Hive.openBox<CardModel>(HiveBoxes.cards);
  await Hive.openBox<TransactionModel>(HiveBoxes.transactions);
  await Hive.openBox<GoalModel>(HiveBoxes.goals);
  await Hive.openBox<BudgetModel>(HiveBoxes.budget);

  await Get.putAsync(() => ThemeController().init());

  runApp(const MyApp());

  //android   1:247794172122:android:3bd6b22775253dec7ea5e3
  // ios       1:247794172122:ios:eb7ce72f357004197ea5e3

  //background: #FFFFFF33;
  //border: 1px solid #FFFFFF33
  //box-shadow: 0px 4px 20px 0px #0000001A;

  // backdrop-filter: blur(12px)
} //green card has this color combination

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        getPages: AppPages.pages,
        initialRoute: AppRoutes.splash,
      );
    });
  }
}

  // backdrop-filter: blur(12px)
// } //green card has this color combination
      // fallbackLocale: Locale('en'),
      // initialRoute: AppRoutes.addTransaction,
      // initialRoute: void AppRoutes.splash, // 👈 START SCREEN
      // // 👈 START SCREEN
      // total target savings
      //
      // getPages: void AppPages.pages,
      // initialRoute: '/splashscreen',
      // getPages: [
      //   GetPage(name: '/splashscreen', page: () => SplashScreen()),
      // GetPage(name: '/wrap', page: () => WrapPractice()),
      // GetPage(
      //   name: '/customscrollview',
      //   page: () => CustomScrollViewPractice(),
      // ),
      // GetPage(name: '/', page: () => GetxhomeScreen()),
      // GetPage(name: '/settings', page: () => GetxsettingsScreen()),
      // GetPage(name: '/realtimedb', page: () => Realtimedb()),
      // GetPage(
      //   name: '/remoteconfig',
      //   page: () => FirebaseRemoteConfigForads(),
      // ),
      // GetPage(
      //   name: '/profile',
      //   page: () => GetxprofileScreen(),
      //   binding: ProfileBindings(),
      // ),
      // GetPage(name: '/data/:id', page: () => Getxdatascreenwithid()),
      // GetPage(
      //   name: '/dashboard',
      //   page: () => AdminDashboardScreen(),
      //   middlewares: [AuthMiddleware()],
      // ),
      // ],

      // home: Signup(),
//     );
//   }
// }
