import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locker_app/CommonWidgets/settings.dart';
import 'package:locker_app/helper/WalletModel.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/helper/walletSub.dart';
import 'package:locker_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:locker_app/CommonWidgets/drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crypto Wallet',
      home: Wallet(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Wallet extends StatelessWidget {
  dynamic c;
  String amount;
  final _amountController = TextEditingController(text: '');
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  @override
  void initState() {
    home = false;
  }

  addUserTransactionToWallet() async {
    FirebaseUser current = await FirebaseAuth.instance.currentUser();
    int totalBalance;
    await Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Wallet")
        .document(current.uid)
        .get()
        .then((value) => totalBalance = value["Main Balance"]);

    await Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Wallet")
        .document(current.uid)
        .updateData(<String, dynamic>{
      'Main Balance': totalBalance + num.parse(amount)
    });

    await Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Wallet")
        .document(current.uid)
        .collection("Transaction")
        .add(new WalletSub.add(true, num.parse(amount),
                totalBalance + num.parse(amount), "online", DateTime.now())
            .toJson1());
    print("Added new Transaction to Wallet");
  }

  Future getWalletData() async {
    FirebaseUser current = await FirebaseAuth.instance.currentUser();
    List list = new List();

    Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Wallet")
        .document(current.uid)
        .collection("Transaction")
        .orderBy("currentTime", descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshot.documents.forEach((doc) => list.add(new WalletSub.all(
            doc['currentTime'].toDate(),
            doc['action'],
            doc['amount'],
            doc['final balance'],
            doc['method'] != null ? doc['method'] : "",
            doc['lockerName'] != null ? doc['lockerName'] : "",
            doc['startTime'] != null
                ? doc['startTime'].toDate()
                : DateTime.now(),
          )));
    });

    if (list != null) walletList = list;
    print(currentUser.uid);
    print("wallet lit " + walletList.length.toString());
    return walletList;
  }

  @override
  Widget build(BuildContext context) {
    c = context;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Wallet',
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
            Text(
              "Add Money To  Wallet",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16.4),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Container(
                height: 1,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 15.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Form(
                              key: _formStateKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: TextFormField(
                                            controller: _amountController,
                                            onSaved: (value) {
                                              amount = value;
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: InputDecoration(
                                                labelText: "Enter Amount ",
                                                hintText: "enter in rupees",
                                                icon: Icon(Icons.money)))),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              color: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                if (_formStateKey.currentState.validate()) {
                                  _formStateKey.currentState.save();
                                  addUserTransactionToWallet();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              "Previous Wallet Transaction",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16.4),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 100.0,
              ),
              child: Container(
                height: 1,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getWalletData(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null)
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 4.0),
                                child: walletList[index].action
                                    ? Container(
                                        height: 220,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 14),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 12.0),
                                                        child: Text(
                                                          "Deposit",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors
                                                                  .white70),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: Text(
                                                        "Ordered At :  " +
                                                            DateFormat(
                                                                    'yyyy-MM-dd - kk:mm')
                                                                .format(walletList[
                                                                        index]
                                                                    .currentTime),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        'Amount: ' +
                                                            " " +
                                                            walletList[index]
                                                                .billamount
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        walletList[index]
                                                            .method
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Revised Balance : Rs." +
                                                            walletList[index]
                                                                .revisedBalance
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 17),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 260,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 14),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 12.0),
                                                        child: Text(
                                                          " Transfered",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors
                                                                  .white70),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12.0),
                                                      child: Text(
                                                        "Ordered At :  " +
                                                            DateFormat(
                                                                    'yyyy-MM-dd - kk:mm')
                                                                .format(walletList[
                                                                        index]
                                                                    .currentTime),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Locker : " +
                                                            walletList[index]
                                                                .lockerName
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 17),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Ordered For :  " +
                                                            DateFormat(
                                                                    'yyyy-MM-dd - kk:mm')
                                                                .format(walletList[
                                                                        index]
                                                                    .startTime),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Bill Amount : Rs." +
                                                            walletList[index]
                                                                .billamount
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      child: Text(
                                                        "Revised Balance : Rs." +
                                                            walletList[index]
                                                                .revisedBalance
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 17),
                                                      ),
                                                    )
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
