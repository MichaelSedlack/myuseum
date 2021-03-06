import 'dart:ui';
import 'dart:convert';
import 'package:myuseum/main.dart';
import 'package:myuseum/login.dart';
import 'package:flutter/material.dart';
import 'package:myuseum/Utils/userInfo.dart';
import 'package:myuseum/Utils/getAPI.dart';

String collectionId = "";
void setCollectionId(String newId) {
  collectionId = newId;
}

class Items {
  String name = "", description = "", itemId = "", collectionId = "", roomId = "", uid = "";
  Map<String, dynamic> item = {};
  Items(String newName, String newDescription, Map<String, dynamic> newItem, String newItemId, String newRoomId, String newCollectionId, String newUid) {
    name = newName;
    description = newDescription;
    item = newItem;
    itemId = newItemId;
    collectionId = newCollectionId;
    roomId = newRoomId;
    uid = newUid;
  }
}

//Do we need the room ID for this?
class ItemsRoute extends StatefulWidget {
  final String collectionId, roomId;

  const ItemsRoute({Key? key, required this.roomId, required this.collectionId}) : super(key: key);
  @override
  _ItemsRouteState createState() => _ItemsRouteState();
}

class _ItemsRouteState extends State<ItemsRoute> {
  //Need to get the list of available items from the backend
  final List<Items> _items = [];
  var index = 0;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  //Need to get the tags from its collection here
  void getItems() {
    Map<String, String> content = {
      'id': widget.collectionId,
    };
    String registerURL = urlBase + "/collections/single";
    print(registerURL);
    Register.getRegisterGetStatusCode(registerURL, content).then((value) {
      print('Status Code: ' + value);
      if (value.compareTo("200") == 0) {
        Register.getRegisterGetBody(registerURL, content).then((value) {
          _items.clear();
          Map<String, dynamic> items = json.decode(value);
          for (int i = 0; i < items['items'].length; i++) {
            print(items['items'][i]);
            _items.add(Items(
                items['items'][i]['name'],
                items['items'][i]['description'],
                //These arent two arrays, these are a map
                items['items'][i]['item'],
                /*******************************/
                items['items'][i]['id'],
                items['items'][i]['roomID'],
                items['items'][i]['collectionID'],
                items['items'][i]['uid']
                ));
            print(_items[i].name);
          }
          setState(() {});
        });
      }
    });
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _items.length *
            2, //ensures the length includes all items with dividers
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          return _buildRow(_items[(item / 2)
              .round()]); //-1 since you can't add the index after building the row
        });
  }

  Widget _buildRow(item) {
    return ListTile(
        title: Text(item.name),
        trailing: Icon(Icons.edit),
        onTap: () {
          //Edit the room name
        });
  }

//Main content
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Items'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Refresh'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return NewItemDialog();
              });
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Refresh':
        getItems();
        break;
      case 'Logout':
        _logout();
        break;
    }
  }

  void _logout() {
    //resets the login values to ensure you aren't still logged in
    id = "";
    email = "";
    accessToken = "";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginRoute()),
    );
  }
/*
  void _editItem(String itemName, String isPrivate) {
    String url = urlBase + "/item/single";
    String content =
        '{"name": "' + itemName + '", "description": ' + description + '}';
    Register.putRegisterGetStatus(url, content).then((value) {
      if (value.compareTo("200") == 0) {
        _ItemsRouteState().getItems().whenComplete(() {
          _ItemsRouteState().setState(() {});
        });
        Navigator.pop(context);
      } else if (value.compareTo("401") == 0) {
        print("Access token invalid");
      } else if (value.compareTo("401") == 0) {
        print("Content already exists");
      } else {
        print(value);
      }
    });
  }*/
}

class DeleteItemDialog extends StatefulWidget {
  final String itemId, itemName;
  const DeleteItemDialog(
      {Key? key, required this.itemId, required this.itemName})
      : super(key: key);

  @override
  _DeleteItemDialogState createState() => new _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  void deleteItem(String itemId) {
    String url = urlBase + "/items/single";
    Map<String, String> content = {
      'id': itemId,
    };
    print(content);
    Register.deleteRegisterGetStatusCode(url, content);
  }

  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
      child: AlertDialog(
        title: Text('Delete Item'),
        actions: <Widget>[
          Text('Are you sure you want to delete ${widget.itemName}?'),
          ElevatedButton(
            onPressed: () {
              deleteItem(widget.itemId);
              Navigator.pop(context);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(colorScheme.error)),
            child: Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(colorScheme.primary)),
            child: Text('Close'),
          )
        ],
      ),
    );
  }
}

class NewItemDialog extends StatefulWidget {
  _NewItemDialogState createState() => new _NewItemDialogState();
}

//Adding a new item
class _NewItemDialogState extends State<NewItemDialog> {
  String description = "", itemName = "";
  List<String> tags = [];

  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
      child: AlertDialog(
        title: Text('Add Item'),
        actions: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter item name';
              else
                return null;
            },
            onChanged: (value) {
              itemName = value;
            },
            decoration: InputDecoration(labelText: 'Item name'),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter item description';
              else
                return null;
            },
            onChanged: (value) {
              description = value;
            },
            decoration: InputDecoration(labelText: 'Item description'),
          ),
          //try and loop to print out tags here

          TextField(
              decoration: InputDecoration(
                  labelText: 'Tag values, separate with a ", "'),
              onChanged: (value) {
                tags = value.split(', ');
              }),
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () {
              _addItem();
              _ItemsRouteState().getItems();
              _ItemsRouteState()._buildList();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _addItem() {
    String url = urlBase + "/items/create";
    //var map2 = {};
    // list.forEach((tags) => map2[tag] = key);
    String content = '{"name": "' +
        itemName +
        '", "description": ' +
        description +
        ', "item": ' +
        tags.toString() + //Change this to be a map
        ', "collectionID": ' +
        collectionId +
        '}';
    print(content);
    Register.postRegisterGetStatusCode(url, content).then((value) {
      print(value);
      _ItemsRouteState().getItems();
    });
  }
}
