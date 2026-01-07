import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/AdminUserController.dart';
import '../../model/user.dart';

class AdminUserSection extends StatefulWidget {
  const AdminUserSection({super.key});

  @override
  State<AdminUserSection> createState() => _AdminUserSectionState();
}

class _AdminUserSectionState extends State<AdminUserSection> {
  final AdminUserController _controller = AdminUserController();
  String? _successMessage; // Biến lưu thông báo thành công

  @override
  void initState() {
    super.initState();
    _controller.fetchUsers();
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
          padding: const EdgeInsets.symmetric(vertical: 48), // py-5
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE (Container-fluid px-4)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ), // px-4 approx
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.users,
                          size: 28,
                          color: Color(0xFFAD1457),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Quản Lý Người Dùng',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFAD1457),
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

              // TABLE CARD (row col-12)
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
                    padding: const EdgeInsets.all(24), // p-4
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUserTable(),
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

  // ============== GIAO DIỆN THÔNG BÁO THÀNH CÔNG (STYLE HTML) ==============
  Widget _buildSuccessAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA), // #e6f4ea
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB7E1CD)), // #b7e1cd
      ),
      child: Row(
        children: [
          // Icon vế trái
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF1E8E3E), // #1e8e3e
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
          // Nội dung text
          Expanded(
            child: Text(
              _successMessage ?? '',
              style: const TextStyle(
                color: Color(0xFF1E4620), // #1e4620
                fontSize: 15,
              ),
            ),
          ),
          // Nút đóng (X)
          GestureDetector(
            onTap: () {
              setState(() {
                _successMessage = null;
              });
            },
            child: const Icon(
              Icons.close,
              size: 20,
              color: Color(0xFF5F6368), // #5f6368
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTable() {
    if (_controller.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(color: Color(0xFFAD1457)),
        ),
      );
    }

    if (_controller.users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Text(
            'Không có người dùng nào',
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
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFCFE2FF),
              ),
              columnSpacing: 30, // Fixed safe spacing
              horizontalMargin: 20,
              dataRowHeight: 70,
              headingTextStyle: const TextStyle(
                fontSize: 1.3 * 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Họ Tên')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Số Điện Thoại')),
                DataColumn(label: Text('Phân Quyền')),
                DataColumn(label: Text('Thao Tác')),
              ],
              rows: _controller.users
                  .map((user) => _buildUserRow(user))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildUserRow(User user) {
    const cellStyle = TextStyle(fontSize: 1.1 * 16, color: Colors.black87);

    return DataRow(
      cells: [
        DataCell(Text(user.id.toString(), style: cellStyle)),
        DataCell(Text(user.name, style: cellStyle)),
        DataCell(Text(user.email, style: cellStyle)),
        DataCell(Text(user.phone, style: cellStyle)),
        DataCell(Text(user.role, style: cellStyle)),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(user),
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
                  onPressed: () => _confirmDelete(user),
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
                const SizedBox(
                  width: 10,
                ), // Thêm khoảng cách lề phải để không bị mất nút
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(User user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final roleController = TextEditingController(text: user.role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa người dùng: ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Họ Tên'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Số Điện Thoại'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Phân Quyền (admin/user)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await _controller.updateUser(user.id, {
                'name': nameController.text,
                'phone': phoneController.text,
                'role': roleController.text,
              });
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result['message'] ?? 'Đã cập nhật')),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa người dùng "${user.name}"?'),
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
              final result = await _controller.deleteUser(user.id);
              if (mounted) {
                Navigator.pop(context);
                if (result['success'] == true) {
                  setState(() {
                    _successMessage = 'Xóa người dùng thành công!';
                  });
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
