class AuthService {
  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // TODO:
    // Implement Firebase Authentication later

    await Future.delayed(const Duration(seconds: 1));
  }
}
