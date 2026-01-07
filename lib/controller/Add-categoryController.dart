import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddCategoryController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool isSubmitting = false;

  Future<Map<String, dynamic>> createCategory(String name) async {
    isSubmitting = true;
    notifyListeners();

    try {
      final result = await _apiService.createCategory({'name': name});
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
