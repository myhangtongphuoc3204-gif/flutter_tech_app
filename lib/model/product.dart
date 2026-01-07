class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String status;
  final int categoryId;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.status,
    required this.categoryId,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'active',
      categoryId: json['categoryId'] ?? json['idCategory'] ?? 0,
      categoryName: json['categoryName'],
    );
  }
}