class inpRetDetModel{
  String productCode;
  String quantity;
  String pricePerUnit;
  String subTotal;
  String batchNo;

  inpRetDetModel(
      this.productCode,
      this.quantity,
      this.pricePerUnit,
      this.subTotal,
      this.batchNo,
      );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["productCode"] = productCode;
    map["quantity"] = quantity;
    map["pricePerUnit"] = pricePerUnit;
    map["subTotal"] = subTotal;
    map["batchNo"] = batchNo;
    return map;
  }
}