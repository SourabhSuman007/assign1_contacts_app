import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'people.g.dart';

@HiveType(typeId: 0)
class People extends HiveObject{
  @HiveField(0)
  String fName;
  @HiveField(1)
  String lName;
  @HiveField(2)
  int phone;
  @HiveField(3)
  int age;

  People(
      {@required this.fName,
      @required this.lName,
      @required this.phone,
      this.age});
}
