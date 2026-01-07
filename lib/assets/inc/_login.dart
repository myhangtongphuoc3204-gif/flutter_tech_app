import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/loginController.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = LoginController();
  bool _rememberMe = false;
  bool _isLoading = false;
  String _errorMessage = '';

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
                          FontAwesomeIcons.userCircle,
                          size: 64,
                          color: Color(0xFFE91E63),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Đăng Nhập',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ERROR MESSAGE
                    if (_errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8D7DA),
                          border: Border.all(color: const Color(0xFFF5C6CB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              size: 16,
                              color: Color(0xFF721C24),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(
                                  color: Color(0xFF721C24),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // EMAIL/PHONE INPUT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.envelope,
                              size: 14,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Email/ Số điện thoại',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailPhoneController,
                          decoration: InputDecoration(
                            hintText: 'Nhập email/ số điện thoại',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email hoặc số điện thoại';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // PASSWORD INPUT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.lock,
                              size: 14,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Mật khẩu',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Nhập mật khẩu',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // REMEMBER & FORGOT PASSWORD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFE91E63),
                            ),
                            const Text(
                              'Ghi nhớ đăng nhập',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleLogin,
                        icon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const FaIcon(
                                FontAwesomeIcons.rightToBracket,
                                size: 16,
                              ),
                        label: Text(
                          _isLoading ? 'Đang đăng nhập...' : 'Đăng Nhập',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
                    ),

                    const SizedBox(height: 20),

                    // REGISTER LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 16),
                    // const Text(
                    //   'Tài khoản demo:',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // const Text('Admin: admin@husc.edu.vn / password123'),
                    // const Text('User: nguyenvana@gmail.com / password123'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final result = await _loginController.login(
        _emailPhoneController.text,
        _passwordController.text,
      );

      if (result['success']) {
        await _loginController.navigateAfterLogin(context);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Đăng nhập thất bại';
        });
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}