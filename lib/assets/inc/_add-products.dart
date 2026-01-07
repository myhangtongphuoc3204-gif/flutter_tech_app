import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/Add-ProductsController.dart';

class AddProductSection extends StatefulWidget {
  const AddProductSection({super.key});

  @override
  State<AddProductSection> createState() => _AddProductSectionState();
}

class _AddProductSectionState extends State<AddProductSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _selectedImage;
  int? _selectedCategoryId;

  final AddProductsController _controller = AddProductsController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu
    _controller.fetchInitialData();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn ảnh sản phẩm')),
        );
        return;
      }
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn danh mục')));
        return;
      }

      final result = await _controller.createProduct(
        name: _nameController.text,
        image: _selectedImage!,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        categoryId: _selectedCategoryId!,
      );

      if (mounted) {
        if (result['success'] == true) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Lỗi khi thêm sản phẩm'),
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
        // Nếu đang tải dữ liệu thì hiện Loading
        if (_controller.isLoading) {
          return Container(
            height: 400,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Color(0xFFAD1457)),
          );
        }

        return Container(
          width: double.infinity,
          color: const Color(0xFFFFF5FA),
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER TIÊU ĐỀ ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.circlePlus,
                            color: Color(0xFFAD1457),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Thêm sản phẩm mới',
                            style: TextStyle(
                              color: Color(0xFFAD1457),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 14,
                        ),
                        label: const Text('Quay lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- CARD FORM ---
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. TÊN SẢN PHẨM
                            _buildLabel('Tên sản phẩm *'),
                            TextFormField(
                              controller: _nameController,
                              decoration: _buildInputDecoration(
                                'Nhập tên sản phẩm',
                              ),
                              validator: (val) => (val == null || val.isEmpty)
                                  ? 'Vui lòng nhập tên'
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            // 2. COMBOBOX CHỌN ẢNH (DƯỚI TÊN, TRÊN GIÁ/SỐ LƯỢNG)
                            _buildLabel('Ảnh sản phẩm *'),
                            DropdownButtonFormField<String>(
                              value: _selectedImage,
                              isExpanded: true,
                              decoration: _buildInputDecoration(
                                'Chọn ảnh từ dữ liệu',
                              ),
                              items: _controller.availableImages
                                  .where((img) => img.isNotEmpty)
                                  .toSet() // Đảm bảo không trùng value
                                  .map((img) {
                                    return DropdownMenuItem<String>(
                                      value: img,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: Image.network(
                                              img,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 20,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              img,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedImage = val),
                              validator: (val) =>
                                  val == null ? 'Vui lòng chọn ảnh' : null,
                            ),
                            const SizedBox(height: 20),

                            // 3. GIÁ VÀ SỐ LƯỢNG (DÒNG NGANG)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Giá bán *'),
                                      TextFormField(
                                        controller: _priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: _buildInputDecoration('0'),
                                        validator: (val) =>
                                            (val == null || val.isEmpty)
                                            ? 'Nhập giá'
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Số lượng *'),
                                      TextFormField(
                                        controller: _quantityController,
                                        keyboardType: TextInputType.number,
                                        decoration: _buildInputDecoration('0'),
                                        validator: (val) =>
                                            (val == null || val.isEmpty)
                                            ? 'Nhập số lượng'
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 4. DANH MỤC
                            _buildLabel('Danh mục *'),
                            DropdownButtonFormField<int>(
                              value: _selectedCategoryId,
                              isExpanded: true,
                              decoration: _buildInputDecoration(
                                'Chọn danh mục',
                              ),
                              items: _controller.categories.map((cat) {
                                return DropdownMenuItem<int>(
                                  value: cat.id,
                                  child: Text(cat.name),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCategoryId = val),
                              validator: (val) =>
                                  val == null ? 'Chọn danh mục' : null,
                            ),
                            const SizedBox(height: 40),

                            // 5. NÚT THAO TÁC
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _controller.isSubmitting
                                      ? null
                                      : _submit,
                                  icon: _controller.isSubmitting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const FaIcon(
                                          FontAwesomeIcons.floppyDisk,
                                          size: 14,
                                        ),
                                  label: const Text(
                                    'Lưu sản phẩm',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFAD1457),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: const Text('Hủy'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET HỖ TRỢ ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFAD1457),
          fontSize: 16,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
