import 'package:flutter/material.dart';
import '../assets/inc/navbar.dart';
import '../assets/inc/user-profile.dart';
import '../assets/inc/footer.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            UserProfileSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}