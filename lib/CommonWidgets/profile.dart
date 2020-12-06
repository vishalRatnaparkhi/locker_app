import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locker_app/CommonWidgets/drawer.dart';
import 'package:locker_app/CommonWidgets/settings.dart';
import 'package:locker_app/Paint/CustomPaintHome.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/CommonWidgets/settings.dart';
import 'package:provider/provider.dart';
import 'package:locker_app/helper/UserModel.dart';
import 'package:locker_app/services/database.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, email, phone;
  UserModel user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = false;
    fetchData();
  }

  void fetchData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserID> (context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: new CircleAvatar(
                      radius: 45,
                      child: Image.network(currentUser.photoUrl.toString()),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 70.0)),
                  Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(
                    currentUser.name,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Divider(
                    color: Colors.black45,
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(
                    currentUser.email,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Divider(
                    color: Colors.black45,
                  ),
                  Padding(padding: EdgeInsets.only(top: 4.0)),
                  Text(
                    "Phone",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(
                    currentUser.phoneNo.toString() == "null"
                        ? "NA"
                        : currentUser.phoneNo.toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    color: Colors.black45,
                  ),
                  /* Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(color: Colors.black45,),
                        Padding(padding: EdgeInsets.only(top: 4.0)),
                        Text(
                          "Aadhar card no",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        Text(
                          userModel.aadharCard,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                        Divider(color: Colors.black45,),
                        Padding(padding: EdgeInsets.only(top: 4.0)),
                        Text(
                          "Pancard no",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        Text(
                          userModel.panCard,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500
                          ),
                        ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
