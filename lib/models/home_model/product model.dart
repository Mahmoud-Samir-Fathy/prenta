class ProductModel {
   String? id;
   String? title;
   String? image;
   String? description;
   String? price;

  ProductModel({
     this.id,
     this.title,
     this.image,
     this.description,
     this.price,
  });

  ProductModel.fromJason(Map<String,dynamic>json){
    id=json['id'];
    title=json['title'];
    image=json['image'];
    description=json['description'];
    price=json['price'];
  }

  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'title':title,
      'image':image,
      'description':description,
      'price':price,

    };
  }
}
