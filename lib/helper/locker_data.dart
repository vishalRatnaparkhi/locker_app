
class Locker {
  bool available;
  String rentedTo;
  String uid;
  String qrcode;
  int lockerNO;

  Locker(available, rentedTo, lockerNO, uid,qrcode) {
    this.available = available;
    this.lockerNO = lockerNO;
    this.rentedTo = rentedTo;
    this.uid = uid;
    this.qrcode=qrcode;

  }


  @override
  String toString() {
    return 'Locker{available: $available, rentedTo: $rentedTo, uid: $uid, lockerNO: $lockerNO, QrCode: $qrcode}';
  }
}