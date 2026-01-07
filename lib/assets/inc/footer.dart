import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFAD1457), Color(0xFFE91E63)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Column(
        children: [
          // ================= TOP =================
          Wrap(
            spacing: 40,
            runSpacing: 30,
            children: [
              // BRAND
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        FaIcon(FontAwesomeIcons.shoppingBag,
                            color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Siêu thị công nghệ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mang cả thế giới công nghệ vào trong tầm tay bạn, với sản phẩm đa dạng, giá cả hợp lý và trải nghiệm mua sắm tiện lợi.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _socialIcon(FontAwesomeIcons.facebook),
                        _socialIcon(FontAwesomeIcons.instagram),
                        _socialIcon(FontAwesomeIcons.youtube),
                        _socialIcon(FontAwesomeIcons.tiktok),
                      ],
                    )
                  ],
                ),
              ),

              // PRODUCTS
              _footerList(
                title: 'Sản Phẩm',
                items: [
                  'Điện thoại',
                  'Laptop',
                  'Tablet',
                  'Tai nghe',
                ],
              ),

              // SUPPORT
              _footerList(
                title: 'Hỗ Trợ',
                items: [
                  'Liên Hệ',
                  'Hướng Dẫn',
                  'Bảo Hành',
                  'Đổi Trả',
                ],
              ),

              // CONTACT
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Liên Hệ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    _ContactItem(
                      FontAwesomeIcons.mapMarkerAlt,
                      '123 Đường Nguyễn Huệ, Quận 1, TP.HCM',
                    ),
                    _ContactItem(
                      FontAwesomeIcons.phone,
                      '1900-1234',
                    ),
                    _ContactItem(
                      FontAwesomeIcons.envelope,
                      'sieuthicongnghe@tech.com',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phương Thức Thanh Toán',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.ccVisa,
                            size: 32, color: Colors.white),
                        SizedBox(width: 12),
                        FaIcon(FontAwesomeIcons.ccMastercard,
                            size: 32, color: Colors.orange),
                        SizedBox(width: 12),
                        FaIcon(FontAwesomeIcons.mobileAlt,
                            size: 32, color: Colors.green),
                        SizedBox(width: 12),
                        FaIcon(FontAwesomeIcons.wallet,
                            size: 32, color: Colors.lightBlue),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white24),

          // ================= BOTTOM =================
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 10,
              children: const [
                Text(
                  '© 2025 SieuThiCongNghe. Tất cả quyền được bảo lưu.',
                  style: TextStyle(color: Colors.white70),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Chính Sách Bảo Mật',
                        style: TextStyle(color: Colors.white54)),
                    SizedBox(width: 20),
                    Text('Điều Khoản Sử Dụng',
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= COMPONENTS =================

Widget _socialIcon(IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: FaIcon(icon, color: Colors.white, size: 20),
  );
}

Widget _footerList({required String title, required List<String> items}) {
  return SizedBox(
    width: 180,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              item,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
        )
      ],
    ),
  );
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          FaIcon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
