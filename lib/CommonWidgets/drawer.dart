import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/pages/landing_page.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/services/auth.dart';
import 'package:locker_app/CommonWidgets/profile.dart';
import 'package:locker_app/CommonWidgets/transaction.dart' as t;
import 'package:locker_app/CommonWidgets/wallet.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.name),
            accountEmail: Text(currentUser.email),
            //currentAccountPicture: Image.network("https://talentrecap.com/wp-content/uploads/2020/04/One-Direction-1200x900.jpg")
            currentAccountPicture: CircleAvatar(
              child: Image.network(currentUser.photoUrl),
            ),
            decoration: BoxDecoration(color: Colors.indigo[900]),
          ),
          home
              ? ListTile(
                  leading: Icon(Icons.person),
                  title: Text("My profile"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Profile()));
                  },
                )
              : ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text("Home"),
                  onTap: () {
                    recentList = new List();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => LandingPage(
                            auth: Auth(),
                          ),
                        ));
                  },
                ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Transactions"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new t.Transaction()));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text("Wallet"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Wallet()));
            },
          ),
          new Divider(
            endIndent: 100,
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (c) => LandingPage(auth: Auth())),
                    (r) => false);
              }),
        ],
      ),
    );
  }
}
