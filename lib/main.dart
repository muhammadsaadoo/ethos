import 'package:expence_management/features/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());

  //android   1:247794172122:android:3bd6b22775253dec7ea5e3
  // ios       1:247794172122:ios:eb7ce72f357004197ea5e3
}

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
      initialRoute: '/splashscreen',
      getPages: [
        GetPage(name: '/splashscreen', page: () => SplashScreen()),
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
      ],

      // home: Signup(),
    );
  }
}
