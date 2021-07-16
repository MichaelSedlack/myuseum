import 'package:flutter/material.dart';
import 'package:myuseum/Utils/getAPI.dart';

class RoomsRoute extends StatefulWidget {
  @override
  _RoomsRouteState createState() => _RoomsRouteState();
}

class _RoomsRouteState extends State<RoomsRoute> {
  //Need to get the list of available rooms from the backend
  final _rooms = {'TestOne', 'TestTwo'};
  var index = 0;

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          return _buildRow(_rooms[index]);
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
          title: Text('Rooms'),
        ),
        body: _buildList());
  }
}
