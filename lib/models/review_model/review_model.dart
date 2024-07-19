class ReviewModel {
  String? firstName;
  String? lastName;
  String? productTitle;
  String? productDescription;
  String? productImage;
  double? stars;
  String? review;
  String? price;
  String? id; // Changed 'Id' to 'id' for consistency

  ReviewModel({
    this.firstName,
    this.lastName,
    this.productTitle,
    this.productDescription,
    this.productImage,
    this.stars,
    this.review,
    this.price,
    this.id, // Changed 'Id' to 'id' for consistency
  });

  ReviewModel.fromJason(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    productTitle = json['productTitle'];
    productDescription = json['productDescription'];
    productImage = json['productImage'];
    stars = json['stars'] != null ? (json['stars'] as num).toDouble() : null;
    review = json['review'];
    price = json['price'];
    id = json['id']; // Changed 'Id' to 'id' for consistency
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'productTitle': productTitle,
      'productDescription': productDescription,
      'productImage': productImage,
      'stars': stars,
      'review': review,
      'price': price,
      'id': id, // Changed 'Id' to 'id' for consistency
    };
  }
}
