import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/Products-ratingController.dart';

class ProductsRatingSection extends StatefulWidget {
  final dynamic order;

  const ProductsRatingSection({super.key, required this.order});

  @override
  State<ProductsRatingSection> createState() => _ProductsRatingSectionState();
}

class _ProductsRatingSectionState extends State<ProductsRatingSection> {
  final ProductsRatingController _controller = ProductsRatingController();
  final Map<int, int> _ratings = {};
  final Map<int, TextEditingController> _commentControllers = {};
  String? _successMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.order['items'] != null) {
      for (var item in widget.order['items']) {
        final productId = item['productId'] as int;
        _ratings[productId] = 5;
        _commentControllers[productId] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.order['items'] as List? ?? [];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.star,
                    size: 24,
                    color: Color(0xFF9C27B0),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Đánh giá sản phẩm',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // SUCCESS ALERT
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildSuccessAlert(),
                ),

              Text(
                'Đơn hàng: ${widget.order['orderCode'] ?? '#${widget.order['id']}'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // PRODUCT LIST
              ...items.map((item) => _buildProductRatingCard(item)),

              const SizedBox(height: 24),

              // BUTTONS ROW
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gửi đánh giá button
                    ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitAllRatings,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
                      label: const Text('Gửi đánh giá'),
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
                    const SizedBox(width: 16),
                    // Quay lại button
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16),
                      label: const Text('Quay lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB7E1CD)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF1E8E3E),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '✓',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _successMessage ?? '',
              style: const TextStyle(color: Color(0xFF1E4620), fontSize: 15),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _successMessage = null;
              });
            },
            child: const Icon(Icons.close, size: 20, color: Color(0xFF5F6368)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRatingCard(dynamic item) {
    final productId = item['productId'] as int;
    final currentRating = _ratings[productId] ?? 5;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.purple.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info
            Row(
              children: [
                if (item['productImage'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['productImage'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(
                          FontAwesomeIcons.image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['productName'] ?? 'Sản phẩm',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Số lượng: ${item['quantity']}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Star Rating
            const Text(
              'Đánh giá của bạn:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _ratings[productId] = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: FaIcon(
                      index < currentRating
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      size: 28,
                      color: Colors.amber,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Comment
            TextField(
              controller: _commentControllers[productId],
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Nhập nhận xét của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFE91E63),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAllRatings() async {
    setState(() {
      _isSubmitting = true;
    });

    int successCount = 0;
    int totalCount = _ratings.length;

    for (var entry in _ratings.entries) {
      final productId = entry.key;
      final rating = entry.value;
      final comment = _commentControllers[productId]?.text ?? '';

      final result = await _controller.submitRating(
        productId: productId,
        rating: rating,
        comment: comment,
      );

      if (result['success'] == true) {
        successCount++;
      }
    }

    setState(() {
      _isSubmitting = false;
      if (successCount == totalCount) {
        _successMessage = 'Đánh giá thành công tất cả $successCount sản phẩm!';
      } else {
        _successMessage =
            'Đã gửi $successCount/$totalCount đánh giá thành công!';
      }
    });
  }
}
