import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/Pages/home.dart';
import 'package:locker_app/Pages/email_login_page.dart';
import 'package:locker_app/Paint/CustomPaintHome.dart';
import 'package:locker_app/Widget/sign_in_button.dart';
import 'package:locker_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/helper/users_data.dart';

///Certificate fingerprint
///(SHA1): F2:E9:2D:E4:B8:99:62:4D:8E:A3:61:9E:B5:FE:C6:BA:D9:B6:A5:7E
///Certificate fingerprints:
////   MD5:  59:C1:0A:06:EA:34:47:73:4A:07:32:0E:AD:11:9B:13
///SHA1: F2:E9:2D:E4:B8:99:62:4D:8E:A3:61:9E:B5:FE:C6:BA:D9:B6:A5:7E
//SHA256: A5:67:7F:4B:BD:C8:B1:C1:74:C9:78:91:D5:DB:AA:37:44:BA:8A:62:B6:96:41:EF:2B:14:A8:4E:F1:EA:F5:8F

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth, @required this.onSignIn});
  final Function(FirebaseUser) onSignIn;
  final AuthBase auth;
  bool newUser = false;

  Future<void> _signInAnonymously() async {
    try {
      FirebaseUser user = await auth.signInAnonymously();
      onSignIn(user);
    } catch (e) {
      print(e.toString() + "Ananaohhhhh");
    }
  }

  Future<bool> isNewUser(FirebaseUser user) async {
    QuerySnapshot result = await Firestore.instance
        .collection("User")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  addUserToDb(FirebaseUser currentuser) async {
    if (newUser) {
      Users _user = await Users(
          currentuser.uid,
          currentuser.email,
          currentuser.photoUrl,
          currentuser.displayName,
          currentuser.phoneNumber,
          currentuser.providerId);
      print("Adding new User to Db");

      await Firestore.instance
          .collection("User")
          .document(currentuser.uid)
          .setData(_user.toJson());
    } else
      print("User ALredy Exists");
  }

  Future<void> _signInWithGoogle() async {
    try {
      FirebaseUser user = await auth.signInWithGoogle();
      onSignIn(user);

      newUser = await isNewUser(user);
      addUserToDb(user);
    } catch (e) {
      print(e.toString() + " Vishal Google");
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      FirebaseUser user = await auth.signInWithFacebook();

      onSignIn(user);

      newUser = await isNewUser(user);
      addUserToDb(user);
    } catch (e) {
      print(e.toString() + " Vishal Facebook");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quickstand'),
                  ),
                ),
                SizedBox(height: 90.0),
                SignInButton(
                  text: 'Sign In with Email',
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => LoginPage(auth: auth)));
                  },
                ),
                SizedBox(height: 16.0),
                SignInButton(
                    text: 'Sign In with Google',
                    textColor: Colors.white,
                    color: Colors.indigo,
                    onPressed: _signInWithGoogle),
                SizedBox(height: 16.0),
                SignInButton(
                  text: 'Sign In with Facebook',
                  textColor: Colors.white,
                  color: Color(0xFF334D92),
                  onPressed: _signInWithFacebook,
                ),
                SizedBox(height: 16.0),
                SignInButton(
                  text: 'Sign In Annonymously',
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
