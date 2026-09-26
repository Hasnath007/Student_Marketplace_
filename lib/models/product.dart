// 📦 Product Data Model
// 📌 কাজ: একটি পণ্য বা প্রোডাক্টের ফিল্ড সংজ্ঞায়িত করা (id, title, price, category, condition, description, imageUrl, sellerName, sellerCampus)

class Product {
  final String id;
  final String title;
  final double price;
  final String category;
  final String condition;
  final String description;
  final String imageUrl;
  final String sellerName;
  final String sellerCampus;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.condition,
    required this.description,
    required this.imageUrl,
    required this.sellerName,
    required this.sellerCampus,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? category,
    String? condition,
    String? description,
    String? imageUrl,
    String? sellerName,
    String? sellerCampus,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sellerName: sellerName ?? this.sellerName,
      sellerCampus: sellerCampus ?? this.sellerCampus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'condition': condition,
      'description': description,
      'imageUrl': imageUrl,
      'sellerName': sellerName,
      'sellerCampus': sellerCampus,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      condition: map['condition'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerCampus: map['sellerCampus'] ?? '',
    );
  }
}
