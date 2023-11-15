class cropHarvestModel{
  String season;
  String recNo;
  String harvestDate;
  String farmerId;
  String farmId;
  String total;
  String packOther;
  String storOther;
  String storage;
  String packed;
  String latitude;
  String longitude;
  String isSynched;

  cropHarvestModel(
  this.season,
  this.recNo,
  this.harvestDate,
  this.farmerId,
  this.farmId,
  this.total,
  this.packOther,
  this.storOther,
  this.storage,
  this.packed,
  this.latitude,
  this.longitude,
      this.isSynched,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["season"]= season;
    map["recNo"]= recNo;
    map["harvestDate"]= harvestDate;
    map["farmerId"]= farmerId;
    map["farmId"]= farmId;
    map["total"]= total;
    map["packOther"]= packOther;
    map["storOther"]= storOther;
    map["storage"]= storage;
    map["packed"]= packed;
    map["latitude"]= latitude;
    map["longitude"]= longitude;
    map["isSynched"]= isSynched;
    return map;
  }
}