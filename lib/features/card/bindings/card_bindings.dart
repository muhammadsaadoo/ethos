import 'package:expence_management/features/card/controller/card_controller.dart';
import 'package:expence_management/features/card/repository/card_repository.dart';
import 'package:expence_management/features/card/service/firestore_service/card_firestore_service.dart';
import 'package:expence_management/features/card/service/hive_service/card_hive_service.dart';
import 'package:get/get.dart';

// import '../../data/repositories/card_repository.dart';
// import '../../data/services/firestore/card_firestore_service.dart';
// import '../../data/services/hive/card_hive_service.dart';
// import '../../features/cards/controller/card_controller.dart';

class CardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardHiveService());

    Get.lazyPut(() => CardFirestoreService());

    Get.lazyPut(
      () => CardRepository(
        hiveService: Get.find(),
        firestoreService: Get.find(),
        transactionHiveService: Get.find(),
      ),
    );

    Get.lazyPut(() => CardController(Get.find()));
  }
}
