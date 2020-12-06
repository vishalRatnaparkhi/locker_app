import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/helper/Constants.dart';
import 'package:locker_app/CommonWidgets/profile.dart';
import 'package:locker_app/pages/landing_page.dart';
import 'package:locker_app/services/auth.dart';

class SettingWidget extends StatelessWidget {
  BuildContext c;
  @override
  Widget build(BuildContext context) {
    c = context;
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      icon: Icon(
        Icons.settings,
        color: Colors.white.withOpacity(0.9),
        size: 24,
      ),
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  choiceAction(String choice) {
    if (choice == Constants.Profile) {
      Navigator.push(
          c, new MaterialPageRoute(builder: (context) => new Profile()));
    } else if (choice == Constants.SignOut) {
      FirebaseAuth.instance.signOut();
      Navigator.of(c).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => LandingPage(auth: Auth())),
          (r) => false);
    }
  }
}
