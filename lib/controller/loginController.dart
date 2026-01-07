import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../views/products.dart';
import '../views/admindashboard.dart';
import 'AuthController.dart';

class LoginController {
  final AuthController _authController = AuthController();
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await _authController.login(email.trim(), password);
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }

  Future<void> navigateAfterLogin(BuildContext context) async {
    final userRole = await _apiService.getUserRole();

    if (context.mounted) {
      if (userRole == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductsPage()),
        );
      }
    }
  }
}
