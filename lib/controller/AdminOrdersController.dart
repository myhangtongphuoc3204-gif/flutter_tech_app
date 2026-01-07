import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminOrdersController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = false;
  String _filterStatus = 'ALL';

  List<dynamic> get orders => _orders;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  List<dynamic> get filteredOrders {
    if (_filterStatus == 'ALL') {
      return _orders;
    }
    return _orders
        .where(
          (order) =>
              (order['status'] ?? '').toString().toUpperCase() == _filterStatus,
        )
        .toList();
  }

  void setFilter(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _apiService.getAllOrders();
      _orders = _orders.reversed.toList(); // Reserve order
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(int id, String status) async {
    try {
      final result = await _apiService.updateOrderStatus(id, status);
      if (result['success'] == true) {
        await fetchAllOrders(); // Refresh list after update
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }
}
