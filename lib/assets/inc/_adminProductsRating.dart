import 'package:flutter/material.dart';
import '../../controller/AdminProductsRatingController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminProductsRatingSection extends StatefulWidget {
  const AdminProductsRatingSection({super.key});

  @override
  State<AdminProductsRatingSection> createState() =>
      _AdminProductsRatingSectionState();
}

class _AdminProductsRatingSectionState
    extends State<AdminProductsRatingSection> {
  final AdminProductsRatingController _controller =
      AdminProductsRatingController();
  List<dynamic> _ratings = [];
  bool _isLoading = true;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    setState(() => _isLoading = true);
    final ratings = await _controller.getAllRatings();
    print("Ratings fetched in UI: ${ratings.length}");
    if (mounted) {
      setState(() {
        _ratings = ratings;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRating(int id) async {
    final success = await _controller.deleteRating(context, id);
    if (success) {
      setState(() {
        _successMessage = 'Xóa đánh giá thành công!';
      });
      _fetchRatings();
    }
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa đánh giá này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRating(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.star,
                    color: Color(0xFFAD1457),
                    size: 30,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Quản Lý Đánh Giá',
                    style: TextStyle(
                      color: Color(0xFFAD1457),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _fetchRatings,
                icon: const Icon(Icons.refresh, color: Color(0xFFAD1457)),
                tooltip: 'Làm mới',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // SUCCESS ALERT
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _successMessage != null ? 1.0 : 0.0,
            child: _successMessage != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildSuccessAlert(),
                  )
                : const SizedBox.shrink(),
          ),

          // TABLE CARD
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _ratings.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: Text(
                              'Chưa có đánh giá nào',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      : _buildRatingTable(),
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
        ],
      ),
    );
  }

  Widget _buildRatingTable() {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowHeight: 60,
        dataRowMaxHeight: 80, // Increased row height for images
        columnSpacing: 24,
        headingRowColor: WidgetStateProperty.all(const Color(0xFFCFE2FF)),
        columns: const [
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Sản Phẩm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Khách Hàng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Đánh Giá',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Bình Luận',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Thao Tác',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
        rows: _ratings.map((rating) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  rating['id'].toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Builder(
                        builder: (context) {
                          String imageUrl = rating['productImage'] ?? '';
                          if (imageUrl.isNotEmpty &&
                              !imageUrl.startsWith('http')) {
                            imageUrl =
                                'http://localhost:8080/api/products/image/$imageUrl';
                          }
                          // print('Displaying image: $imageUrl'); // Debug
                          return Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 150, // Limit width for product name
                      child: Text(
                        rating['productName'] ?? 'Không rõ',
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  rating['userName'] ?? 'Ẩn danh',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < (rating['rating'] ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: 300, // Wider comment column
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    rating['comment'] ?? '',
                    style: const TextStyle(fontSize: 15),
                    // No maxLines, let it wrap or constrained by height if needed.
                    // Since dataRowMaxHeight is 80, we might want to let it scroll or clamp lines.
                    // User asked to 'show all', so let's allow 3 lines and overflow ellipsis or similar.
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                ElevatedButton.icon(
                  onPressed: () => _showDeleteConfirmation(rating['id']),
                  icon: const FaIcon(FontAwesomeIcons.trash, size: 12),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
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
}
