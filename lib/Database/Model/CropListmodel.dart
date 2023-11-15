class CropListmodel{
  String cropCode;
  String cropArea;
  String production;
  String cropSeason;
  String cropCategory;
  String farmCodeRef ;
  String reciptId  ;
  String seedSource;
  String cropVariety;
  String farmerId;
  String stableLengthMain;
  String othercropType;
  String seedusedMain;
  String seedcostMain;
  String cropType;
  String estHarvestDt;
  String dateOfSown;
  String seedTreatment;
  String otherSeedTreatment;
  String riskBufferZone;
  String riskAssesment;
  String cultivationType;
  String culAreaCrop;
  String interCropType;
  String interCropAcr;
  String interCropHarvest;
  String interCropGrossIncome;
  String noOftrees;
  String affectedTrees;
  String prodctOftrees;
  String yearofplant;
  String cropEditStatus;

  CropListmodel(
      this.cropCode,
      this.cropArea,
      this.production,
      this.cropSeason,
      this.cropCategory,
      this.farmCodeRef,
      this.reciptId,
      this.seedSource,
      this.cropVariety,
      this.farmerId,
      this.stableLengthMain,
      this.othercropType,
      this.seedusedMain,
      this.seedcostMain,
      this.cropType,
      this.estHarvestDt,
      this.dateOfSown,
      this.seedTreatment,
      this.otherSeedTreatment,
      this.riskBufferZone,
      this.riskAssesment,
      this.cultivationType,
      this.culAreaCrop,
      this.interCropType,
      this.interCropAcr,
      this.interCropHarvest,
      this.interCropGrossIncome,
      this.noOftrees,
      this.affectedTrees,
      this.prodctOftrees,
      this.yearofplant,
      this.cropEditStatus);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cropCode"]=cropCode;
    map["cropArea"]=cropArea;
    map["production"]=production;
    map["cropSeason"]=cropSeason;
    map["cropCategory"]=cropCategory;
    map["farmCodeRef"]=farmCodeRef ;
    map["reciptId"]=reciptId  ;
    map["seedSource"]=seedSource;
    map["cropVariety"]=cropVariety;
    map["farmerId"]=farmerId;
    map["stableLengthMain"]=stableLengthMain;
    map["othercropType"]=othercropType;
    map["seedusedMain"]=seedusedMain;
    map["seedcostMain"]=seedcostMain;
    map["cropType"]=cropType;
    map["estHarvestDt"]=estHarvestDt;
    map["dateOfSown"]=dateOfSown;
    map["seedTreatment"]=seedTreatment;
    map["otherSeedTreatment"]=otherSeedTreatment;
    map["riskBufferZone"]=riskBufferZone;
    map["riskAssesment"]=riskAssesment;
    map["cultivationType"]=cultivationType;
    map["culAreaCrop"]=culAreaCrop;
    map["interCropType"]=interCropType;
    map["interCropAcr"]=interCropAcr;
    map["interCropHarvest"]=interCropHarvest;
    map["interCropGrossIncome"]=interCropGrossIncome;
    map["noOftrees"]=noOftrees;
    map["affectedTrees"]=affectedTrees;
    map["prodctOftrees"]=prodctOftrees;
    map["yearofplant"]=yearofplant;
    map["cropEditStatus"]=cropEditStatus;
    return map;
  }
}
