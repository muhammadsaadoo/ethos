import 'package:expence_management/features/goals/controller/goal_controller.dart';
import 'package:expence_management/features/goals/repository/goal_repository.dart';
import 'package:expence_management/features/goals/service/goal_firestore_service.dart';
import 'package:expence_management/features/goals/service/goal_hive_service.dart';
import 'package:get/get.dart';

class GoalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoalHiveService());

    Get.lazyPut(() => GoalFirestoreService());

    Get.lazyPut(
      () =>
          GoalRepository(hiveService: Get.find(), firestoreService: Get.find()),
    );

    Get.lazyPut(() => GoalController(Get.find()));
  }
}
