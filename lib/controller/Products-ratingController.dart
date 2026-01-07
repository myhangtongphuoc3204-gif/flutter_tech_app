import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductsRatingController extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Submit rating for a product
  Future<Map<String, dynamic>> submitRating({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await apiService.createProductRating(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
