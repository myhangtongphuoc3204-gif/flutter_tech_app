import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/order-historyController.dart';
import '../../views/products-rating.dart';

class OrderHistorySection extends StatefulWidget {
  const OrderHistorySection({super.key});

  @override
  State<OrderHistorySection> createState() => _OrderHistorySectionState();
}

class _OrderHistorySectionState extends State<OrderHistorySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderHistoryController().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = OrderHistoryController();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: CircularProgressIndicator(color: Color(0xFFE91E63)),
            ),
          );
        }

        final orders = controller.orders;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.clockRotateLeft,
                        size: 24,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Lịch sử đơn hàng',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // EMPTY STATE OR ORDERS
                  if (orders.isEmpty)
                    _EmptyOrdersWidget()
                  else
                    ...orders.map((order) => _OrderCard(order: order)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================= EMPTY ORDERS WIDGET =================
class _EmptyOrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons.bagShopping,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có đơn hàng nào',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy mua sắm ngay để có đơn hàng đầu tiên!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              icon: const FaIcon(FontAwesomeIcons.shoppingCart, size: 16),
              label: const Text('Mua sắm ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            FutureBuilder<List<String?>>(
              future: Future.wait([
                OrderHistoryController().apiService.getUserEmail(),
                OrderHistoryController().apiService.getUserPhone(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final email = snapshot.data![0];
                  final phone = snapshot.data![1];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Đang tìm theo: ${email ?? "N/A"} / ${phone ?? "N/A"}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ORDER CARD =================
class _OrderCard extends StatelessWidget {
  final dynamic order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC), // Light pink
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['orderCode'] ?? "Đơn hàng #${order['id']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD1457),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order['createdAt'] ?? ''),
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if ([
                      'pending',
                      'shipped',
                    ].contains(order['status']?.toString().toLowerCase()))
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () async {
                            final result = await OrderHistoryController()
                                .updateOrderStatus(order['id'], 'DELIVERED');
                            if (result['success'] != true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ?? 'Lỗi cập nhật',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Đã nhận được hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Nút Đánh giá sản phẩm - chỉ hiển thị khi status là DELIVERED
                    if (order['status']?.toString().toUpperCase() ==
                        'DELIVERED')
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductsRatingPage(order: order),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.star,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Đánh giá sản phẩm',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']?.toString()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(order['status']?.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (order['status']?.toString().toLowerCase() == 'pending')
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () async {
                            final result = await OrderHistoryController()
                                .updateOrderStatus(order['id'], 'cancelled');
                            if (result['success'] != true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'] ?? 'Lỗi cập nhật',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Hủy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // BODY
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // PRODUCTS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sản phẩm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (order['items'] != null && order['items'] is List)
                            ...(order['items'] as List).map<Widget>(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    // Product Image
                                    if (item['productImage'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            item['productImage'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        FontAwesomeIcons.image,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                    // Product info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['productName'] ?? 'Sản phẩm',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Số lượng: ${item['quantity'] ?? 0} × ${_formatPrice(item['price']?.toInt() ?? 0)}đ',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_formatPrice(item['subtotal']?.toInt() ?? 0)}đ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            const Text(
                              'Không có thông tin sản phẩm',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // SHIPPING INFO
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin nhận hàng',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow('Địa chỉ:', order['address'] ?? 'N/A'),
                          _InfoRow('SĐT:', order['phone'] ?? 'N/A'),
                          _InfoRow(
                            'Thanh toán:',
                            order['paymentMethod'] ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                // FOOTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng số tiền:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatPrice(order['totalAmount']?.toInt() ?? 0)}đ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    final s = status.toLowerCase();
    if (s.contains('pending') || s.contains('chờ')) return Colors.orange;
    if (s.contains('confirmed') || s.contains('xác nhận')) return Colors.cyan;
    if (s.contains('shipp') || s.contains('giao')) return Colors.blue;
    if (s.contains('deliver') ||
        s.contains('hoàn thành') ||
        s.contains('thành công'))
      return Colors.green;
    if (s.contains('cancel') || s.contains('hủy')) return Colors.red;
    if (s.contains('paid') || s.contains('thanh toán')) return Colors.teal;
    return Colors.grey;
  }

  String _getStatusText(String? status) {
    return status ?? 'N/A';
  }

  String _formatPrice(dynamic price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
