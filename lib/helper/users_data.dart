import 'package:meta/meta.dart';

class Users{
  String uid;
  String email;
  String photoUrl;
  String displayName;
  String phone;
  String provider;

  Users(this.uid, this.email, this.photoUrl, this.displayName,this.phone,this.provider);
  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'email': email,
        'photoUrl':photoUrl,
        'displayName':displayName,
        'phone':phone,
        'provider':provider,
      };
}