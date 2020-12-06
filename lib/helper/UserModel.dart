class UserID {
  final String uid;

  UserID({this.uid});
}

class UserModel {
  final String uid;
  final String name;
  // final String aadharCard;
  final String email;
  final String phoneNo;
  final photoUrl;
  // final String panCard;
  @override
  String toString() {
    print(email + " " + phoneNo.toString() + " " + photoUrl);
  }

  UserModel({this.uid, this.name, this.email, this.phoneNo, this.photoUrl});
}
