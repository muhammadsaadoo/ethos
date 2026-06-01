// features/navbar/navbar_controller.dart
import 'package:get/get.dart';

class NavController extends GetxController {
  // Reactive variable to track the active tab index
  final RxInt selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
