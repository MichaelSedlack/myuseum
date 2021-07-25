import 'dart:ui';
import 'package:myuseum/login.dart';
import 'package:flutter/material.dart';
import 'package:myuseum/Utils/userInfo.dart';
import 'package:myuseum/Utils/getAPI.dart';

//lay out items in two columns and infinite rows
//How to click and open up a specific item

String collectionId = "";
void setCollectionId(String newId) {
  collectionId = newId;
}

class Items {
  String name = "";
  String collectionId = "";
  Items(String newName) {
    name = newName;
  }
  //image
  //tags
}

class ItemsRoute extends StatefulWidget {
  @override
  _ItemsRouteState createState() => _ItemsRouteState();
}

class _ItemsRouteState extends State<ItemsRoute> {
  //Need to get the list of available items from the backend
  final List<Items> _items = [];
  var index = 0;

  void getItems() {
    Map<String, String> content = {
      'id': getId(),
    };
    String registerURL = urlBase + "/users/items";
    print(registerURL);
    Register.getRegisterGetStatusCode(registerURL, content).then((value) {
      print('Status Code: ' + value);
      print(getId());
      if (value.compareTo("200") == 0) {
        Register.getRegisterGetBody(registerURL, content).then((value) {
          print('Value ' + value);
          for (int i = 0; i < value.length; i++) {}
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
