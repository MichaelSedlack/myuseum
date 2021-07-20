import 'dart:ui';
import 'package:myuseum/login.dart';
import 'package:flutter/material.dart';
import 'package:myuseum/Utils/userInfo.dart';
import 'package:myuseum/Utils/getAPI.dart';

String roomId = "";
void setRoomId(String newId)
{
  roomId = newId;
}


class Collections {
  String name = "";
  List <String> keys = [];
  String private = "";
  String roomId = "";
  Collections(String newName) {
    name = newName;
  }
}

class CollectionsRoute extends StatefulWidget {
  @override
  _CollectionsRouteState createState() => _CollectionsRouteState();
}

class _CollectionsRouteState extends State<CollectionsRoute> {
  //Need to get the list of available rooms from the backend
  final List<Collections> _collections = [];
  var index = 0;

  void getCollections() {
    String content = '{"id": "' + getId() + '"}';
    String registerURL = urlBase + "/users/collections";
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

  Widget _buildList() {
    getCollections();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _collections.length *
            2, //ensures the length includes all rooms with dividers
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          index++; //increases the index so that all rooms are gone through
          return _buildRow(_collections[index - 1]); //-1 since you can't add the index after building the row
        });
  }

  Widget _buildRow(collection) {
    return ListTile(
        title: Text(collection.name),
        trailing: Icon(Icons.edit),
        onTap: () {
          //Edit the room name
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Collections'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                //resets the login values to ensure you aren't still logged in
                id = "";
                email = "";
                accessToken = "";
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
                return NewCollectionDialog();
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Refresh':
        getCollections();
        break;
      case 'Logout':
        _logout();
        break;
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginRoute()),
    );
  }
}

class NewCollectionDialog extends StatefulWidget {
  _NewCollectionDialogState createState() => new _NewCollectionDialogState();
}

class _NewCollectionDialogState extends State<NewCollectionDialog> {
  bool isSwitched = false;
  String collectionName = "", isPrivate = "false";
  List <String> keys = [];

  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
      child: AlertDialog(
        title: Text('Add Room'),
        actions: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter collection name';
              else
                return null;
            },
            onChanged: (value) {
              collectionName = value;
            },
            decoration: InputDecoration(labelText: 'Collection name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Tags, separate with a ", "'),
            onChanged: (value) {
              keys = value.split(', ');
              print(keys);
            }
          ),
          Switch(
            value: isSwitched,
            onChanged: (bool value) {
              setState(() {
                isSwitched = value;
                toggleIsPrivate();
                value = !value;
                print("is Switched is $isSwitched");
                print("private is $isPrivate");
              });
            },
          ),
          if (!isSwitched) Text("public"),
          if (isSwitched) Text("private"),
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () {
              _addCollection();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _addCollection() {
    String url = urlBase + "/rooms/create";
    String content = '{"name": "' + collectionName + '", "keys": ' + keys.toString() + ',  "private": ' + isPrivate + ', "roomID": "' + roomId + '"}';
    print(content);
    Register.postRegisterGetStatusCode(url, content).then((value) {
      print(value);
      _CollectionsRouteState().getCollections();
    });
  }

  void toggleIsPrivate() {
    print("toggleIsPrivate was called");
    if (isPrivate.compareTo("true") == 0) {
      isPrivate = "false";
      return;
    }
    if (isPrivate.compareTo("false") == 0) {
      isPrivate = "true";
      return;
    }
  }
}