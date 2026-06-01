import 'package:expence_management/features/home/controller/home_controller.dart';
import 'package:expence_management/features/home/service/home_service.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    print("Bindings Runnn");
    Get.lazyPut(() => HomeService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
