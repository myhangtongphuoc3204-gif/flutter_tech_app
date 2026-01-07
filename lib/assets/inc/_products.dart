import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../controller/productsController.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../../controller/CartController.dart';
import '../../controller/AuthController.dart';

class ProductsSection extends StatefulWidget {
  final String? initialSearchKeyword;
  const ProductsSection({super.key, this.initialSearchKeyword});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  final ProductsController _controller = ProductsController();
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  int _selectedCategoryId = 0; // 0 means 'All'

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Tải song song cả sản phẩm và danh mục
      final productFuture =
          widget.initialSearchKeyword != null &&
              widget.initialSearchKeyword!.isNotEmpty
          ? _controller.searchProducts(widget.initialSearchKeyword!)
          : _controller.getAllProducts();

      final results = await Future.wait([
        productFuture,
        _controller.getActiveCategories(),
      ]);

      final products = List<Product>.from(results[0] as Iterable);
      final categories = List<Category>.from(results[1] as Iterable);

      print('Loaded ${products.length} products');
      print('Loaded ${categories.length} categories');

      setState(() {
        _filteredProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Một số dữ liệu không thể tải')),
      );
    }
  }

  Future<void> _filterByCategory(int categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _isLoading = true;
    });

    try {
      List<Product> products;
      if (categoryId == 0) {
        products = await _controller.getAllProducts();
      } else {
        products = await _controller.getProductsByCategory(categoryId);
      }

      setState(() {
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error filtering products: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi lọc sản phẩm: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Category Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryButton(0, 'Tất Cả'),
                ..._categories.take(8).map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _buildCategoryButton(category.id, category.name),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Products List
          _isLoading
              ? const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                )
              : _filteredProducts.isEmpty
              ? const SizedBox(
                  height: 400,
                  child: Center(child: Text('Không có sản phẩm nào')),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: _filteredProducts.map((product) {
                      return _ProductCard(product: product);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(int categoryId, String label) {
    final isSelected = _selectedCategoryId == categoryId;
    return ElevatedButton(
      onPressed: () => _filterByCategory(categoryId),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.pink,
        side: const BorderSide(color: Colors.pink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return SizedBox(
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF48FB1), // viền hồng nhạt
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),

            // BODY
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFAD1457),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Description removed as it is not in Product model
                  const SizedBox(height: 12),
                  Text(
                    currencyFormatter.format(product.price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                ],
              ),
            ),

            // FOOTER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (!AuthController().isLoggedIn) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng đăng nhập để thực hiện chức năng này',
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    CartController().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm ${product.name} vào giỏ'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: const Color(0xFFE91E63),
                      ),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 14),
                  label: const Text('Thêm Vào Giỏ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
