import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/products-rating.dart';
import '../assets/inc/footer.dart';

class ProductsRatingPage extends StatelessWidget {
  final dynamic order;

  const ProductsRatingPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            ProductsRatingSection(order: order),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
