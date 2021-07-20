import 'dart:ui';
import 'dart:convert';
import 'package:myuseum/login.dart';
import 'package:flutter/material.dart';
import 'package:myuseum/Utils/userInfo.dart';
import 'package:myuseum/Utils/getAPI.dart';

class Room {
  String name = "";

  Room(String newName) {
    name = newName;
  }
}

class RoomsRoute extends StatefulWidget {
  @override
  _RoomsRouteState createState() => _RoomsRouteState();
}

class _RoomsRouteState extends State<RoomsRoute> {
  //Need to get the list of available rooms from the backend
  final List<Room> _rooms = [];
  var index = 0;
  String roomName = "", isPrivate = "false";

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  Future getRooms() async{
    Map<String, String> content = {
      'id': getId(),
    };
    String registerURL = urlBase + "/users/rooms";
    Register.getRegisterGetStatusCode(registerURL, content).then((value) {
      print('Status Code: ' + value);
      if (value.compareTo("200") == 0) {
        Register.getRegisterGetBody(registerURL, content).then((newValue) {
        List rooms = json.decode(newValue);
        _rooms.clear();
        print(rooms.length);
         for (int i = 0; i < rooms.length; i++) {
           setState(() {
            _rooms.add(Room(rooms[i]['name']));
           });
         }
        });
      }
    });
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _rooms.length *
            2, //ensures the length includes all rooms with dividers
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          return _buildRow(_rooms[(item/2).round()]); //-1 since you can't add the index after building the row
        });
  }

  Widget _buildRow(room) {
    return ListTile(
        title: Text(room.name),
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
        title: Text('Rooms'),
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
                return NewRoomDialog();
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
        getRooms();
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

class NewRoomDialog extends StatefulWidget {
  _NewRoomDialogState createState() => new _NewRoomDialogState();
}

class _NewRoomDialogState extends State<NewRoomDialog> {
  bool isSwitched = false;
  String isPrivate = "false", roomName = "";

  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
      child: AlertDialog(
        title: Text('Add Room'),
        actions: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter room name';
              else
                return null;
            },
            onChanged: (value) {
              roomName = value;
            },
            decoration: InputDecoration(labelText: 'Room name'),
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
              _addRoom();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _addRoom() {
    String url = urlBase + "/rooms/create";
    String content = '{"name": "' + roomName + '", "private": ' + isPrivate + '}';
    print(content);
    Register.postRegisterGetStatusCode(url, content).then((value) {
      print(value);
      _RoomsRouteState().getRooms();
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
