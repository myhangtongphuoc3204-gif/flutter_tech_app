import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCE4EC), // bg-light với tone hồng nhạt giống features
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const Text(
                'Đăng Ký Nhận Tin Khuyến Mãi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // ===== FORM =====
              Row(
                children: [
                  // EMAIL INPUT
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF48FB1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Nhập email của bạn',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // SUBMIT BUTTON
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.paperPlane,
                      size: 14,
                    ),
                    label: const Text('Đăng Ký'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
