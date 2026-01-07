import 'package:flutter/material.dart';
import '../assets/inc/_admincategory.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/navbar.dart';

class AdminCategoryPage extends StatelessWidget {
  const AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [Navbar(), AdminCategorySection(), FooterSection()],
        ),
      ),
    );
  }
}
