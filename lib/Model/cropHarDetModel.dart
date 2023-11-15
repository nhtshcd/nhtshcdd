class cropHarDetModel{
  String cropType;
  String cropId;
  String cropVariety;
  String cropGrade;
  String quantity;
  String price;
  String subTotal;

  cropHarDetModel(
  this.cropType,
  this.cropId,
  this.cropVariety,
  this.cropGrade,
  this.quantity,
  this.price,
  this.subTotal,
      );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cropType"]= cropType;
    map["cropId"]= cropId;
    map["cropVariety"]= cropVariety;
    map["cropGrade"]= cropGrade;
    map["quantity"]= quantity;
    map["price"]= price;
    map["subTotal"]= subTotal;
    return map;
  }
}