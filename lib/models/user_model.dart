import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserModel{

  @HiveField(0)
  String firstname;

  @HiveField(1)
  String lastname;

  @HiveField(2)
  String email;

  @HiveField(3)
  String mobilenumber;

  @HiveField(4)
  String country;

  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobilenumber,
    required this.country,
  });

}