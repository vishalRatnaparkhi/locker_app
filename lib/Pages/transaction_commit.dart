import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/Pages/home.dart';
import 'package:locker_app/Pages/recipt.dart';
import 'package:locker_app/helper/LOCKERS_data.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/helper/walletSub.dart';
import 'package:locker_app/services/auth.dart';
import 'package:locker_app/services/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTransactionCommit extends StatefulWidget {
  PaymentTransaction transaction;
  Struct locker;

  MyTransactionCommit(this.transaction, this.locker);

  @override
  State createState() => _MyTransactionCommitState(transaction);
}

class _MyTransactionCommitState extends State<MyTransactionCommit> {
  PaymentTransaction transaction;
  _MyTransactionCommitState(this.transaction);

  updateLockerStatus(FirebaseUser user) async {
    QuerySnapshot result = await Firestore.instance
        .collection("Locker")
        .document(transaction.lockerName.split(" ")[0])
        .collection("EachLocker")
        .where("locker no",
            isEqualTo: num.parse(transaction.lockerName.split(" ")[1]))
        .getDocuments();
    print(transaction.lockerNo.toString() +
        " " +
        transaction.lockerName.split(" ")[0]);
    Firestore.instance
        .collection("Locker")
        .document(transaction.lockerName.split(" ")[0])
        .updateData(<String, dynamic>{
      'available locker':
          (num.parse(widget.locker.availablelockers) - 1).toString(),
    });

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 1) {
      print("Updating locker Status");
      await docs.forEach((document) async {
        await document.reference.updateData(<String, dynamic>{
          'available': false.toString(),
          'rented to': user.uid,
        });
      });
    } else
      print("Locker Status not Updated");
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

    if (transaction.billamount < totalBalance) {
      await Firestore.instance
          .collection("User")
          .document(current.uid)
          .collection("Wallet")
          .document(current.uid)
          .updateData(<String, dynamic>{
        'Main Balance': totalBalance - transaction.billamount
      });

      await Firestore.instance
          .collection("User")
          .document(current.uid)
          .collection("Wallet")
          .document(current.uid)
          .collection("Transaction")
          .add(new WalletSub(
                  transaction.billamount,
                  false,
                  transaction.lockerName,
                  transaction.startTime,
                  totalBalance - transaction.billamount,
                  DateTime.now())
              .toJson2());
      print("Added new Transaction to Wallet");
    } else {
      print("###############Balance Insufficient");
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => MyHomePage(auth: Auth()),
        ),
      );
    }
  }

  addUserTransactionToDb() async {
    FirebaseUser current = await FirebaseAuth.instance.currentUser();
    updateLockerStatus(current);

    await Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Transaction")
        .add(transaction.toJson());

    await Firestore.instance
        .collection("User")
        .document(current.uid)
        .collection("Wallet")
        .add(<String, dynamic>{'Main Balance': 0});
    print("Added new Transaction to Db");
  }

  @override
  void initState() {
    addUserTransactionToWallet();
    addUserTransactionToDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () {
                        current = transaction;
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => MyRecipt(transaction),
                          ),
                        );
                      },
                      color: Colors.indigo[500],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Transaction Happening...press to proceed',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            wordSpacing: 2,
                            letterSpacing: 0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
