import 'package:flutter/material.dart';
import '../../controller/AdminOrdersController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AdminOrdersSection extends StatefulWidget {
  const AdminOrdersSection({super.key});

  @override
  State<AdminOrdersSection> createState() => _AdminOrdersSectionState();
}

class _AdminOrdersSectionState extends State<AdminOrdersSection> {
  final AdminOrdersController _controller = AdminOrdersController();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
    _controller.fetchAllOrders();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  Future<void> _updateStatus(int id, String currentStatus) async {
    String? newStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Cập nhật trạng thái'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'PENDING'),
              child: const Text(
                'PENDING (Chờ xử lý)',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            // SimpleDialogOption(
            //   onPressed: () => Navigator.pop(context, 'PROCESSING'),
            //   child: const Text(
            //     'PROCESSING (Đang xử lý)',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'SHIPPED'),
              child: const Text(
                'SHIPPED (Đang giao)',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'DELIVERED'),
              child: const Text(
                'DELIVERED (Đã giao)',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'CANCELLED'),
              child: const Text(
                'CANCELLED (Đã hủy)',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (newStatus != null && newStatus != currentStatus) {
      final success = await _controller.updateOrderStatus(id, newStatus);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã cập nhật trạng thái đơn hàng $id thành $newStatus',
            ),
          ),
        );
      }
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    final s = status.toLowerCase();
    if (s == 'pending') return Colors.orange;
    if (s == 'pending') return Colors.orange;
    if (s == 'shipped') return Colors.purple;
    if (s == 'delivered') return Colors.green;
    if (s == 'cancelled') return Colors.red;
    return Colors.grey;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.receipt,
                        color: Color(0xFFAD1457),
                        size: 30,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Quản Lý Đơn Hàng',
                        style: TextStyle(
                          color: Color(0xFFAD1457),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _controller.fetchAllOrders(),
                    icon: const Icon(Icons.refresh, color: Color(0xFFAD1457)),
                    tooltip: 'Làm mới',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // FILTER BAR
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('Tất cả', 'ALL'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Pending', 'PENDING'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Shipped', 'SHIPPED'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Delivered', 'DELIVERED'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Cancelled', 'CANCELLED'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_controller.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_controller.filteredOrders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: Text("Không tìm thấy đơn hàng nào."),
                  ),
                )
              else
                ..._controller.filteredOrders.map(
                  (order) => _buildOrderCard(order),
                ),

              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/admindashboard',
                  ),
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16),
                  label: const Text('Quay Lại Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
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
                      'Khách hàng: ${order['customerName'] ?? 'N/A'} - Số điện thoại: ${order['phone'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(order['createdAt']),
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _updateStatus(order['id'], order['status']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          (order['status'] ?? 'UNKNOWN').toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
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
                                          child: Builder(
                                            builder: (context) {
                                              String imageUrl =
                                                  item['productImage'] ?? '';
                                              if (imageUrl.isNotEmpty &&
                                                  !imageUrl.startsWith(
                                                    'http',
                                                  )) {
                                                imageUrl =
                                                    'http://localhost:8080/api/products/image/$imageUrl';
                                              }
                                              return Image.network(
                                                imageUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      width: 50,
                                                      height: 50,
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        FontAwesomeIcons.image,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              );
                                            },
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
                                            'Số lượng: ${item['quantity'] ?? 0} × ${_currencyFormat.format(item['price']?.toInt() ?? 0)}đ',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_currencyFormat.format(item['subtotal']?.toInt() ?? 0)}đ',
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
                      '${_currencyFormat.format(order['totalAmount']?.toInt() ?? 0)}đ',
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

  Widget _buildFilterButton(String label, String status) {
    final bool isSelected = _controller.filterStatus == status;
    return InkWell(
      onTap: () {
        _controller.setFilter(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAD1457) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFAD1457) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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
}
