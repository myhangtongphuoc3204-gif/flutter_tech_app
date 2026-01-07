class DashboardStats {
  final double monthlyRevenue;
  final Map<String, int> orderStatusCounts;
  final List<ProductSales> bestSellingProducts;
  final List<CategorySales> bestSellingCategories;

  DashboardStats({
    required this.monthlyRevenue,
    required this.orderStatusCounts,
    required this.bestSellingProducts,
    required this.bestSellingCategories,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      orderStatusCounts: Map<String, int>.from(
        (json['orderStatusCounts'] ?? {}).map((k, v) => MapEntry(k, v)),
      ),
      bestSellingProducts: (json['bestSellingProducts'] as List)
          .map((e) => ProductSales.fromJson(e))
          .toList(),
      bestSellingCategories: (json['bestSellingCategories'] as List)
          .map((e) => CategorySales.fromJson(e))
          .toList(),
    );
  }
}

class ProductSales {
  final String name;
  final String image;
  final int totalSold;

  ProductSales({
    required this.name,
    required this.image,
    required this.totalSold,
  });

  factory ProductSales.fromJson(Map<String, dynamic> json) {
    return ProductSales(
      name: json['name'],
      image: json['image'] ?? '',
      totalSold: json['totalSold'],
    );
  }
}

class CategorySales {
  final String name;
  final int totalSold;

  CategorySales({required this.name, required this.totalSold});

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(name: json['name'], totalSold: json['totalSold']);
  }
}
