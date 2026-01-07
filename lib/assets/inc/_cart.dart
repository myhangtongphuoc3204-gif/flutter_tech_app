import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/CartController.dart';

class CartSection extends StatefulWidget {
  const CartSection({super.key});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartController(),
      builder: (context, child) {
        final cartController = CartController();
        final cartItems = cartController.items;
        final totalAmount = cartController.totalAmount;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT COLUMN - CART ITEMS
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // HEADER
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.shoppingCart,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Giỏ Hàng Của Bạn',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _clearAllCart(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 14,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Xóa Tất Cả',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // BODY
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // INFO
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.circleInfo,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Bạn đang có ${cartItems.length} sản phẩm trong giỏ hàng',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // CART ITEMS
                            if (cartItems.isNotEmpty)
                              ...cartItems.map(
                                (item) => _CartItem(
                                  cartItem: item,
                                  onUpdateQuantity: (quantity) =>
                                      cartController.updateQuantity(
                                        item.product.id,
                                        quantity,
                                      ),
                                  onDelete: () =>
                                      _deleteItem(context, item.product.id),
                                ),
                              )
                            else
                              _EmptyCart(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // RIGHT COLUMN - ORDER SUMMARY
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // HEADER
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.receipt,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tóm Tắt Đơn Hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // BODY
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // SUBTOTAL
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tạm tính:'),
                                Text('${_formatPrice(totalAmount.toInt())}đ'),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // SHIPPING
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phí vận chuyển:'),
                                Text(
                                  'Miễn phí',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 30),

                            // TOTAL
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tổng cộng:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${_formatPrice(totalAmount.toInt())}đ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // BUTTONS
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _checkout(context),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.creditCard,
                                      size: 16,
                                    ),
                                    label: const Text('Thanh Toán'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE91E63),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
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
                                    onPressed: () => _continueShopping(context),
                                    icon: const FaIcon(
                                      FontAwesomeIcons.bagShopping,
                                      size: 16,
                                    ),
                                    label: const Text('Tiếp Tục Mua Sắm'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFFE91E63),
                                      side: const BorderSide(
                                        color: Color(0xFFE91E63),
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteItem(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              CartController().removeFromCart(productId);
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _clearAllCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa tất cả sản phẩm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              CartController().clearCart();
              Navigator.pop(context);
            },
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
  }

  void _checkout(BuildContext context) {
    Navigator.pushNamed(context, '/checkout');
  }

  void _continueShopping(BuildContext context) {
    Navigator.pushNamed(context, '/products');
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// ================= CART ITEM =================
class _CartItem extends StatefulWidget {
  final CartItem cartItem;
  final Function(int) onUpdateQuantity;
  final VoidCallback onDelete;

  const _CartItem({
    required this.cartItem,
    required this.onUpdateQuantity,
    required this.onDelete,
  });

  @override
  State<_CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<_CartItem> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.cartItem.quantity.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE91E63), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // IMAGE & NAME
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.cartItem.product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.cartItem.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // QUANTITY
            SizedBox(
              width: 80,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // PRICE
            SizedBox(
              width: 100,
              child: Text(
                '${_formatPrice(widget.cartItem.product.price.toInt())}đ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ACTIONS
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    final quantity =
                        int.tryParse(_quantityController.text) ?? 1;
                    widget.onUpdateQuantity(quantity);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                  child: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 14),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: widget.onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                  child: const FaIcon(FontAwesomeIcons.trash, size: 14),
                ),
              ],
            ),
          ],
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

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}

// ================= EMPTY CART =================
class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.shoppingCart,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Giỏ hàng trống',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/products'),
              icon: const FaIcon(FontAwesomeIcons.bagShopping, size: 16),
              label: const Text('Tiếp Tục Mua Sắm'),
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
          ],
        ),
      ),
    );
  }
}
