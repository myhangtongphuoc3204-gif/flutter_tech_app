import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/RegisterController.dart';

class RegisterSection extends StatefulWidget {
  const RegisterSection({super.key});

  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _registerController = RegisterController();
  bool _agreeToTerms = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = "Bạn phải đồng ý với điều khoản sử dụng";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _registerController.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      confirmPassword: _repasswordController.text,
    );

    if (result['success']) {
      setState(() {
        _successMessage = "Đăng ký tài khoản thành công!";
      });
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _repasswordController.clear();
      setState(() {
        _agreeToTerms = false;
      });
    } else {
      String msg = result['message'] ?? "Đăng ký thất bại";
      if (result['data'] != null && result['data'] is Map) {
        final Map errors = result['data'];

        // Translation map for backend errors
        final Map<String, String> translations = {
          "Name is required": "Họ và tên là bắt buộc",
          "Email is required": "Email là bắt buộc",
          "Invalid email format": "Email không hợp lệ",
          "Password must be at least 6 characters":
              "Mật khẩu phải có ít nhất 6 ký tự",
          "Email already exists": "Email này đã được sử dụng",
        };

        final translatedErrors = errors.values.map((e) {
          String errStr = e.toString();
          // Check for partial matches like "Email already exists: test@test.com"
          for (var entry in translations.entries) {
            if (errStr.contains(entry.key)) {
              return entry.value;
            }
          }
          return errStr;
        }).toList();

        final errorDetails = translatedErrors.join("\n");
        if (errorDetails.isNotEmpty) {
          msg = "Lỗi đăng ký:\n$errorDetails";
        }
      } else {
        // Translate top-level message if found in map
        final Map<String, String> topLevelTranslations = {
          "Validation failed": "Dữ liệu không hợp lệ",
          "Email already exists": "Email này đã được sử dụng",
        };

        for (var entry in topLevelTranslations.entries) {
          if (msg.contains(entry.key)) {
            msg = entry.value;
            break;
          }
        }
      }

      setState(() {
        _errorMessage = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADER
                    Column(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.userPlus,
                          size: 64,
                          color: Color(0xFFE91E63),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Đăng Ký Tài Khoản',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // MESSAGES
                    if (_successMessage != null)
                      _alertBox(
                        _successMessage!,
                        const Color(0xFFD4EDDA),
                        const Color(0xFF155724),
                        const Color(0xFFC3E6CB),
                        FontAwesomeIcons.circleCheck,
                      ),
                    if (_errorMessage != null)
                      _alertBox(
                        _errorMessage!,
                        const Color(0xFFF8D7DA),
                        const Color(0xFF721C24),
                        const Color(0xFFF5C6CB),
                        FontAwesomeIcons.triangleExclamation,
                      ),

                    // NAME INPUT
                    _buildInputField(
                      controller: _nameController,
                      label: "Họ và tên *",
                      hint: "Nhập họ và tên",
                      icon: FontAwesomeIcons.user,
                    ),

                    const SizedBox(height: 20),

                    // EMAIL INPUT
                    _buildInputField(
                      controller: _emailController,
                      label: "Email *",
                      hint: "Nhập email",
                      icon: FontAwesomeIcons.envelope,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Vui lòng nhập email";
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Email không hợp lệ";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // PHONE INPUT
                    _buildInputField(
                      controller: _phoneController,
                      label: "Số điện thoại *",
                      hint: "Nhập số điện thoại",
                      icon: FontAwesomeIcons.phone,
                    ),

                    const SizedBox(height: 20),

                    // PASSWORD INPUT
                    _buildInputField(
                      controller: _passwordController,
                      label: "Mật khẩu *",
                      hint: "Nhập mật khẩu",
                      icon: FontAwesomeIcons.lock,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Vui lòng nhập mật khẩu";
                        if (value.length < 6)
                          return "Mật khẩu phải có ít nhất 6 ký tự";
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // CONFIRM PASSWORD INPUT
                    _buildInputField(
                      controller: _repasswordController,
                      label: "Xác nhận mật khẩu *",
                      hint: "Nhập lại mật khẩu",
                      icon: FontAwesomeIcons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),

                    // TERMS
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          activeColor: const Color(0xFFE91E63),
                          onChanged: (val) =>
                              setState(() => _agreeToTerms = val!),
                        ),
                        const Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Tôi đồng ý với ",
                              style: TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Điều khoản sử dụng",
                                  style: TextStyle(
                                    color: Color(0xFFE91E63),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // REGISTER BUTTON
                    ListenableBuilder(
                      listenable: _registerController,
                      builder: (context, _) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _registerController.isLoading
                                ? null
                                : _handleRegister,
                            icon: _registerController.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.userPlus,
                                    size: 16,
                                  ),
                            label: Text(
                              _registerController.isLoading
                                  ? 'Đang đăng ký...'
                                  : 'ĐĂNG KÝ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 6,
                            ),
                          ),
                        );
                      },
                    ),

                    // const SizedBox(height: 20),
                    // Center(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Text("Đã có tài khoản? "),
                    //       GestureDetector(
                    //         onTap: () => Navigator.pushReplacementNamed(
                    //           context,
                    //           '/login',
                    //         ),
                    //         child: const Text(
                    //           "Đăng nhập ngay",
                    //           style: TextStyle(
                    //             color: Color(0xFFE91E63),
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 14, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFF48FB1), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFF48FB1), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
            ),
          ),
          validator:
              validator ??
              (value) => value == null || value.isEmpty
                  ? "Trường này là bắt buộc"
                  : null,
        ),
      ],
    );
  }

  Widget _alertBox(
    String msg,
    Color bgColor,
    Color textColor,
    Color borderColor,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: FaIcon(icon, color: textColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(msg, style: TextStyle(color: textColor, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
