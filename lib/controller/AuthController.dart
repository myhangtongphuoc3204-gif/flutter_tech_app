import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal() {
    init();
  }

  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;
  String _userName = '';
  String _role = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get role => _role;

  Future<void> init() async {
    final name = await _apiService.getUserName();
    final userRole = await _apiService.getUserRole();

    // Check if token/role exists to determine login status
    _isLoggedIn = userRole != null && userRole.isNotEmpty;
    _userName = name ?? '';
    _role = userRole?.toLowerCase() ?? 'user';

    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _apiService.login(email, password);
    if (result['success']) {
      await init();
    }
    return result;
  }

  Future<void> logout() async {
    await _apiService.clearUserData();
    _isLoggedIn = false;
    _userName = '';
    _role = '';
    notifyListeners();
  }
}
