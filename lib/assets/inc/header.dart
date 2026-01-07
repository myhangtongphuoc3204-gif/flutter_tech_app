import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopBar(),
        _MainHeader(),
      ],
    );
  }
}

/* ================= TOP BAR ================= */

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB3125D),
            Color(0xFFE91E63),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.phone,
                  size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text('Hotline: 1900-1234',
                  style: TextStyle(color: Colors.white)),
              SizedBox(width: 16),
              FaIcon(FontAwesomeIcons.envelope,
                  size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text('bag@hapas.com',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.truck,
                  size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text('Miễn phí vận chuyển đơn từ 500k',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= MAIN HEADER ================= */

class _MainHeader extends StatelessWidget {
  const _MainHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          // LOGO
          Row(
            children: const [
              FaIcon(
                FontAwesomeIcons.bagShopping,
                size: 26,
                color: Color(0xFFE91E63),
              ),
              SizedBox(width: 8),
              Text(
                'HAPAS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
            ],
          ),

          const SizedBox(width: 40),

          // MENU
          Row(
            children: const [
              _MenuItem('Trang Chủ', active: true),
              _MenuItem('Sản Phẩm'),
              _MenuItem('Đăng Ký'),
              _MenuItem('Đăng Nhập'),
            ],
          ),

          const Spacer(),

          // SEARCH
          Container(
            width: 260,
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xFFF48FB1)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm túi xách...',
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // SEARCH BUTTON
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE91E63),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.search,
                  color: Colors.white, size: 16),
            ),
          ),

          const SizedBox(width: 16),

          // CART
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB3125D),
                      Color(0xFFE91E63),
                    ],
                  ),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.cartShopping,
                      color: Colors.white),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= MENU ITEM ================= */

class _MenuItem extends StatelessWidget {
  final String title;
  final bool active;

  const _MenuItem(this.title, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? const Color(0xFFE91E63) : Colors.black87,
        ),
      ),
    );
  }
}
