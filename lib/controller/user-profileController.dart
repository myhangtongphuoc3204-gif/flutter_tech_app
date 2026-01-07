import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProfileController extends ChangeNotifier {
  static final UserProfileController _instance =
      UserProfileController._internal();
  factory UserProfileController() => _instance;
  UserProfileController._internal();

  final ApiService _apiService = ApiService();

  String _name = '';
  String _email = '';
  String _phone = '';
  String _role = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get role => _role;

  Future<void> loadUserProfile() async {
    _name = await _apiService.getUserName() ?? 'N/A';
    _email = await _apiService.getUserEmail() ?? 'N/A';
    _phone = await _apiService.getUserPhone() ?? 'N/A';
    _role = await _apiService.getUserRole() ?? 'USER';
    notifyListeners();
  }
}
