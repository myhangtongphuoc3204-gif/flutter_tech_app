import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/category.dart';

class EditProductsController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Category> categories = [];
  List<String> availableImages = [];
  bool isLoading = false;
  bool isSubmitting = false;

  Future<void> fetchInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch categories
      final catListJson = await _apiService.getAllCategoriesForAdmin();
      categories = catListJson.map((json) => Category.fromJson(json)).toList();

      // Fetch all products to get available images
      final productList = await _apiService.getAllProducts();
      // Get unique images
      availableImages = productList.map((p) => p.image).toSet().toList();
    } catch (e) {
      print('Error fetching initial data for edit product: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String name,
    required String image,
    required double price,
    required int quantity,
    required int categoryId,
  }) async {
    isSubmitting = true;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
        'categoryId': categoryId,
        'status': 'active',
      };

      final result = await _apiService.updateProduct(id, data);
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
