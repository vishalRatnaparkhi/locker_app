import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locker_app/CommonWidgets/settings.dart';
import 'package:locker_app/helper/UserModel.dart';
import 'package:locker_app/CommonWidgets/drawer.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:typicons_flutter/typicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:locker_app/services/payment_service.dart';

import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

var doc;

class _TransactionState extends State<Transaction> {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    home = false;
  }

  Future getTransactionData() async {
    List list = new List();
    setState(() {
      Firestore.instance
          .collection("User")
          .document(currentUser.uid)
          .collection("Transaction")
          .snapshots()
          .listen((snapshot) {
        snapshot.documents.forEach((doc) => list.add(new PaymentTransaction(
              doc['billAmount'],
              doc['duration'],
              doc['qrCode'],
              doc['lockerAdd'],
              doc['lockerName'],
              doc['paymentMethod'],
              doc['startTime'].toDate(),
              doc['lockerNo'],
              doc['endTime'].toDate(),
            )));
      });
    });
    if (list != null) transactionList = list;
    print(currentUser.uid);
    print("transaction lit " + transactionList.length.toString());
    return transactionList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Transaction',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: getTransactionData(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null)
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 4.0),
                                child: Container(
                                  height: 220,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    transactionList[index]
                                                        .lockerName,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.white70),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Text(
                                                  DateFormat(
                                                          'yyyy-MM-dd - kk:mm')
                                                      .format(
                                                          transactionList[index]
                                                              .startTime),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 17),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Text(
                                                  'Duration: ' +
                                                      " " +
                                                      transactionList[index]
                                                          .duration
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 17),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Text(
                                                  transactionList[index]
                                                      .paymentMethod
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 17),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Text(
                                                  "Rs." +
                                                      transactionList[index]
                                                          .billamount
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 17),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    transactionList[index]
                                                        .address
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white70),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    else
                      return CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _cardItem extends StatefulWidget {
  @override
  __cardItemState createState() => __cardItemState();
}

class __cardItemState extends State<_cardItem> {
  @override
  Widget build(BuildContext context) {}
}
