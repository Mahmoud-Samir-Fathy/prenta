class ProductModel {
   String? id;
   String? title;
   String? image;
   String? description;
   String? price;
   String? size;
   String? color;
   String? quantity;

  ProductModel({
     this.id,
     this.title,
     this.image,
     this.description,
     this.price,
     this.color,
     this.quantity,
  });

  ProductModel.fromJason(Map<String,dynamic>json){
    id=json['id'];
    title=json['title'];
    image=json['image'];
    description=json['description'];
    price=json['price'];
    color=json['color'];
    quantity=json['quantity'];
  }

  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'title':title,
      'image':image,
      'description':description,
      'price':price,
      'color':color,
      'quantity':quantity,
    };
  }
}
