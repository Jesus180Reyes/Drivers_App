import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class Users
{
  String id;
  String email;
  String name;
  int phone;

  Users({this.id, this.email, this.name, this.phone,});

  Users.fromSnapShot(DataSnapshot dataSnapshot)
  {
    id= dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];


  }
}