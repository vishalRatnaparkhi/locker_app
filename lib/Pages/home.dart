import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:locker_app/CommonWidgets/settings.dart';
import 'package:locker_app/Pages/recipt.dart';
import 'package:locker_app/helper/Constants.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/Pages/map.dart';
import 'package:locker_app/Paint/CustomPaintHome.dart';
import 'package:locker_app/Transitions/FadeTransition.dart';
import 'package:locker_app/CommonWidgets/drawer.dart';
import 'package:locker_app/Widget/recents.dart';
import 'package:locker_app/services/auth.dart';
import 'package:locker_app/helper/LOCKERS_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({@required this.auth});

  final AuthBase auth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchAddr;

  _MyHomePageState();
  @override
  void initState() {
    super.initState();
    home = true;
  }

  Future getMarkerData() async {
    setState(() {
      if (recentList.length == 0) {
        Firestore.instance
            .collection("Locker")
            .orderBy("available locker", descending: true)
            .snapshots()
            .listen((snapshot) {
          snapshot.documents.forEach((doc) => recentList.add(new Struct(
              doc['name'],
              doc['address'],
              doc['review'] + 0.0,
              doc['charge'].toString(),
              doc['location'].latitude,
              doc['location'].longitude,
              doc['available locker'].toString(),
              doc['image'].toString(),
              doc['mob'].toString(),
              doc['email'],
              doc['total locker'].toString())));
        });
      }
    });
    return recentList;
  }

  @override
  //Function _signOut;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Lockers',
            style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quickstand'),
          ),
        ),
        actions: <Widget>[
          SettingWidget(),
        ],
        backgroundColor: Colors.indigo[900],
        elevation: 0,
      ),
      drawer: DrawerWidget(),
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 28, top: 40, right: 28, bottom: 10),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    title: TextField(
                      enabled: true,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Search for a locker nearby',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              letterSpacing: 0.2)),
                    ),
                    trailing: Icon(
                      Icons.search,
                      size: 27,
                      color: Colors.orange[400],
                    ),
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: MapView()));
                    },
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 6,
                child: FutureBuilder(
                    future: getMarkerData(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null)
                        return Recents();
                      else
                        return CircularProgressIndicator();
                    }))
          ])
        ],
      ),
      floatingActionButton: current != null
          ? FloatingActionButton.extended(
              label: Text('Track'),
              backgroundColor: Colors.red,
              icon: Icon(Icons.where_to_vote),
              onPressed: () => Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => MyRecipt(current),
                ),
              ),
            )
          : null,
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Profile) {
      print('Profile');
    } else if (choice == Constants.SignOut) {
      print('SignOut');
    }
  }
}
