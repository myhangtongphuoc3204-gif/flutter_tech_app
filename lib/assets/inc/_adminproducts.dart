import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../controller/AdminProductsController.dart';

class AdminProductsSection extends StatefulWidget {
  const AdminProductsSection({super.key});

  @override
  State<AdminProductsSection> createState() => _AdminProductsSectionState();
}

class _AdminProductsSectionState extends State<AdminProductsSection> {
  final AdminProductsController _controller = AdminProductsController();
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'vi_VN');
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _controller.fetchAllData();
  }

  void _showDeleteConfirmation(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa sản phẩm "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _controller.deleteProduct(id);
              if (result['success'] == true) {
                setState(() {
                  _successMessage = 'Xóa sản phẩm thành công!';
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Lỗi khi xóa sản phẩm'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
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
                        FontAwesomeIcons.bagShopping,
                        color: Color(0xFFAD1457),
                        size: 30,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Quản Lý Sản Phẩm',
                        style: TextStyle(
                          color: Color(0xFFAD1457),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/add-product',
                      );
                      if (result == true) {
                        setState(() {
                          _successMessage = 'Thêm sản phẩm mới thành công!';
                        });
                        _controller.fetchAllData();
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                    label: const Text('Thêm Sản Phẩm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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
                      _controller.isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(48.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildProductTable(),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/admindashboard',
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            size: 16,
                          ),
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
      },
    );
  }

  Widget _buildProductTable() {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowHeight: 60,
        dataRowMaxHeight: 80,
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
              'Giá',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Kho',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Danh Mục',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Trạng Thái',
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
        rows: _controller.products.map((p) {
          return DataRow(
            cells: [
              DataCell(
                Text(p.id.toString(), style: const TextStyle(fontSize: 15)),
              ),
              DataCell(
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(p.name, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              DataCell(
                Text(
                  '${_currencyFormat.format(p.price)}đ',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataCell(
                Text(
                  p.quantity.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataCell(
                Text(
                  _controller.getCategoryName(p.categoryId),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/edit-product',
                          arguments: p,
                        );
                        if (result == true) {
                          setState(() {
                            _successMessage = 'Cập nhật sản phẩm thành công!';
                          });
                          _controller.fetchAllData();
                        }
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.penToSquare,
                        size: 12,
                      ),
                      label: const Text('Sửa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showDeleteConfirmation(p.id, p.name),
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
                  ],
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
