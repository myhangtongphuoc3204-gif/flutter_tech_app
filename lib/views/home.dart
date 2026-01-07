import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/jumbotron.dart';
import '../assets/inc/_products.dart';
import '../assets/inc/features.dart';
import '../assets/inc/newsletter.dart';
import '../assets/inc/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            JumbotronSection(),
            ProductsSection(),
            FeaturesSection(),
            NewsletterSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
