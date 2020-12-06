import 'package:locker_app/helper/LOCKERS_data.dart';
import 'package:locker_app/helper/UserModel.dart';
import 'package:locker_app/services/payment_service.dart';

List lockerList = new List();
PaymentTransaction current;
bool home = true;
List transactionList = new List();
UserModel currentUser;
Struct selectedLock;
List<bool> lockers = new List();
List recentList = new List();
