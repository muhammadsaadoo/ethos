import 'package:expence_management/features/monthly_budget/controller/budget_controller.dart';
import 'package:expence_management/features/monthly_budget/repository/budget_repository.dart';
import 'package:expence_management/features/monthly_budget/service/budget_firestore_service.dart';
import 'package:expence_management/features/monthly_budget/service/budget_hive_service.dart';
import 'package:get/get.dart';

class BudgetBindings extends Bindings {
  @override
  void dependencies() {
    // Hive Service
    Get.lazyPut(() => BudgetHiveService());

    // Firestore Service
    Get.lazyPut(() => BudgetFirestoreService());

    // Repository
    Get.lazyPut(
      () => BudgetRepository(
        hiveService: Get.find(),
        firestoreService: Get.find(),
      ),
    );

    // Controller
    Get.lazyPut(() => BudgetController(Get.find()));
  }
}
