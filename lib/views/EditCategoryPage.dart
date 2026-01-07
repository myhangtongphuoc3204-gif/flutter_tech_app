import 'package:flutter/material.dart';
import '../assets/inc/_edit-category.dart';
import '../assets/inc/footer.dart';
import '../assets/inc/navbar.dart';
import '../model/category.dart';

class EditCategoryPage extends StatelessWidget {
  const EditCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nhận dữ liệu Category từ arguments
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Navbar(),
            EditCategorySection(category: category),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
