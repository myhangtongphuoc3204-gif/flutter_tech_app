import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/ordersuccessController.dart';

class OrderSuccessSection extends StatelessWidget {
  const OrderSuccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderSuccessController();
    final dateStr = controller.orderDate != null
        ? "${controller.orderDate!.day}/${controller.orderDate!.month}/${controller.orderDate!.year}"
        : "";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Đặt Hàng Thành Công!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cảm ơn bạn đã mua hàng tại HAPAS. Đơn hàng của bạn đã được tiếp nhận và đang được xử lý.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: FontAwesomeIcons.receipt,
                          title: 'Thông tin đơn hàng',
                          items: [
                            'Mã đơn hàng: ${controller.orderId}',
                            'Ngày đặt: $dateStr',
                            'Trạng thái: Đang xử lý',
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoCard(
                          icon: FontAwesomeIcons.user,
                          title: 'Thông tin khách hàng',
                          items: [
                            'Họ tên: ${controller.customerName}',
                            'Email: ${controller.email}',
                            'Số điện thoại: ${controller.phone}',
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: FontAwesomeIcons.locationDot,
                          title: 'Địa chỉ giao hàng',
                          items: [
                            'Địa chỉ: ${controller.address}',
                            'Ghi chú: ${controller.notes}',
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InfoCard(
                          icon: FontAwesomeIcons.creditCard,
                          title: 'Phương thức',
                          items: [
                            'Giao hàng: ${controller.shippingMethod}',
                            'Thanh toán: ${controller.paymentMethod}',
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.boxOpen,
                            size: 18,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Chi tiết đơn hàng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...controller.items.map(
                        (item) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Số lượng: ${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _formatPrice(item.totalPrice.toInt()) + 'đ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 32, thickness: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Phí vận chuyển:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text('0đ', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _formatPrice(controller.totalAmount.toInt()) +
                                  'đ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/products');
                          },
                          icon: const FaIcon(FontAwesomeIcons.house, size: 18),
                          label: const Text(
                            'Về Trang Mua Sắm',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/order-history');
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.rectangleList,
                            size: 18,
                          ),
                          label: const Text(
                            'Xem Đơn Hàng',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE91E63),
                            side: const BorderSide(color: Color(0xFFE91E63)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// ================= INFO CARD =================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 16, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(item, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
