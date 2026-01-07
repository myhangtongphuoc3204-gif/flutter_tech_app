import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_adminuser.dart';
import '../assets/inc/footer.dart';

class AdminUserPage extends StatelessWidget {
  const AdminUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [Navbar(), AdminUserSection(), FooterSection()],
        ),
      ),
    );
  }
}
