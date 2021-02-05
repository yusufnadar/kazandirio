import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  String userID;
  String userName;
  String email;
  var basket;

  User1({this.email, this.userID, this.userName, this.basket});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'basket': basket ?? 0,
      'email': email,
    };
  }

  User1.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        userName = map['userName'],
        basket = map['basket'],
        email = map['email'];

  factory User1.fromDoc(DocumentSnapshot source) =>
      User1.fromMap(source.data());
}
