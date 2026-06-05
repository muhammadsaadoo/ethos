import 'package:expence_management/features/transaction/controller/add_transaction_controller.dart';
import 'package:expence_management/features/transaction/controller/transaction_controller.dart';
import 'package:expence_management/features/transaction/repository/transaction_repository.dart';
import 'package:expence_management/features/transaction/service/transaction_firestore_service.dart';
import 'package:expence_management/features/transaction/service/transaction_hive_service.dart';
import 'package:get/get.dart';

class TransactionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionHiveService());

    Get.lazyPut(() => TransactionFirestoreService());

    Get.lazyPut(
      () => TransactionRepository(
        hiveService: Get.find(),
        firestoreService: Get.find(),
        cardFirestoreService: Get.find(),
        cardHiveService: Get.find(),
      ),
    );

    Get.lazyPut(() => TransactionController(Get.find()));
    Get.lazyPut(() => AddTransactionController());
  }
}
