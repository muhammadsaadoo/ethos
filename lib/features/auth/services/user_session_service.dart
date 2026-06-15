import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserSessionService extends GetxService {
  final Rxn<User> currentUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => currentUser.value?.uid ?? '';

  Future<UserSessionService> init() async {
    currentUser.value = FirebaseAuth.instance.currentUser;
    return this;
  }

  Future<void> logout() async {
    await _auth.signOut();

    Get.offAllNamed('/login');
  }
}
