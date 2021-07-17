import 'dart:ui';
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

  void getRooms() {
    String content = '{"id": "' + id + '"}';
    String registerURL = urlBase + "/users/collections";
    print(registerURL);
    Register.getRegisterGetStatusCode(registerURL, content).then((value) {
      print('Status Code: ' + value);
      if (value.compareTo("200") == 0) {
        Register.getRegisterGetBody(registerURL, content).then((value) {
          for (int i = 0; i < value.length; i++) {
            print(value);
          }
        });
      }
    });
  }

  Widget _buildList() {
    getRooms();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _rooms.length *
            2, //ensures the length includes all rooms with dividers
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          index++; //increases the index so that all rooms are gone through
          return _buildRow(_rooms[index -
              1]); //-1 since you can't add the index after building the row
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

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
            child: AlertDialog(
              title: Text('Add Room'),
              actions: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter room name';
                    else
                      return null;
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(labelText: 'Room name'),
                ),
                ElevatedButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
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
          getRooms();
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
