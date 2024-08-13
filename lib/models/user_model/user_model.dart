class UserModel{
String? firstName;
String? lastName;
String? email;
String? password;
String? phoneNumber;
String? profileImage;
String? city;
String? area;
String? streetName;
String? building;
String? floor;
bool? isEmailAndPassword;

UserModel({
  this.firstName,
  this.lastName,
  this.email,
  this.password,
  this.phoneNumber,
  this.profileImage,
  this.city,
  this.area,
  this.streetName,
  this.building,
  this.floor,
  this.isEmailAndPassword = true, // Default to false

});

UserModel.fromJason(Map<String,dynamic>json){
firstName=json['firstName'];
lastName=json['lastName'];
email=json['email'];
password=json['password'];
phoneNumber=json['phoneNumber'];
profileImage=json['profileImage'];
city=json['city'];
area=json['area'];
streetName=json['streetName'];
building=json['building'];
floor=json['floor'];
isEmailAndPassword = json['isEmailAndPassword'] ?? true; // Default to false if null


}

Map<String,dynamic>toMap(){
return{
  'firstName':firstName,
  'lastName':lastName,
  'email':email,
  'password':password,
  'phoneNumber':phoneNumber,
  'profileImage':profileImage,
  'city':city,
  'area':area,
  'streetName':streetName,
  'building':building,
  'floor':floor,
  'isEmailAndPassword':isEmailAndPassword,
};
}

}