import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/_add-products.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [Navbar(), AddProductSection(), FooterSection()],
        ),
      ),
    );
  }
}
