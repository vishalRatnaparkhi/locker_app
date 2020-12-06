class WalletSub {
  int billamount;
  String lockerName;
  bool action;
  int revisedBalance;
  DateTime startTime;
  DateTime currentTime;
  String method;
  WalletSub.all(this.currentTime, this.action, this.billamount,
      this.revisedBalance, this.method, this.lockerName, this.startTime);

  WalletSub.add(this.action, this.billamount, this.revisedBalance, this.method,
      this.currentTime);

  WalletSub(this.billamount, this.action, this.lockerName, this.startTime,
      this.revisedBalance, this.currentTime);
  Map<String, dynamic> toJson1() => {
        'amount': billamount,
        'action': action,
        'method': method,
        'currentTime': currentTime,
        'final balance': revisedBalance,
      };

  Map<String, dynamic> toJson2() => {
        'amount': billamount,
        'action': action,
        'lockerName': lockerName,
        'startTime': startTime,
        'currentTime': currentTime,
        'final balance': revisedBalance,
      };
}
