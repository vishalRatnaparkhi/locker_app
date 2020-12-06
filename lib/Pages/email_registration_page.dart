import 'package:firebase_auth/firebase_auth.dart';
import 'package:locker_app/Pages/email_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/helper/users_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker_app/Paint/CustomPaintHome.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  String displayNAme;
  String successMessage = '';
  bool newUser = false;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TopBar_home(),
          Column(
            children: [
              SizedBox(height: 60.0),
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quickstand'),
                ),
              ),
              SizedBox(height: 40.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formStateKey,
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(

                                onSaved: (value) {
                                  displayNAme = value;
                                },
                                keyboardType: TextInputType.name,


                                decoration: InputDecoration(

                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.indigo,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  // hintText: "Company Name",
                                  labelText: "Full Name",
                                  icon: Icon(
                                    Icons.assignment_ind,
                                    color: Colors.indigo,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validateEmail,
                                onSaved: (value) {
                                  _emailId = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailIdController,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.indigo,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  // hintText: "Company Name",
                                  labelText: "Email Id",
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.indigo,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validatePassword,
                                onSaved: (value) {
                                  _password = value;
                                },
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.indigo,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  labelText: "Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.indigo,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: TextFormField(
                                validator: validateConfirmPassword,
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.green,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  // hintText: "Company Name",
                                  labelText: "Confirm Password",
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.indigo,
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // make buttons use the appropriate styles for cards

                      Container(
                        padding: EdgeInsets.only(
                          top: 15,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Registration',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (_formStateKey.currentState.validate()) {
                              _formStateKey.currentState.save();
                              signUp(_emailId, _password).then((user) {
                                if (user != null) {
                                  print('Registered Successfully.');

                                  addUserToDb(user);

                                  user.sendEmailVerification();
                                  Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                } else {
                                  print('Error while Login.');
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    newUser = await isNewUser(currentuser);
    if (newUser) {
      Users _user = await Users(
          currentuser.uid,
          currentuser.email,
          currentuser.photoUrl,
          displayNAme,
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

  Future<FirebaseUser> signUp(email, password) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        break;
      default:
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.trim() != _passwordController.text.trim()) {
      return 'Password Mismatch!!!';
    }
    return null;
  }
}
