import 'package:expence_management/features/auth/controllers/signup_controller.dart';
import 'package:expence_management/features/auth/services/auth_service.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => SignupController(Get.find()));
  }
}
