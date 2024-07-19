class ProductModel {
   String? id;
   String? title;
   String? image;
   String? description;
   String? price;
   String? size;
   String? color;
   String? quantity;
   String? frontDesign;
   String? backDesign;
   String? status;
   String? review;
   double? stars;

  ProductModel({
     this.id,
     this.title,
     this.image,
     this.description,
     this.price,
     this.color,
     this.size,
     this.quantity,
     this.frontDesign,
     this.backDesign,
     this.status,
    this.review,
    this.stars
  });

  ProductModel.fromJason(Map<String,dynamic>json){
    id=json['id'];
    title=json['title'];
    image=json['image'];
    description=json['description'];
    price=json['price'];
    size=json['size'];
    color=json['color'];
    quantity=json['quantity'];
    frontDesign=json['frontDesign'];
    backDesign=json['backDesign'];
    status=json['status'];
    review = json['review'];
    stars = json['stars']?.toDouble();
  }

  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'title':title,
      'image':image,
      'description':description,
      'price':price,
      'size':size,
      'color':color,
      'quantity':quantity,
      'frontDesign':frontDesign,
      'backDesign':backDesign,
      'status':status,
      'review': review,
      'stars': stars,
    };
  }
}
