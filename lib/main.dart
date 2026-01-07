import 'package:flutter/material.dart';
import 'views/login.dart';
import 'views/products.dart';
import 'views/cart.dart';
import 'views/checkout.dart';
import 'views/ordersuccess.dart';
import 'views/order-history.dart';
import 'views/user-profile.dart';
import 'views/home.dart';
import 'views/admindashboard.dart';
import 'views/adminuser.dart';
import 'views/AdminCategoryPage.dart';
import 'views/AddCategoryPage.dart';
import 'views/EditCategoryPage.dart';
import 'views/AdminProductsPage.dart';
import 'views/AddProductPage.dart';
import 'views/EditProductPage.dart';
import 'views/AdminProductsRatingPage.dart';
import 'views/AdminOrdersPage.dart';
import 'views/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Siêu Thị Công Nghệ',
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/products': (context) => const ProductsPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/ordersuccess': (context) => const OrderSuccessPage(),
        '/order-history': (context) => const OrderHistoryPage(),
        '/user-profile': (context) => const UserProfilePage(),
        '/admindashboard': (context) => const AdminDashboardPage(),
        '/admin-user': (context) => const AdminUserPage(),
        '/admin-category': (context) => const AdminCategoryPage(),
        '/add-category': (context) => const AddCategoryPage(),
        '/edit-category': (context) => const EditCategoryPage(),
        '/admin-products': (context) => const AdminProductsPage(),
        '/add-product': (context) => const AddProductPage(),
        '/edit-product': (context) => const EditProductPage(),
        '/admin-products-rating': (context) => const AdminProductsRatingPage(),
        '/admin-orders': (context) => const AdminOrdersPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
