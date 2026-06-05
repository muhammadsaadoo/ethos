import 'package:expence_management/core/constants/hive_boxes.dart';
import 'package:expence_management/features/card/model/card_model.dart';
import 'package:expence_management/features/goals/model/goal_model.dart';
import 'package:expence_management/features/transaction/model/transaction_model.dart';
import 'package:expence_management/routes/app_pages.dart';
import 'package:expence_management/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());

  await Hive.openBox<CardModel>(HiveBoxes.cards);
  await Hive.openBox<TransactionModel>(HiveBoxes.transactions);
  await Hive.openBox<GoalModel>(HiveBoxes.goals);

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
    return GetMaterialApp(
      // themeMode: ThemeMode.dark,
      // themeMode: ThemeMode.light,
      // darkTheme: ThemeData.dark().copyWith(
      //   // manual Changes
      // ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'inter'),

      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.green,
      //       foregroundColor: Colors.white,
      //       // padding: EdgeInsets.all(20),
      //     ),
      //   ),
      //   textTheme: TextTheme(headlineSmall: TextStyle(fontSize: 100)),
      // ),

      // Theme Practice
      // initialRoute: '/',
      // routes: RouteHelper.myRoutes(),
      // // routes: {
      // //   '/': (context) => RoutesAdvance(),
      // //   '/home': (context) => HomeScreen(),
      // //   '/settings': (context) => SettingsScreen(),
      // //   // '/profile': (context) =>
      // //   //     ProfileScreeen(), //we cannot pass data from one screen to another when usyng routes so we use on generate routes
      // // },
      // onGenerateRoute: (RouteSettings settings) =>
      //     RouteHelper.myGeneratedRoutes(settings),
      // translations: InternationalizeApp(),
      // locale: Get.deviceLocale,   device locale
      // locale: Locale('en'),
      // fallbackLocale: Locale('en'),
      initialRoute: AppRoutes.addTransaction, // 👈 START SCREEN

      getPages: AppPages.pages,
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
    );
  }
}
