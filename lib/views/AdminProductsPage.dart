import 'package:flutter/material.dart';
import '../assets/inc/_adminproducts.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/navbar.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [Navbar(), AdminProductsSection(), FooterSection()],
        ),
      ),
    );
  }
}
