class ClientPackage {
  String clientPackageID;
  String packageID;
  int datePurchased;
  int expiryDate;
  int sessionsLeft;

  ClientPackage(
      {this.clientPackageID,
      this.packageID,
      this.datePurchased,
      this.expiryDate,
      this.sessionsLeft});

  ClientPackage.fromMap(Map<String, dynamic> map) {
    clientPackageID = map['clientPackageID'];
    packageID = map['packageID'];
    datePurchased = map['datePurchased'];
    expiryDate = map['expiryDate'];
    sessionsLeft = map['sessionsLeft'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['clientPackageID'] = clientPackageID;
    map['packageID'] = packageID;
    map['datePurchased'] = map['datePurchased'];
    map['expiryDate'] = map['expiryDate'];
    map['sessionsLeft'] = map['sessionsLeft'];

    return map;
  }
}
