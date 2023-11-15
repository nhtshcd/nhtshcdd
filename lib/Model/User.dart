class User {
  final String clientProjectRev;
  final String agentDistributionBal;
  final String agentProcurementBal;
  final String currentSeasonCode;
  final String pricePatternRev;
  final String agentType;
  final String tareWeight;
  final String curIdSeqS;
  final String resIdSeqS;
  final String curIdLimitS;
  final String curIdLimitF;
  final String resIdSeqF;
  final String curIdSeqF;
  final String agentAccBal;
  final String farmerRev;
  final String shopRev;
  final String agentId;
  final String agentName;
  final String cityCode;
  final String servPointName;
  final String agentPassword;
  final String servicePointId;
  final String locationRev;
  final String trainingRev;
  final String plannerRev;
  final String farmerOutStandBalRev;
  final String productDwRev;
  final String farmCrpDwRev;
  final String procurementProdDwRev;
  final String villageWareHouseDwRev;
  final String gradeDwRev;
  final String wareHouseStockDwRev;
  final String coOperativeDwRev;
  final String trainingCatRev;
  final String seasonDwRev;
  final String fieldStaffRev;
  final String areaCaptureMode;
  final String interestRateApplicable;
  final String rateOfInterest;
  final String effectiveFrom;
  final String isApplicableForExisting;
  final String previousInterestRate;
  final String qrScan;
  final String geoFenceFlag;
  final String geoFenceRadius;
  final String buyerDwRev;
  final String catalogDwRev;
  final String parentID;
  final String branchID;
  final String isGeneric;
  final String supplierDwRev;
  final String researchStationDwRev;
  final String displayDtFmt;
  final String batchAvailable;
  final String isGrampnchayat;
  final String areaUnitType;
  final String currency;
  final String farmerfarmRev;
  final String farmerfarmcropRev;
  final String warehouseId;
  final String farmerStockBalRev;
  final String latestSeasonRevNo;
  final String latestCatalogRevNo;
  final String latestLocationRevNo;
  final String latestCooperativeRevNo;
  final String latestProcproductRevNo;
  final String latestFarmerRevNo;
  final String latestFarmRevNo;
  final String latestFarmCropRevNo;
  final String dynamicDwRev;
  final String isBuyer;
  final String distributionPhoto;
  final String latestwsRevNo;
  final String digitalSign;
  final String cropCalandar;
  final String eventDwRev;
  final String seasonProdFlag;
  final String followUpRevNo;
  final String lotNoPack;
  final String packHouseId;
  final String packHouseName;
  final String expLic;
  final String packHouseCode;
  final String exporterId;
  final String exporterName;
  final String ag_days;
  final String p_age;
  final String p_rem;
  final String variety;
  final String gCode;
  final String fLogin;
  final String expDate;
  final String expStatus;
  final String shipmentUrl;

  User(
    this.clientProjectRev,
    this.agentDistributionBal,
    this.agentProcurementBal,
    this.currentSeasonCode,
    this.pricePatternRev,
    this.agentType,
    this.tareWeight,
    this.curIdSeqS,
    this.resIdSeqS,
    this.curIdLimitS,
    this.curIdLimitF,
    this.resIdSeqF,
    this.curIdSeqF,
    this.agentAccBal,
    this.farmerRev,
    this.shopRev,
    this.agentId,
    this.agentName,
    this.cityCode,
    this.servPointName,
    this.agentPassword,
    this.servicePointId,
    this.locationRev,
    this.trainingRev,
    this.plannerRev,
    this.farmerOutStandBalRev,
    this.productDwRev,
    this.farmCrpDwRev,
    this.procurementProdDwRev,
    this.villageWareHouseDwRev,
    this.gradeDwRev,
    this.wareHouseStockDwRev,
    this.coOperativeDwRev,
    this.trainingCatRev,
    this.seasonDwRev,
    this.fieldStaffRev,
    this.areaCaptureMode,
    this.interestRateApplicable,
    this.rateOfInterest,
    this.effectiveFrom,
    this.isApplicableForExisting,
    this.previousInterestRate,
    this.qrScan,
    this.geoFenceFlag,
    this.geoFenceRadius,
    this.buyerDwRev,
    this.catalogDwRev,
    this.parentID,
    this.branchID,
    this.isGeneric,
    this.supplierDwRev,
    this.researchStationDwRev,
    this.displayDtFmt,
    this.batchAvailable,
    this.isGrampnchayat,
    this.areaUnitType,
    this.currency,
    this.farmerfarmRev,
    this.farmerfarmcropRev,
    this.warehouseId,
    this.farmerStockBalRev,
    this.latestSeasonRevNo,
    this.latestCatalogRevNo,
    this.latestLocationRevNo,
    this.latestCooperativeRevNo,
    this.latestProcproductRevNo,
    this.latestFarmerRevNo,
    this.latestFarmRevNo,
    this.latestFarmCropRevNo,
    this.dynamicDwRev,
    this.isBuyer,
    this.distributionPhoto,
    this.latestwsRevNo,
    this.digitalSign,
    this.cropCalandar,
    this.eventDwRev,
    this.seasonProdFlag,
    this.followUpRevNo,
    this.lotNoPack,
    this.packHouseId,
    this.packHouseName,
    this.expLic,
    this.packHouseCode,
    this.exporterId,
    this.exporterName,
    this.ag_days,
    this.p_age,
    this.p_rem,
    this.variety,
    this.gCode,
    this.fLogin,
    this.expDate,
    this.expStatus,
    this.shipmentUrl,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["clientProjectRev"] = clientProjectRev;
    map["agentDistributionBal"] = agentDistributionBal;
    map["agentProcurementBal"] = agentProcurementBal;
    map["currentSeasonCode"] = currentSeasonCode;
    map["pricePatternRev"] = pricePatternRev;
    map["agentType"] = agentType;
    map["tareWeight"] = tareWeight;
    map["curIdSeqS"] = curIdSeqS;
    map["resIdSeqS"] = resIdSeqS;
    map["curIdLimitS"] = curIdLimitS;
    map["curIdLimitF"] = curIdLimitF;
    map["resIdSeqF"] = resIdSeqF;
    map["curIdSeqF"] = curIdSeqF;
    map["agentAccBal"] = agentAccBal;
    map["farmerRev"] = farmerRev;
    map["shopRev"] = shopRev;
    map["agentId"] = agentId;
    map["agentName"] = agentName;
    map["cityCode"] = cityCode;
    map["servPointName"] = servPointName;
    map["agentPassword"] = agentPassword;
    map["servicePointId"] = servicePointId;
    map["locationRev"] = locationRev;
    map["trainingRev"] = trainingRev;
    map["plannerRev"] = plannerRev;
    map["farmerOutStandBalRev"] = farmerOutStandBalRev;
    map["productDwRev"] = productDwRev;
    map["farmCrpDwRev"] = farmCrpDwRev;
    map["procurementProdDwRev"] = procurementProdDwRev;
    map["villageWareHouseDwRev"] = villageWareHouseDwRev;
    map["gradeDwRev"] = gradeDwRev;
    map["wareHouseStockDwRev"] = wareHouseStockDwRev;
    map["coOperativeDwRev"] = coOperativeDwRev;
    map["trainingCatRev"] = trainingCatRev;
    map["seasonDwRev"] = seasonDwRev;
    map["fieldStaffRev"] = fieldStaffRev;
    map["areaCaptureMode"] = areaCaptureMode;
    map["interestRateApplicable"] = interestRateApplicable;
    map["rateOfInterest"] = rateOfInterest;
    map["effectiveFrom"] = effectiveFrom;
    map["isApplicableForExisting"] = isApplicableForExisting;
    map["previousInterestRate"] = previousInterestRate;
    map["qrScan"] = qrScan;
    map["geoFenceFlag"] = geoFenceFlag;
    map["geoFenceRadius"] = geoFenceRadius;
    map["buyerDwRev"] = buyerDwRev;
    map["catalogDwRev"] = catalogDwRev;
    map["parentID"] = parentID;
    map["branchID"] = branchID;
    map["isGeneric"] = isGeneric;
    map["supplierDwRev"] = supplierDwRev;
    map["researchStationDwRev"] = researchStationDwRev;
    map["displayDtFmt"] = displayDtFmt;
    map["batchAvailable"] = batchAvailable;
    map["isGrampnchayat"] = isGrampnchayat;
    map["areaUnitType"] = areaUnitType;
    map["currency"] = currency;
    map["farmerfarmRev"] = farmerfarmRev;
    map["farmerfarmcropRev"] = farmerfarmcropRev;
    map["warehouseId"] = warehouseId;
    map["farmerStockBalRev"] = farmerStockBalRev;
    map["latestSeasonRevNo"] = latestSeasonRevNo;
    map["latestCatalogRevNo"] = latestCatalogRevNo;
    map["latestLocationRevNo"] = latestLocationRevNo;
    map["latestCooperativeRevNo"] = latestCooperativeRevNo;
    map["latestProcproductRevNo"] = latestProcproductRevNo;
    map["latestFarmerRevNo"] = latestFarmerRevNo;
    map["latestFarmRevNo"] = latestFarmRevNo;
    map["latestFarmCropRevNo"] = latestFarmCropRevNo;
    map["dynamicDwRev"] = dynamicDwRev;
    map["isBuyer"] = isBuyer;
    map["distributionPhoto"] = distributionPhoto;
    map["latestwsRevNo"] = latestwsRevNo;
    map["digitalSign"] = digitalSign;
    map["cropCalandar"] = cropCalandar;
    map["eventDwRev"] = eventDwRev;
    map["seasonProdFlag"] = seasonProdFlag;
    map["followUpRevNo"] = followUpRevNo;
    map["lotNoPack"] = lotNoPack;
    map["packHouseId"] = packHouseId;
    map["packHouseName"] = packHouseName;
    map["exportLic"] = expLic;
    map["packHouseCode"] = packHouseCode;
    map["exporterId"] = exporterId;
    map["exporterName"] = exporterName;
    map["pwExpDays"] = ag_days;
    map["pwDate"] = p_age;
    map["pwRemainder"] = p_rem;
    map["variety"] = variety;
    map["gCode"] = gCode;
    map["fLogin"] = fLogin;
    map["exportLicDate"] = expDate;
    map["exportStatus"] = expStatus;
    map["effectiveFrom"] = shipmentUrl;
    return map;
  }

/*String get name => _name;
  String get address => _address;
  int get id => _id;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["address"] = _address;
    return map;
  }
  factory User.fromJson(dynamic String) {
    return User(String['name'],String['address']);
  }

  void setUserId(int id) {
    this._id = id;
  }
  void setName(String name) {
    this._name = name;
  }
  void setAddress(String address) {
    this._address = address;
  }*/
}
