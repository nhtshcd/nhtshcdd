class DistributionInsertvalue{
  String pmtAmt;
  String samCode;
  String season;
  String city;
  String wareHouseCode;
  String distributionId;
  String recpNo;
  String farmerId;
  String village;
  String farmerName;
  String distributionDate;
  int isSynched;
  String isReg;
  String mobileNo;
  String freeDistribution;
  String tax;
  String paymentMode;
  String farmerCode;
  String latitude;
  String longitude;
  String photo1;
  String photo2;

  DistributionInsertvalue(
      this.pmtAmt,
      this.samCode,
      this.season,
      this.city,
      this.wareHouseCode,
      this.distributionId,
      this.recpNo,
      this.farmerId,
      this.village,
      this.farmerName,
      this.distributionDate,
      this.isSynched,
      this.isReg,
      this.mobileNo,
      this.freeDistribution,
      this.tax,
      this.paymentMode,
      this.farmerCode,
      this.latitude,
      this.longitude,
      this.photo1,
      this.photo2);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["pmtAmt"] = pmtAmt;
    map["samCode"] = samCode;
    map["season"] = season;
    map["city"] = city;
    map["wareHouseCode"] = wareHouseCode;
    map["distributionId"] = distributionId;
    map["recpNo"] = recpNo;
    map["farmerId"] = farmerId;
    map["village"] = village;
    map["farmerName"] = farmerName;
    map["distributionDate"] = distributionDate;
    map["isSynched"] = isSynched;
    map["isReg"] = isReg;
    map["mobileNo"] = mobileNo;
    map["freeDistribution"] = freeDistribution;
    map["tax"] = tax;
    map["paymentMode"] = paymentMode;
    map["farmerCode"] = farmerCode;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["photo1"] = photo1;
    map["photo2"] = photo2;
    return map;
  }
}