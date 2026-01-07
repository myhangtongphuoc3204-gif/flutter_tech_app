import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/Add-categoryController.dart';

class AddCategorySection extends StatefulWidget {
  const AddCategorySection({super.key});

  @override
  State<AddCategorySection> createState() => _AddCategorySectionState();
}

class _AddCategorySectionState extends State<AddCategorySection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final AddCategoryController _controller = AddCategoryController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await _controller.createCategory(_nameController.text);

      if (mounted) {
        if (result['success'] == true) {
          Navigator.pop(
            context,
            true,
          ); // Trả về true để trang danh sách hiện thông báo
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Lỗi khi thêm danh mục'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CARD HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFAD1457),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.circlePlus,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Thêm danh mục mới',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CARD BODY
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tên danh mục *',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Nhập tên danh mục',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập tên danh mục';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                // BUTTONS
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.arrowLeft,
                                        size: 14,
                                      ),
                                      label: const Text('Quay lại'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey[700],
                                        side: BorderSide(
                                          color: Colors.grey[400]!,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _controller.isSubmitting
                                          ? null
                                          : _submit,
                                      icon: _controller.isSubmitting
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const FaIcon(
                                              FontAwesomeIcons.floppyDisk,
                                              size: 14,
                                            ),
                                      label: const Text('Thêm danh mục'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFAD1457,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
