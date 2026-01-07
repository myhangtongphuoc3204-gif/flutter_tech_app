import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';
import '../model/category.dart';
import '../model/dashboard_stats.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  //Lưu trữ & lấy thông tin người dùng
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  Future<void> _saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<void> _saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', phone);
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_phone');
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<void> _saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_role');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
  }
  //đăng ký
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': 'user', // Default role
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Đăng ký thất bại',
          'data':
              errorData['data'], 
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'message': 'Lỗi kết nối: Không thể kết nối đến server',
      };
    }
  }
  //đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login with email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true &&
            data['data'] != null &&
            data['data']['token'] != null) {
          await _saveToken(data['data']['token']);
          await _saveUserRole(data['data']['role']?.toUpperCase() ?? 'USER');

          if (data['data'] != null) {
            if (data['data']['email'] != null) {
              await _saveUserEmail(data['data']['email']);
            }
            if (data['data']['phone'] != null) {
              await _saveUserPhone(data['data']['phone']);
            }
            if (data['data']['name'] != null) {
              await _saveUserName(data['data']['name']);
            }
            if (data['data']['userId'] != null) {
              await _saveUserId(data['data']['userId']);
            }
          }

          return {'success': true, 'data': data['data']};
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Đăng nhập thất bại',
          };
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Email hoặc mật khẩu không đúng',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Lỗi kết nối: Không thể kết nối đến server',
      };
    }
  }
  //lấy danh sách sản phẩm
  Future<List<Product>> getActiveProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/active'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //lấy toàn bộ sản phẩm (admin)
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //lấy sản phẩm theo tên danh mục
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load products by category');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //tìm kiếm tương đối theo tên sản phẩm
  Future<List<Product>> searchProducts(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?keyword=$keyword'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to search products');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //lấy danh mục 
  Future<List<Category>> getActiveCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/active'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> categoriesJson = data['data'];
          return categoriesJson.map((json) => Category.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //tạo đơn hàng mới
  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Lỗi khi tạo đơn hàng',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //lấy toàn bộ đơn hàng (admin)
  Future<List<dynamic>> getAllOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching all orders: $e');
      return [];
    }
  }
  //lấy đơn hàng theo email của KH
  Future<List<dynamic>> getOrdersByCustomer(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/customer/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
  //lấy đơn hàng theo sđt của KH
  Future<List<dynamic>> getOrdersByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/phone/$phone'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching orders by phone: $e');
      return [];
    }
  }

  // ================= USER MANAGEMENT =================
  //lấy tất cả người dùng
  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'), // Corrected endpoint
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
  //xóa người dùng
  Future<Map<String, dynamic>> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi xóa người dùng'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //cập nhật người dùng
  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi cập nhật người dùng'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // ================= CATEGORY MANAGEMENT =================
  //lấy toàn bộ danh mục trong admin
  Future<List<dynamic>> getAllCategoriesForAdmin() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
  //xóa danh mục
  Future<Map<String, dynamic>> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi xóa danh mục'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //tạp danh mục
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi tạo danh mục'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //cập nhật danh mục
  Future<Map<String, dynamic>> updateCategory(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi cập nhật danh mục'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // ================= PRODUCT MANAGEMENT =================
  //xóa sản phẩm
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi xóa sản phẩm'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //tạo sản phẩm mới
  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi tạo sản phẩm'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //cập nhật sản phẩm
  Future<Map<String, dynamic>> updateProduct(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi cập nhật sản phẩm'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
//cập nhật trạng thái đơn hàng
  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/orders/$id/status?status=$status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {
        'success': false,
        'message': 'Lỗi khi cập nhật trạng thái đơn hàng',
      };
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // ================= PRODUCT RATING =================
  //gửi đánh giá sản phẩm
  Future<Map<String, dynamic>> createProductRating({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'Chưa đăng nhập'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/ratings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': productId,
          'userId': userId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi gửi đánh giá'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //lấy tất cả đánh giá
  Future<List<dynamic>> getAllRatings() async {
    try {
      print('Fetching all ratings from $baseUrl/ratings');
      final response = await http.get(
        Uri.parse('$baseUrl/ratings'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching ratings: $e');
      return [];
    }
  }
  //xóa đánh giá
  Future<Map<String, dynamic>> deleteRating(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/ratings/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false, 'message': 'Lỗi khi xóa đánh giá'};
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
  //lấy số liệu thống kê tổng quan
  Future<DashboardStats?> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return DashboardStats.fromJson(jsonDecode(response.body));
      }
      throw Exception('Server error: ${response.statusCode} ${response.body}');
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      throw Exception('Failed to load stats: $e');
    }
  }
}
