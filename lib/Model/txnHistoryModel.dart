class txnHistoryInfo{
  final String Date;
  final String Type;
  final String Amount;

  txnHistoryInfo(this.Date, this.Type, this.Amount);
  Map<String, dynamic> toMap() {
    return {
      'Date': Date,
      'Type': Type,
      'Amount': Amount,
    };
  }
}