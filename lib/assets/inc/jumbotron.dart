import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JumbotronSection extends StatelessWidget {
  const JumbotronSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFEC407A), // hồng đậm
            Color(0xFFF06292), // hồng trung
            Color(0xFFF8BBD0), // hồng nhạt
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== TITLE =====
              const Text(
                'SIÊU THỊ CÔNG NGHỆ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== DESCRIPTION =====
              const Text(
                'Đồng hành cùng bạn trong từng lựa chọn công nghệ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // ===== MAIN BUTTONS =====
              Wrap(
                spacing: 20,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.shoppingBag, size: 18),
                    label: const Text('Mua Ngay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD81B60),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 34, vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.heart, size: 18),
                    label: const Text('Yêu Thích'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 34, vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // ===== DISCOVER =====
              OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.arrowDown, size: 16),
                label: const Text('Khám Phá Ngay'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
