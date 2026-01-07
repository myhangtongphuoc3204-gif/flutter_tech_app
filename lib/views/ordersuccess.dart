import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_ordersuccess.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            OrderSuccessSection(),
          ],
        ),
      ),
    );
  }
}