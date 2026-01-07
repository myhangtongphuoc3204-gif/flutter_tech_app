import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../model/dashboard_stats.dart';

class AdminDashboardSection extends StatefulWidget {
  const AdminDashboardSection({super.key});

  @override
  State<AdminDashboardSection> createState() => _AdminDashboardSectionState();
}

class _AdminDashboardSectionState extends State<AdminDashboardSection> {
  late Future<DashboardStats?> _statsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _statsFuture = _apiService.getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(minHeight: 600),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Column(
        children: [
          // TITLE
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.crown,
                    size: 48,
                    color: Color(0xFFAD1457),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAD1457),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Quản lý hệ thống thương hiệu HAPAS',
                style: TextStyle(fontSize: 20, color: Color(0xFF880E4F)),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // STATISTICS SECTION
          FutureBuilder<DashboardStats?>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Lỗi tải thống kê: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              final stats = snapshot.data!;
              final currencyFormat = NumberFormat.currency(
                locale: 'vi_VN',
                symbol: 'đ',
              );

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  // 1. Total Revenue
                  _buildStatCard(
                    title: 'Tổng Doanh Thu',
                    icon: FontAwesomeIcons.moneyBillWave,
                    content: Text(
                      currencyFormat.format(stats.monthlyRevenue),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                  ),

                  // 2. Order Status
                  _buildStatCard(
                    title: 'Đơn Hàng',
                    icon: FontAwesomeIcons.clipboardList,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.orderStatusCounts.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: const TextStyle(fontSize: 16)),
                              Text(
                                '${e.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAD1457),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // 3. Best Selling Products
                  _buildStatCard(
                    title: 'Sản Phẩm Hot',
                    icon: FontAwesomeIcons.fire,
                    content: Column(
                      children: stats.bestSellingProducts.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  p.image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.error, size: 40),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              Text(
                                '${p.totalSold}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // 4. Best Selling Categories
                  _buildStatCard(
                    title: 'Danh Mục Hot',
                    icon: FontAwesomeIcons.layerGroup,
                    content: Column(
                      children: stats.bestSellingCategories.map((c) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${c.totalSold}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAD1457),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 60),

          // CARDS
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // First Row: 3 items
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _buildAdminCard(
                      icon: FontAwesomeIcons.users,
                      title: 'Quản Lý Người Dùng',
                      description:
                          'Quản lý thông tin khách hàng, tài khoản người dùng và phân quyền hệ thống',
                      buttonIcon: FontAwesomeIcons.userGear,
                      buttonText: 'Truy Cập',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-user');
                      },
                    ),
                    _buildAdminCard(
                      icon: FontAwesomeIcons.tags,
                      title: 'Quản Lý Danh Mục',
                      description:
                          'Tạo, chỉnh sửa và quản lý các danh mục sản phẩm trong hệ thống',
                      buttonIcon: FontAwesomeIcons.list,
                      buttonText: 'Truy Cập',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-category');
                      },
                    ),
                    _buildAdminCard(
                      icon: FontAwesomeIcons.shoppingBag,
                      title: 'Quản Lý Sản Phẩm',
                      description:
                          'Thêm, sửa, xóa sản phẩm và quản lý kho hàng, giá cả của cửa hàng',
                      buttonIcon: FontAwesomeIcons.box,
                      buttonText: 'Truy Cập',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-products');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Second Row: 2 items
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _buildAdminCard(
                      icon: FontAwesomeIcons.receipt,
                      title: 'Quản Lý Đơn Hàng',
                      description:
                          'Theo dõi, xử lý và cập nhật trạng thái đơn hàng của khách hàng',
                      buttonIcon: FontAwesomeIcons.fileInvoice,
                      buttonText: 'Truy Cập',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-orders');
                      },
                    ),
                    _buildAdminCard(
                      icon: FontAwesomeIcons.star,
                      title: 'Quản Lý Đánh Giá',
                      description:
                          'Xem và quản lý các đánh giá sản phẩm từ khách hàng',
                      buttonIcon: FontAwesomeIcons.commentDots,
                      buttonText: 'Truy Cập',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-products-rating');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: 320,
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF48FB1)),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 24, color: const Color(0xFFAD1457)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF880E4F),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFFF48FB1)),
          Expanded(child: SingleChildScrollView(child: content)),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String title,
    required String description,
    required IconData buttonIcon,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: FaIcon(icon, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFAD1457),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onTap,
                icon: FaIcon(buttonIcon, size: 18),
                label: Text(buttonText, style: const TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
