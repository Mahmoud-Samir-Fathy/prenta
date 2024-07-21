class FavouriteModel{
  bool? isFavourite;
  String? productTittle;
  String? productDescription;
  String? productImage;
  String? productPrice;

  FavouriteModel({
    this.isFavourite=false,
    this.productTittle,
    this.productDescription,
    this.productImage,
    this.productPrice,
});


  FavouriteModel.fromJason(Map<String,dynamic>json){
   isFavourite= json['isFavourite']??false;
   productTittle= json['productTittle'];
   productDescription= json['productDescription'];
   productImage= json['productImage'];
   productPrice= json['productPrice'];
  }

  Map<String,dynamic>toMap(){
    return {
      'isFavourite': isFavourite,
      'productTittle': productTittle,
      'productDescription': productDescription,
      'productImage': productImage,
      'productPrice': productPrice,
    };
  }
}