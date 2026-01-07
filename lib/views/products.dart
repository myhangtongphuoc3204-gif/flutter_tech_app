import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_products.dart';
import '../assets/inc/footer.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? searchKeyword =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            ProductsSection(initialSearchKeyword: searchKeyword),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
