class UserModel{
String? firstName;
String? lastName;
String? email;
String? password;
String? phoneNumber;
String? profileImage;

UserModel({
  this.firstName,
  this.lastName,
  this.email,
  this.password,
  this.phoneNumber,
  this.profileImage
});

UserModel.fromJason(Map<String,dynamic>json){
firstName=json['firstName'];
lastName=json['lastName'];
email=json['email'];
password=json['password'];
phoneNumber=json['phoneNumber'];
profileImage=json['profileImage'];
}

Map<String,dynamic>toMap(){
return{
  'firstName':firstName,
  'lastName':lastName,
  'email':email,
  'password':password,
  'phoneNumber':phoneNumber,
  'profileImage':profileImage
};
}

}