import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_checkout.dart';
import '../assets/inc/footer.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            CheckoutSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}