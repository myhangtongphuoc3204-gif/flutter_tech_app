import 'CartController.dart';

class OrderSuccessController {
  // Singleton pattern
  static final OrderSuccessController _instance =
      OrderSuccessController._internal();
  factory OrderSuccessController() => _instance;
  OrderSuccessController._internal();

  String customerName = '';
  String email = '';
  String phone = '';
  String address = '';
  String notes = '';
  String paymentMethod = '';
  String shippingMethod = '';
  List<CartItem> items = [];
  double totalAmount = 0;
  String orderId = '';
  DateTime? orderDate;

  void setOrderData({
    required String name,
    required String mail,
    required String tel,
    required String addr,
    required String note,
    required String payment,
    required String shipping,
    required List<CartItem> cartItems,
    required double total,
    required String code,
  }) {
    customerName = name;
    email = mail;
    phone = tel;
    address = addr;
    notes = note;
    paymentMethod = payment;
    shippingMethod = shipping;
    items = List.from(cartItems);
    totalAmount = total;
    orderId = code;
    orderDate = DateTime.now();
  }
}
