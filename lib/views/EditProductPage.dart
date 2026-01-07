import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/_edit-products.dart';
import '../model/product.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy đối tượng product truyền từ Navigator
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            EditProductSection(product: product),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
