class WishlistItem {
  final String imageUrl;
  final String title;
  final String size;
  final double price;
  int quantity;

  WishlistItem({
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.price,
    this.quantity = 1,
  });
}