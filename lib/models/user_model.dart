class UserModel {
  String? uid;
  String? userType;
  String? email;
  String? name;
  String? password;
  int? phoneNumber;
  String? collegeName;
  int? year;

  UserModel({this.uid, this.email, this.name, this.password,this.userType,this.phoneNumber,this.collegeName,this.year});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      userType: map['userType'],
      phoneNumber: map['phoneNumber'],
      collegeName: map['collegeName'],
      year: map['year'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'password': password,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'collegeName': collegeName,
      'year': year,
    };
  }
}