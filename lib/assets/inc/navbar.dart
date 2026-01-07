import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/CartController.dart';
import '../../controller/AuthController.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.pushNamed(context, '/products', arguments: keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController();
    final authController = AuthController();

    return ListenableBuilder(
      listenable: Listenable.merge([cartController, authController]),
      builder: (context, child) {
        final isLoggedIn = authController.isLoggedIn;
        final userName = authController.userName;
        final role = authController.role;
        final cartCount = cartController.cartCount;

        return Column(
          children: [
            // ================= HEADER TOP =================
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFAD1457), Color(0xFFE91E63)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Hotline: 1900-1234',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'sieuthicongnghe@tech.com',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  const Text(
                    'Miễn phí vận chuyển cho mọi đơn hàng',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),

            // ================= NAVBAR =================
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE91E63), width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              child: Row(
                children: [
                  // BRAND

                  // MENU
                  Expanded(
                    child: Row(
                      children: [
                        _navItem(
                          'Trang Chủ',
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                        _navItem(
                          'Sản Phẩm',
                          onTap: () {
                            Navigator.pushNamed(context, '/products');
                          },
                        ),
                        if (isLoggedIn)
                          _userDropdown(context, userName, role, authController)
                        else ...[
                          _navItem(
                            'Đăng Ký',
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                          _navItem(
                            'Đăng Nhập',
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  // SEARCH + CART
                  Row(
                    children: [
                      // SEARCH FORM
                      Row(
                        children: [
                          Container(
                            width: 240,
                            height: 42,
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: (_) => _onSearch(),
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm sản phẩm...',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF48FB1),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF48FB1),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE91E63),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _onSearch,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE91E63),
                              side: const BorderSide(
                                color: Color(0xFFE91E63),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              minimumSize: const Size(50, 42),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // CART
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              minimumSize: const Size(50, 42),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.shoppingCart,
                              size: 16,
                            ),
                          ),
                          if (cartCount > 0)
                            Positioned(
                              right: -8,
                              top: -8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC3545),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Text(
                                  cartCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _navItem(String text, {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFFE91E63) : const Color(0xFF424242),
          ),
        ),
      ),
    );
  }

  Widget _userDropdown(
    BuildContext context,
    String userName,
    String role,
    AuthController authController,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'logout') {
          await authController.logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        } else if (value == 'profile') {
          Navigator.pushNamed(context, '/user-profile');
        } else if (value == 'orders') {
          Navigator.pushNamed(context, '/order-history');
        } else if (value == 'dashboard') {
          Navigator.pushNamed(context, '/admindashboard');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          role == 'admin' ? 'Hi, Admin' : 'Hi, $userName',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE91E63),
          ),
        ),
      ),
      color: Colors.white,
      itemBuilder: (context) => [
        if (role == 'admin') ...[
          PopupMenuItem(
            value: 'dashboard',
            child: Row(
              children: const [
                Icon(
                  FontAwesomeIcons.tableColumns,
                  size: 16,
                  color: Colors.black,
                ),
                SizedBox(width: 12),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(height: 1),
        ],
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                role == 'admin'
                    ? FontAwesomeIcons.userPen
                    : FontAwesomeIcons.user,
                size: 16,
                color: Colors.black,
              ),
              const SizedBox(width: 12),
              Text(
                role == 'admin' ? 'Profile' : 'Thông tin người dùng',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (role != 'admin') ...[
          const PopupMenuDivider(height: 1),
          PopupMenuItem(
            value: 'orders',
            child: Row(
              children: const [
                Icon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 16,
                  color: Colors.black,
                ),
                SizedBox(width: 12),
                Text(
                  'Lịch sử đơn hàng',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(
                FontAwesomeIcons.rightFromBracket,
                size: 16,
                color: Colors.red,
              ),
              SizedBox(width: 12),
              Text(
                'Đăng Xuất',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
