class UserModel{

  String firstname;
  String lastname;
  String email;
  String mobilenumber;
  String country;

  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobilenumber,
    required this.country,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    firstname : json['firstname']??"",
    lastname: json["lastname"] ?? 0,
    email: json["email"]?? "",
    mobilenumber: json["mobilenumber"]?? "",
    country: json["country"]?? "",
  );


  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "mobilenumner": mobilenumber,
    "country": country,
  };

  static const String tableName = "user";

  static const String createTable = "CREATE TABLE $tableName ( "
      "firstname TEXT,"
      "lastname TEXT,"
      "email TEXT,"
      "mobilenumber TEXT,"
      "country TEXT)";

}