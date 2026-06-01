// main_binding.dart
import 'package:expence_management/features/navbar/controller/nav_controller.dart';
import 'package:get/get.dart';
// Import your tab controllers here

class NavbarBindings extends Bindings {
  @override
  void dependencies() {
    // Main UI navigation controller
    print("navBar bindings Run");
    Get.lazyPut(() => NavController());

    // Feature controllers are lazy loaded instantly when needed
    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
