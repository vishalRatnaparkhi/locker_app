import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/helper/UserModel.dart';
import 'package:locker_app/helper/WalletModel.dart';

class Database {
  final String uid;
  Database(this.uid);

  final CollectionReference userCollection =
      Firestore.instance.collection('User');

  UserModel _userModel(DocumentSnapshot documentSnapshot) {
    return UserModel(
      uid: uid,
      name: documentSnapshot.data['displayName'],
      email: documentSnapshot.data['email'],
      phoneNo: documentSnapshot.data['phone'],
      photoUrl: documentSnapshot.data['photoUrl'],
      //aadharCard: documentSnapshot.data()['aadharcard'],
      //panCard: documentSnapshot.data()['pancard'],
    );
  }

  WalletModel _walletModel(DocumentSnapshot documentSnapshot) {
    return WalletModel(balance: documentSnapshot.data['balance']);
  }

  Stream<UserModel> get userData {
    return userCollection.document(uid).snapshots().map(_userModel);
  }

  Stream<WalletModel> get walletData {
    return userCollection
        .document(uid)
        .collection('Wallet')
        .document('balance')
        .snapshots()
        .map(_walletModel);
  }
}
