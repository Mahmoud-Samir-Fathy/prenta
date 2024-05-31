class Product {
  final String id;
  final String title;
  final String image;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }
}
