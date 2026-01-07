import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            LoginSection(),
          ],
        ),
      ),
    );
  }
}