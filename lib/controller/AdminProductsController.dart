import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/product.dart';
import '../model/category.dart';

class AdminProductsController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> products = [];
  List<Category> categories = [];
  bool isLoading = false;

  Future<void> fetchAllData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch both products and categories
      final productList = await _apiService.getAllProducts();
      final categoryListJson = await _apiService.getAllCategoriesForAdmin();

      products = productList;
      categories = categoryListJson
          .map((json) => Category.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching product data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getCategoryName(int categoryId) {
    try {
      final category = categories.firstWhere((cat) => cat.id == categoryId);
      return category.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<Map<String, dynamic>> deleteProduct(int id) async {
    // Assuming deleteProduct is added to ApiService as well
    // For now, I'll add the placeholder or implementation if available
    try {
      // I should check if ApiService has deleteProduct
      final response = await _apiService.deleteProduct(id);
      if (response['success'] == true) {
        products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
      return response;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }
}
