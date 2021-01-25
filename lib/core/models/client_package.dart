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

  ClientPackage.fromMap(Map<String, dynamic> map, String uid) {
    clientPackageID = uid;
    packageID = map['packageID'];
    datePurchased = map['datePurchased'];
    expiryDate = map['expiryDate'];
    sessionsLeft = map['sessionsLeft'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'packageID': packageID,
        'datePurchased': datePurchased ?? 0,
        'expiryDate': expiryDate ?? 0,
        'sessionsLeft': sessionsLeft ?? 0
      };

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['packageID'] = packageID;
    map['datePurchased'] = map['datePurchased'];
    map['expiryDate'] = map['expiryDate'];
    map['sessionsLeft'] = map['sessionsLeft'];

    return map;
  }
}
