import 'package:flutter/material.dart';
import 'package:locker_app/helper/helper_lists.dart';
import 'package:locker_app/services/payment_service.dart';
import 'package:locker_app/services/qr_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:locker_app/Pages/landing_page.dart';
import 'package:locker_app/services/auth.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class MyRecipt extends StatefulWidget {
  PaymentTransaction transaction;

  MyRecipt(this.transaction);

  @override
  State createState() => _MyReciptState();
}

class _MyReciptState extends State<MyRecipt> {
  String qrData;
  @override
  void initState() {
    setState(() {
      qrData = widget.transaction.qrcode;
    });
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
                  height: 24,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Center(
                      child: Text(
                        'Locker Code',
                        style: TextStyle(
                            fontSize: 24.4,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: QrImage(
                    //plce where the QR Image will be shown
                    data: qrData,
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Locker Pass Code',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.transaction.qrcode,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Locker Number',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.transaction.lockerName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'From',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.transaction.startTime.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'To',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.transaction.endTime.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Full Address',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                        fontSize: 13,
                        letterSpacing: 0.2),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.transaction.address,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                        fontSize: 12.4,
                        letterSpacing: 0.2),
                  ),
                ),
                SizedBox(
                  height: 25,
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
                      color: Colors.indigo[500],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'DIRECTION',
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
