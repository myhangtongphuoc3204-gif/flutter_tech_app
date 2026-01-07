import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditCategoryController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool isSubmitting = false;

  Future<Map<String, dynamic>> updateCategory(int id, String name) async {
    isSubmitting = true;
    notifyListeners();

    try {
      final result = await _apiService.updateCategory(id, {'name': name});
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
