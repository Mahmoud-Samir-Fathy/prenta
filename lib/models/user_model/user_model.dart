class UserModel{
String? firstName;
String? lastName;
String? email;
String? password;
int? phoneNumber;

UserModel({
  this.firstName,
  this.lastName,
  this.email,
  this.password,
  this.phoneNumber,
});

UserModel.fromJason(Map<String,dynamic>json){
firstName=json['firstName'];
lastName=json['lastName'];
email=json['email'];
password=json['password'];
phoneNumber=json['phoneNumber'];
}

Map<String,dynamic>toMap(){
return{
  'firstName':firstName,
  'lastName':lastName,
  'email':email,
  'password':password,
  'phoneNumber':phoneNumber,
};
}

}