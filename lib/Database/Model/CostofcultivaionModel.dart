class CostofcultivationModel{
  int isSynched;
  String farmerId;
  String farmId;
  String recpNo;
  String cocDate;
  String cocCategory;
  String incomeFromAgriCOC;
  String incomeFromInterCOC;
  String incomeFromOtherCOC;
  String landPreTotal;
  String sowingTotal;
  String gapfillTotal;
  String WeedingTotal;
  String cultureTotal;
  String irrigationTotal;
  String fertilizerTotal;
  String pesticideTotal;
  String harvestTotal;
  String tototrExp;
  String totalExpenses;
  String currentSeason;
  String manureTotal;
  String longitude;
  String latitude;
  String cropId;
  String soilPrepare;
  String labourHire;
  String manureUse;
  String fertUse;
  String soilPrepareLabour;
  String seedBuyCostLabour;
  String gapFillingLabour;
  String WeedingCostsLabour;
  String IrrigationCostsLabour;
  String InputCostsLabour;
  String HarvestCostLabour;
  String totManureCostLabour;
  String bioFertCostLabour;
  String bioPestCostLabour;
  String OtherCostsGin;
  String OtherCostsFuel;
  String pestUse;

  CostofcultivationModel(
      this.isSynched,
      this.farmerId,
      this.farmId,
      this.recpNo,
      this.cocDate,
      this.cocCategory,
      this.incomeFromAgriCOC,
      this.incomeFromInterCOC,
      this.incomeFromOtherCOC,
      this.landPreTotal,
      this.sowingTotal,
      this.gapfillTotal,
      this.WeedingTotal,
      this.cultureTotal,
      this.irrigationTotal,
      this.fertilizerTotal,
      this.pesticideTotal,
      this.harvestTotal,
      this.tototrExp,
      this.totalExpenses,
      this.currentSeason,
      this.manureTotal,
      this.longitude,
      this.latitude,
      this.cropId,
      this.soilPrepare,
      this.labourHire,
      this.manureUse,
      this.fertUse,
      this.soilPrepareLabour,
      this.seedBuyCostLabour,
      this.gapFillingLabour,
      this.WeedingCostsLabour,
      this.IrrigationCostsLabour,
      this.InputCostsLabour,
      this.HarvestCostLabour,
      this.totManureCostLabour,
      this.bioFertCostLabour,
      this.bioPestCostLabour,
      this.OtherCostsGin,
      this.OtherCostsFuel,
      this.pestUse);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["isSynched"] = isSynched;
    map["farmerId"] = farmerId;
    map["farmId"] = farmId;
    map["recpNo"] = recpNo;
    map["cocDate"] = cocDate;
    map["cocCategory"] = cocCategory;
    map["incomeFromAgriCOC"] = incomeFromAgriCOC;
    map["incomeFromInterCOC"] = incomeFromInterCOC;
    map["incomeFromOtherCOC"] = incomeFromOtherCOC;
    map["landPreTotal"] = landPreTotal;
    map["sowingTotal"] = sowingTotal;
    map["gapfillTotal"] = gapfillTotal;
    map["WeedingTotal"] = WeedingTotal;
    map["cultureTotal"] = cultureTotal;
    map["irrigationTotal"] = irrigationTotal;
    map["fertilizerTotal"] = fertilizerTotal;
    map["pesticideTotal"] = pesticideTotal;
    map["harvestTotal"] = harvestTotal;
    map["tototrExp"] = tototrExp;
    map["totalExpenses"] = totalExpenses;
    map["currentSeason"] = currentSeason;
    map["manureTotal"] = manureTotal;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["cropId"] = cropId;
    map["soilPrepare"] = soilPrepare;
    map["labourHire"] = labourHire;
    map["manureUse"] = manureUse;
    map["fertUse"] = fertUse;
    map["soilPrepareLabour"] = soilPrepareLabour;
    map["seedBuyCostLabour"] = seedBuyCostLabour;
    map["gapFillingLabour"] = gapFillingLabour;
    map["WeedingCostsLabour"] = WeedingCostsLabour;
    map["IrrigationCostsLabour"] = IrrigationCostsLabour;
    map["InputCostsLabour"] = InputCostsLabour;
    map["HarvestCostLabour"] = HarvestCostLabour;
    map["totManureCostLabour"] = totManureCostLabour;
    map["bioFertCostLabour"] = bioFertCostLabour;
    map["bioPestCostLabour"] = bioPestCostLabour;
    map["OtherCostsGin"] = OtherCostsGin;
    map["OtherCostsFuel"] = OtherCostsFuel;
    map["pestUse"] = pestUse;
    return map;
  }
}