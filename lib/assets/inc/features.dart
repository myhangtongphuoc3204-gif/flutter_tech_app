import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      color: const Color(0xFFFCE4EC), // --light-color
      child: Column(
        children: [
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureBox(
                icon: FontAwesomeIcons.gem,
                title: 'Chất Lượng Cao Cấp',
                description: 'Chạm là mua, dùng là thích',
              ),
              _FeatureBox(
                icon: FontAwesomeIcons.shippingFast,
                title: 'Giao Hàng Nhanh',
                description: 'Giao hàng trong 24h',
              ),
              _FeatureBox(
                icon: FontAwesomeIcons.shieldAlt,
                title: 'Bảo Hành 12 Tháng',
                description: 'Bảo hành chính hãng toàn quốc',
              ),
              _FeatureBox(
                icon: FontAwesomeIcons.undo,
                title: 'Đổi Trả Miễn Phí',
                description: 'Đổi trả trong vòng 7 ngày',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= FEATURE BOX =================
class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureBox({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(32), // 2rem = 32px
      decoration: BoxDecoration(
        color: Colors.white, // --white-color
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF48FB1), // --primary-light
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          FaIcon(
            icon,
            size: 48, // fa-3x
            color: const Color(0xFFE91E63), // --primary-color
          ),
          const SizedBox(height: 16), // mb-3
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18, // h5
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
