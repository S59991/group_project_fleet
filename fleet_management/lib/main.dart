import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class Fleet {
  String key;
  String fleetNo;
  String fleetName;
  String dateRegistered;
  String fleetLocation;
  String fleetStatus;

  Fleet(this.fleetNo, this.fleetName, this.dateRegistered, this.fleetLocation, this.fleetStatus);

  Fleet.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        fleetNo = snapshot.value["fleetNo"],
        fleetName = snapshot.value["fleetName"],
        dateRegistered = snapshot.value["dateRegistered"],
        fleetLocation = snapshot.value["fleetLocation"],
        fleetStatus = snapshot.value["fleetStatus"];

  toJson() {
    return {
      "fleetNo": fleetNo,
      "fleetName": fleetName,
      "dateRegistered": dateRegistered,
      "fleetLocation": fleetLocation,
      "fleetStatus": fleetStatus,
    };
  }
}

class FleetListPage extends StatefulWidget {
  @override
  _FleetListPageState createState() => _FleetListPageState();
}

class _FleetListPageState extends State<FleetListPage> {
  List<Fleet> _fleets = [];

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.reference().child("fleets").onValue.listen((Event event) {
      setState(() {
        _fleets = [];
        Map<dynamic, dynamic> data = event.snapshot.value;
        data.forEach((key, value) {
          _fleets.add(Fleet.fromSnapshot(event.snapshot.child(key)));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fleets"),
      ),
      body: ListView.builder(
        itemCount: _fleets.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_fleets[index].fleetName),
            subtitle: Text(_fleets[index].dateRegistered),
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: FleetListPage(),
));

