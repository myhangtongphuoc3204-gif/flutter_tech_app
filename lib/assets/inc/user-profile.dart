import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controller/user-profileController.dart';

class UserProfileSection extends StatefulWidget {
  const UserProfileSection({super.key});

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  final UserProfileController _controller = UserProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(color: Color(0xFFFFF5FA)),
          constraints: const BoxConstraints(minHeight: 600),
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // HEADER
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFAD1457),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.userCircle,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Thông Tin Người Dùng',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BODY
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  label: 'Họ và tên',
                                  value: _controller.name,
                                  icon: FontAwesomeIcons.user,
                                  required: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInputField(
                                  label: 'Số điện thoại',
                                  value: _controller.phone,
                                  icon: FontAwesomeIcons.phone,
                                  required: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            label: 'Email',
                            value: _controller.email,
                            icon: FontAwesomeIcons.envelope,
                            readonly: true,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            label: 'Role',
                            value: _controller.role,
                            icon: FontAwesomeIcons.usersCog,
                            readonly: true,
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

  Widget _buildInputField({
    required String label,
    required String value,
    required IconData icon,
    bool required = false,
    bool readonly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFF3C3D5), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE4EF),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                  border: Border(right: BorderSide(color: Color(0xFFAD1457))),
                ),
                child: FaIcon(icon, color: const Color(0xFFAD1457), size: 16),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: readonly ? const Color(0xFFF8F9FA) : Colors.white,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: readonly ? Colors.grey[600] : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
