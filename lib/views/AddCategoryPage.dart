import 'package:flutter/material.dart';
import '../assets/inc/_add-category.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/navbar.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [Navbar(), AddCategorySection(), FooterSection()],
        ),
      ),
    );
  }
}
