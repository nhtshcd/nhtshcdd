class TSummaryModel {
  final String tsname;
  final String tsTotal;
  final String tsSynched;
  final String tspending;

  TSummaryModel(this.tsname, this.tsTotal, this.tsSynched, this.tspending);

  Map<String, dynamic> toMap() {
    return {
      'tsname': tsname,
      'tsTotal': tsTotal,
      'tsSynched': tsSynched,
      'tspending': tspending,
    };
  }
}

class TSummaryPendingModel {
  final String _ID;
  final String txn_Code;
  final String txn_Date;
  final String txn_Full_Date;
  final String farmerName;
  final String village;
  final String txnRefId;
  final String txnName;

  TSummaryPendingModel(this._ID, this.txn_Code, this.txn_Date,
      this.txn_Full_Date, this.farmerName, this.village, this.txnRefId, this.txnName);
}
