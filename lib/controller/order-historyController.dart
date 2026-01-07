import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderHistoryController extends ChangeNotifier {
  // Singleton pattern
  static final OrderHistoryController _instance =
      OrderHistoryController._internal();
  factory OrderHistoryController() => _instance;
  OrderHistoryController._internal();

  final ApiService apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = false;

  List<dynamic> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final email = await apiService.getUserEmail();
      final phone = await apiService.getUserPhone();

      print('=== ORDER FETCH DEBUG ===');
      print('Search Email: ${email ?? "EMPTY"}');
      print('Search Phone: ${phone ?? "EMPTY"}');

      List<dynamic> emailOrders = [];
      List<dynamic> phoneOrders = [];

      if (email != null && email.isNotEmpty) {
        print('Calling getOrdersByCustomer($email)...');
        emailOrders = await apiService.getOrdersByCustomer(email);
        print('Raw Email Orders: $emailOrders');
      }

      if (phone != null && phone.isNotEmpty) {
        print('Calling getOrdersByPhone($phone)...');
        phoneOrders = await apiService.getOrdersByPhone(phone);
        print('Raw Phone Orders: $phoneOrders');
      }

      // Gộp 2 danh sách đơn hàng và loại bỏ trùng lặp linh hoạt
      final Map<String, dynamic> uniqueOrdersMap = {};

      for (var order in [...emailOrders, ...phoneOrders]) {
        if (order != null) {
          // Dùng ID làm key, ép kiểu sang String để an toàn
          final String key = (order['id'] ?? order['orderCode'] ?? '')
              .toString();
          if (key.isNotEmpty) {
            uniqueOrdersMap[key] = order;
          }
        }
      }

      _orders = uniqueOrdersMap.values.toList();
      print('Total Unique Orders Found: ${_orders.length}');
      print('=== DEBUG END ===');

      // Sắp xếp đơn hàng mới nhất lên đầu (giảm dần theo thời gian)
      _orders.sort((a, b) {
        try {
          final String dateStrA = a['createdAt']?.toString() ?? '';
          final String dateStrB = b['createdAt']?.toString() ?? '';
          final dateA =
              DateTime.tryParse(dateStrA) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final dateB =
              DateTime.tryParse(dateStrB) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });
    } catch (e) {
      print('ERROR in OrderHistoryController.fetchOrders: $e');
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) async {
    try {
      final result = await apiService.updateOrderStatus(id, status);
      if (result['success'] == true) {
        // Update status locally without reloading the entire list
        final index = _orders.indexWhere((order) => order['id'] == id);
        if (index != -1) {
          _orders[index]['status'] = status;
          notifyListeners();
        }
      }
      return result;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }
}
