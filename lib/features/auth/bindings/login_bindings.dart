import 'package:expence_management/features/auth/controllers/login_controller.dart';
import 'package:expence_management/features/auth/services/login_service.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginService());
    Get.lazyPut(() => LoginController(Get.find()));
  }
}
