import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return {'success': false, 'message': 'Mật khẩu xác nhận không khớp'};
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
