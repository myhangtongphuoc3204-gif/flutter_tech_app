import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_cart.dart';
import '../assets/inc/footer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            CartSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}