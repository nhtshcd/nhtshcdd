class FarmerMaster {
  String? fName;
  String? lName;
  String? farmerId;
  String? farmerCode;
  String? exporter;
  String? address;
  String? phoneNo;
  String? villageId;
  String? exporterCode;
  String? status;
  String? villageName;
  String? idProofVal;
  String? state;
  String? farmerKRA;

  FarmerMaster(
    this.fName,
    this.lName,
    this.farmerId,
    this.farmerCode,
    this.exporter,
    this.address,
    this.villageId,
    this.phoneNo,
    this.exporterCode,
    this.status,
    this.villageName,
    this.idProofVal,
    this.state,
    this.farmerKRA,
  );

  FarmerMaster.map(dynamic obj) {
    this.farmerId = obj["farmerId"];
    this.farmerCode = obj["farmerCode"];
    this.fName = obj["fName"];
    this.lName = obj["lName"];
    this.villageId = obj["villageId"];
    this.phoneNo = obj["phoneNo"];
    this.address = obj["address"];
    this.exporter = obj["exporter"];
    this.exporterCode = obj["exporterCode"];
    this.status = obj["exporterStatus"];
    this.villageName = obj["villageName"];
    this.idProofVal = obj["idProofVal"];
    this.state = obj["stateCode"];
    this.farmerKRA = obj["trader"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["farmerId"] = farmerId;
    map["farmerCode"] = farmerCode;
    map["fName"] = fName;
    map["lName"] = lName;
    map["villageId"] = villageId;
    map["phoneNo"] = phoneNo;
    map["address"] = address;
    //map["exporter"] = exporter;
    //map["exporterCode"] = exporterCode;
    map["exporterStatus"] = status;
    map["villageName"] = villageName;
    map["idProofVal"] = idProofVal;
    map["stateCode"] = state;
    map["trader"] = farmerKRA;

    return map;
  }
}
