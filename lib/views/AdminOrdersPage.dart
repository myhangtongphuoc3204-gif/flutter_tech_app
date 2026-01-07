import 'package:flutter/material.dart';
import '../assets/inc/_adminorders.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/footer.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [Navbar(), AdminOrdersSection(), FooterSection()],
        ),
      ),
    );
  }
}
