import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/AdminCategoryController.dart';
import '../../model/category.dart';

class AdminCategorySection extends StatefulWidget {
  const AdminCategorySection({super.key});

  @override
  State<AdminCategorySection> createState() => _AdminCategorySectionState();
}

class _AdminCategorySectionState extends State<AdminCategorySection> {
  final AdminCategoryController _controller = AdminCategoryController();
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _controller.fetchCategories();
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
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE AND ADD BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.tags,
                              size: 28,
                              color: Color(0xFFAD1457),
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Quản Lý Danh Mục',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAD1457),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/add-category',
                            );
                            if (result == true) {
                              setState(() {
                                _successMessage =
                                    'Thêm danh mục mới thành công!';
                              });
                              _controller.fetchCategories();
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                          label: const Text('Thêm Danh Mục'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF198754,
                            ), // btn-success
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
                    // HIỂN THỊ THÔNG BÁO XÓA THÀNH CÔNG THEO STYLE HTML
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _successMessage != null ? 1.0 : 0.0,
                      child: _successMessage != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: _buildSuccessAlert(),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // TABLE CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCategoryTable(),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/admindashboard',
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              size: 16,
                            ),
                            label: const Text(
                              'Quay Lại Dashboard',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63), // Hồng
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildCategoryTable() {
    if (_controller.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(color: Color(0xFFAD1457)),
        ),
      );
    }

    if (_controller.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Text(
            'Không có danh mục nào',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFCFE2FF)),
              columnSpacing: 30,
              horizontalMargin: 20,
              dataRowMinHeight: 70,
              dataRowMaxHeight: 70,
              headingTextStyle: const TextStyle(
                fontSize: 1.3 * 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Tên Danh Mục')),
                DataColumn(label: Text('Thao Tác')),
              ],
              rows: _controller.categories
                  .map((cat) => _buildCategoryRow(cat))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildCategoryRow(Category cat) {
    const cellStyle = TextStyle(fontSize: 1.1 * 16, color: Colors.black87);

    return DataRow(
      cells: [
        DataCell(Text(cat.id.toString(), style: cellStyle)),
        DataCell(Text(cat.name, style: cellStyle)),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/edit-category',
                      arguments: cat,
                    );
                    if (result == true) {
                      setState(() {
                        _successMessage = 'Cập nhật danh mục thành công!';
                      });
                      _controller.fetchCategories();
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 12),
                  label: const Text('Sửa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
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
                  onPressed: () => _confirmDelete(cat),
                  icon: const FaIcon(FontAwesomeIcons.trash, size: 12),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC3545),
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
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(Category cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa danh mục "${cat.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final result = await _controller.deleteCategory(cat.id);
              if (mounted) {
                Navigator.pop(context);
                if (result['success'] == true) {
                  setState(() {
                    _successMessage = 'Xóa danh mục thành công!';
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'] ?? 'Lỗi khi xóa')),
                  );
                }
              }
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
