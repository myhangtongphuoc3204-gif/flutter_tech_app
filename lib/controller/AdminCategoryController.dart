import 'package:flutter/material.dart';
import '../model/category.dart';
import '../services/api_service.dart';

class AdminCategoryController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Category> categories = [];
  bool isLoading = false;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> data = await _apiService.getAllCategoriesForAdmin();
      categories = data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    final result = await _apiService.deleteCategory(id);
    if (result['success'] == true) {
      categories.removeWhere((cat) => cat.id == id);
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> createCategory(String name) async {
    final result = await _apiService.createCategory({'name': name});
    if (result['success'] == true) {
      await fetchCategories();
    }
    return result;
  }

  Future<Map<String, dynamic>> updateCategory(int id, String name) async {
    final result = await _apiService.updateCategory(id, {'name': name});
    if (result['success'] == true) {
      await fetchCategories();
    }
    return result;
  }
}
