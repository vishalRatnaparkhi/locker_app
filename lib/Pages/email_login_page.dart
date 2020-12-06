import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:locker_app/Pages/email_registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:locker_app/Pages/home.dart';
import 'package:locker_app/Pages/landing_page.dart';
import 'package:locker_app/Paint/CustomPaintHome.dart';
import 'package:locker_app/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({@required this.auth, @required this.onSignIn});
  final AuthBase auth;
  final Function(FirebaseUser) onSignIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              TopBar_home(),
              Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                      ),
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
                      SizedBox(
                        height: 45,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
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
                                        validator: validateEmail,
                                        onSaved: (value) {
                                          _emailId = value;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: _emailIdController,
                                        decoration: InputDecoration(
                                          focusedBorder:
                                              new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.indigo,
                                                width: 2,
                                                style: BorderStyle.solid),
                                          ),
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
                                          focusedBorder:
                                              new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.green,
                                                      width: 2,
                                                      style:
                                                          BorderStyle.solid)),
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: ButtonTheme.bar(
                                  child: ButtonBar(
                                    buttonMinWidth: 140,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.indigo,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formStateKey.currentState
                                              .validate()) {
                                            _formStateKey.currentState.save();
                                            signIn(_emailId, _password)
                                                .then((user) {
                                              if (user != null) {
                                                print(
                                                    'Logged in successfully.');
                                                MyHomePage(
                                                  auth: widget.auth,
                                                ); //
                                                setState(() {
                                                  successMessage =
                                                      'Logged in successfully.';
                                                });
                                              } else {
                                                print('Error while Login.');
                                                setState(() {
                                                  successMessage =
                                                      'User Not Registered.';
                                                });

                                                Navigator.pushReplacement(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegistrationPage(),
                                                  ),
                                                );
                                              }
                                            });
                                          }
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'Get Register',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (successMessage != ''
                          ? Text(
                              successMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.redAccent),
                            )
                          : Container())
                    ],
                  )),
            ],
          ),
        ]),
      ),
    );
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (!user.isEmailVerified)
        setState(() {
          successMessage = 'Logged in successfully.';
        });
      else
        return user;

      throw Exception;
    } catch (e) {
      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        break;
      case 'ERROR_WRONG_PASSWORD':
        break;
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
    if (value.trim().isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}
