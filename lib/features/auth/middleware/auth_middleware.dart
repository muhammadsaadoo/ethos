import 'package:expence_management/features/auth/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Get.find<UserSessionService>();

    if (session.userId.isEmpty) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}
