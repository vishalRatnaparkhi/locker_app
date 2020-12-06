class PaymentTransaction {
  int billamount;
  int duration;
  String qrcode;
  String address;
  String lockerName;
  String paymentMethod;
  DateTime startTime;
  DateTime endTime;
  int lockerNo;
  DateTime currentTime;

  PaymentTransaction(
      this.billamount,
      this.duration,
      this.qrcode,
      this.address,
      this.lockerName,
      this.paymentMethod,
      this.startTime,
      this.lockerNo,
      this.endTime,
      this.currentTime);

  Map<String, dynamic> toJson() => {
        'billAmount': billamount,
        'duration': duration,
        'qrCode': qrcode,
        'lockerAdd': address,
        'lockerName': lockerName,
        'paymentMethod': paymentMethod,
        'startTime': startTime,
        'endTime': endTime,
        'lockerNo': lockerNo,
        'currentTime': currentTime,
      };
}
