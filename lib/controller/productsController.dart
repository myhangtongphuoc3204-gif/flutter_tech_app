import '../services/api_service.dart';
import '../model/product.dart';
import '../model/category.dart';

class ProductsController {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _apiService.getAllProducts();
      return response;
    } catch (e) {
      throw Exception('Lỗi tải sản phẩm: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _apiService.getProductsByCategory(categoryId);
      return response;
    } catch (e) {
      throw Exception('Lỗi tải sản phẩm theo danh mục: $e');
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    try {
      final response = await _apiService.searchProducts(keyword);
      return response;
    } catch (e) {
      throw Exception('Lỗi tìm kiếm sản phẩm: $e');
    }
  }

  Future<List<Category>> getActiveCategories() async {
    try {
      final response = await _apiService.getActiveCategories();
      return response;
    } catch (e) {
      throw Exception('Lỗi tải danh mục: $e');
    }
  }
}
