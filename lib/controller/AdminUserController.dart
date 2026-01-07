import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/user.dart';

class AdminUserController extends ChangeNotifier {
  static final AdminUserController _instance = AdminUserController._internal();
  factory AdminUserController() => _instance;
  AdminUserController._internal();

  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.getAllUsers();
      _users = data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error in AdminUserController.fetchUsers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteUser(int id) async {
    final result = await _apiService.deleteUser(id);
    if (result['success'] == true) {
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> userData,
  ) async {
    final result = await _apiService.updateUser(id, userData);
    if (result['success'] == true) {
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = User.fromJson(result['data'] ?? userData);
        notifyListeners();
      }
    }
    return result;
  }
}
