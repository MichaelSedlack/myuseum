import 'dart:ui';
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
  String description = "";
  Map item = <String, String>{};
  String roomId = "";
  String collectionId = "";
  Items(String newName, String newDescription, Map newItem, String newRoomId,
      String newCollectionId) {
    name = newName;
    description = newDescription;
    item = newItem;
    roomId = newRoomId;
    collectionId = newCollectionId;
  }
}

class ItemsRoute extends StatefulWidget {
  @override
  _ItemsRouteState createState() => _ItemsRouteState();
}

class _ItemsRouteState extends State<ItemsRoute> {
  //Need to get the list of available items from the backend
  final List<Items> _items = [];
  var index = 0;

//How do I get the UID to find Items?
  void getItems() {
    Map<String, String> content = {
      'id': getId(),
    };
    String registerURL = urlBase + "/users";
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
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text("He'd have you all unravel at the"),
          color: Colors.teal[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Heed not the rabble'),
          color: Colors.teal[200],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Sound of screams but the'),
          color: Colors.teal[300],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Who scream'),
          color: Colors.teal[400],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Revolution is coming...'),
          color: Colors.teal[500],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Revolution, they...'),
          color: Colors.teal[600],
        ),
      ],
    );
  }
}
