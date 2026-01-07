import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/CartController.dart';
import '../../controller/ordersuccessController.dart';
import '../../services/api_service.dart';

class CheckoutSection extends StatefulWidget {
  const CheckoutSection({super.key});

  @override
  State<CheckoutSection> createState() => _CheckoutSectionState();
}

class _CheckoutSectionState extends State<CheckoutSection> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _customerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _wardController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedShipping = 'standard';
  String _selectedPayment = 'cod';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final apiService = ApiService();
    final email = await apiService.getUserEmail();
    final phone = await apiService.getUserPhone();
    final userName = await apiService.getUserName();

    if (mounted) {
      setState(() {
        if (email != null) _emailController.text = email;
        if (phone != null) _phoneController.text = phone;
        if (userName != null && userName.isNotEmpty) {
          _customerNameController.text = userName;
        } else if (_customerNameController.text.isEmpty && email != null) {
          _customerNameController.text = email.split('@')[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // CUSTOMER INFO CARD
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Thông Tin Khách Hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _customerNameController,
                                    label: 'Họ tên *',
                                    placeholder: 'Nhập họ tên',
                                    required: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _emailController,
                                    label: 'Email *',
                                    placeholder: 'Nhập email',
                                    required: true,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _phoneController,
                                    label: 'Số điện thoại *',
                                    placeholder: 'Nhập số điện thoại',
                                    required: true,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SHIPPING ADDRESS CARD
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Địa Chỉ Giao Hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _addressController,
                              label: 'Địa chỉ *',
                              placeholder: 'Số nhà, tên đường',
                              required: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cityController,
                                    label: 'Tỉnh/Thành phố *',
                                    placeholder: 'Nhập tỉnh/thành phố',
                                    required: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _wardController,
                                    label: 'Phường/Xã *',
                                    placeholder: 'Nhập phường/xã',
                                    required: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _notesController,
                              label: 'Ghi chú giao hàng',
                              placeholder:
                                  'Ghi chú thêm cho người giao túi xách...',
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SHIPPING METHOD CARD
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.shippingFast,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Phương Thức Giao Hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: RadioListTile<String>(
                          value: 'standard',
                          groupValue: _selectedShipping,
                          onChanged: (value) {
                            setState(() {
                              _selectedShipping = value!;
                            });
                          },
                          activeColor: const Color(0xFFE91E63),
                          title: const Text(
                            'Giao hàng tiêu chuẩn',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text('3-5 ngày làm việc'),
                          secondary: const Text(
                            'Miễn phí',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PAYMENT METHOD CARD
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.creditCard,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Phương Thức Thanh Toán',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            RadioListTile<String>(
                              value: 'cod',
                              groupValue: _selectedPayment,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPayment = value!;
                                });
                              },
                              activeColor: const Color(0xFFE91E63),
                              title: Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.moneyBillWave,
                                    size: 16,
                                    color: Color(0xFFE91E63),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Thanh toán khi nhận hàng (COD)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                'Thanh toán bằng tiền mặt khi nhận túi xách',
                              ),
                            ),
                            const SizedBox(height: 12),
                            RadioListTile<String>(
                              value: 'bank-transfer',
                              groupValue: _selectedPayment,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPayment = value!;
                                });
                              },
                              activeColor: const Color(0xFFE91E63),
                              title: Row(
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.buildingColumns,
                                    size: 16,
                                    color: Color(0xFFE91E63),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Chuyển khoản ngân hàng',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                'Chuyển khoản qua ATM/Internet Banking',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _goBackToCart,
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
                      label: const Text(
                        'Quay Lại Giỏ Hàng',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(180, 56),
                      ),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton.icon(
                      onPressed: _placeOrder,
                      icon: const FaIcon(
                        FontAwesomeIcons.shoppingCart,
                        size: 18,
                      ),
                      label: const Text(
                        'Đặt Hàng',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(200, 56),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // SECURITY NOTE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.shield,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Thông tin của bạn được bảo mật 100%',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
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
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập $label';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  void _goBackToCart() {
    Navigator.pushNamed(context, '/cart');
  }

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cartController = CartController();

      // Chuẩn bị dữ liệu cho API
      final orderData = {
        "customerName": _customerNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "address":
            '${_addressController.text}, ${_wardController.text}, ${_cityController.text}',
        "paymentMethod": _selectedPayment,
        "items": cartController.items
            .map(
              (item) => {
                "productId": item.product.id,
                "quantity": item.quantity,
              },
            )
            .toList(),
      };

      // Hiển thị loading (tùy chọn)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final result = await ApiService().createOrder(orderData);

      // Đóng loading
      if (mounted) Navigator.pop(context);

      if (result['success'] == true) {
        // Lấy mã đơn hàng thật từ server trả về
        final actualOrderCode = result['data'] != null
            ? result['data']['orderCode']
            : 'N/A';

        // Lưu thông tin vào OrderSuccessController để hiển thị ở trang tiếp theo
        OrderSuccessController().setOrderData(
          name: _customerNameController.text,
          mail: _emailController.text,
          tel: _phoneController.text,
          addr:
              '${_addressController.text}, ${_wardController.text}, ${_cityController.text}',
          note: _notesController.text.isEmpty
              ? 'Không có ghi chú'
              : _notesController.text,
          payment: _selectedPayment == 'cod'
              ? 'Thanh toán COD'
              : 'Chuyển khoản',
          shipping: 'Giao hàng tiêu chuẩn',
          cartItems: List.from(cartController.items),
          total: cartController.totalAmount,
          code: actualOrderCode ?? 'N/A',
        );

        // Xóa giỏ hàng sau khi đặt thành công
        cartController.clearCart();

        // Chuyển đến trang thành công
        if (mounted) Navigator.pushNamed(context, '/ordersuccess');
      } else {
        // Hiển thị lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi đặt hàng: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _wardController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
