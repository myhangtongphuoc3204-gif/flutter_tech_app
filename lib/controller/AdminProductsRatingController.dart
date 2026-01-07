import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminProductsRatingController {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllRatings() async {
    return await _apiService.getAllRatings();
  }

  Future<bool> deleteRating(BuildContext context, int id) async {
    final result = await _apiService.deleteRating(id);
    if (result['success'] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Xóa đánh giá thành công')));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Lỗi khi xóa đánh giá')),
      );
      return false;
    }
  }
}
