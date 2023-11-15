
class AddFarmModel {
  final String farmIrrigation;
  final String NC;
  final String convenYield;
  final String convenCrop;
  final String convenLand;
  final String fallowPastureLand;
  final String landICSstatus;
  final String surveyNo;
  final String nameInteralIns;
  final String dateInternalIns;
  final String beginofConver;
  final String chemicalAppLastDate;
  final String soilFert;
  final String soilTyp;
  final String irrigationMth;
  final String irrigationRes;
  final String areaIrrigation;
  final String farmOwned;
  final String seasonalWorkerCnt;
  final String fullTimeWorkerCnt;
  final String partTimeWorkerCnt;
  final String waterBodiesCnt;
  final String landMeasure;
  final String farmAddress;
  final String isSameFarmerAddress;
  final String timeStamp;
  final String longitude;
  final String latitude;
  final String image;
  final String farmIDT;
  final String farmArea;
  final String farmName;
  final String farmerId;
  final String prodLand;
  final String notProdLand;
  final String landProd;
  final String landNProd;
  final String isSynched;
  final String recptId;
  final String farmStatus;
  final String landOwner;
  final String landGradient;
  final String approachRoad;
  final String year;
  final String soilTexture;
  final String otherIrrigationRes;
  final String verifyStatus;
  final String labourDetails;
  final String seasonYear;
  final String landTopography;
  final String soilTest;
  final String testPhoto;
  final String otherLandOwn;
  final String farmRegNo;
  final String currentConversion;
  final String inspectionDate;
  final String nameInspector;
  final String qualify;
  final String reasonSanction;
  final String durationSanction;
  final String farmId;
  final String farmDistrict;
  final String farmTaluk;
  final String farmPanchayat;
  final String farmVillage;
  final String farmSamithee;
  final String farmFPOFG;
  final String farmLandDetails;
  final String farmCrop;
  final String farmVariety;
  final String tenantId;
  final String farmcertYear;
  final String farmPlatNo;
  final String waterHarvest;
  final String avgStorage;
  final String treeName;
  final String distProcessUnit;
  final String processAct;
  final String farmdeleteStatus;
  final String farmCertType;
  final String waterSource;
  final String locCroTree;
  final String numCroTrees;
  final String irrLand;
  final String ownLand;
  final String leaseLand;
  final String frPhoto;
  final String fieldName;
  final String fieldArea;
  final String fieldCrop;
  final String qtyApply;
  final String lstDtCheApp;
  final String inputsApp;
  final String inpSource;
  final String actCocFarm;
  final String presenceBanana;
  final String parallelProduction;
  final String organicUnit;
  final String hiredLabour;
  final String riskCategory;
  final String numCofTrees;
  final String vermiUnit;
  final String docIdNo;
  final String coffeeMac;
  final String pltStatus;
  final String totLand;
  final String insType;
  final String inspName;
  final String insDate;
  final String inspDetList;
  final String dynfield;
  final String geoStatus;

  AddFarmModel(
      this.farmIrrigation,
      this.NC,
      this.convenYield,
      this.convenCrop,
      this.convenLand,
      this.fallowPastureLand,
      this.landICSstatus,
      this.surveyNo,
      this.nameInteralIns,
      this.dateInternalIns,
      this.beginofConver,
      this.chemicalAppLastDate,
      this.soilFert,
      this.soilTyp,
      this.irrigationMth,
      this.irrigationRes,
      this.areaIrrigation,
      this.farmOwned,
      this.seasonalWorkerCnt,
      this.fullTimeWorkerCnt,
      this.partTimeWorkerCnt,
      this.waterBodiesCnt,
      this.landMeasure,
      this.farmAddress,
      this.isSameFarmerAddress,
      this.timeStamp,
      this.longitude,
      this.latitude,
      this.image,
      this.farmIDT,
      this.farmArea,
      this.farmName,
      this.farmerId,
      this.prodLand,
      this.notProdLand,
      this.landProd,
      this.landNProd,
      this.isSynched,
      this.recptId,
      this.farmStatus,
      this.landOwner,
      this.landGradient,
      this.approachRoad,
      this.year,
      this.soilTexture,
      this.otherIrrigationRes,
      this.verifyStatus,
      this.labourDetails,
      this.seasonYear,
      this.landTopography,
      this.soilTest,
      this.testPhoto,
      this.otherLandOwn,
      this.farmRegNo,
      this.currentConversion,
      this.inspectionDate,
      this.nameInspector,
      this.qualify,
      this.reasonSanction,
      this.durationSanction,
      this.farmId,
      this.farmDistrict,
      this.farmTaluk,
      this.farmPanchayat,
      this.farmVillage,
      this.farmSamithee,
      this.farmFPOFG,
      this.farmLandDetails,
      this.farmCrop,
      this.farmVariety,
      this.tenantId,
      this.farmcertYear,
      this.farmPlatNo,
      this.waterHarvest,
      this.avgStorage,
      this.treeName,
      this.distProcessUnit,
      this.processAct,
      this.farmdeleteStatus,
      this.farmCertType,
      this.waterSource,
      this.locCroTree,
      this.numCroTrees,
      this.irrLand,
      this.ownLand,
      this.leaseLand,
      this.frPhoto,
      this.fieldName,
      this.fieldArea,
      this.fieldCrop,
      this.qtyApply,
      this.lstDtCheApp,
      this.inputsApp,
      this.inpSource,
      this.actCocFarm,
      this.presenceBanana,
      this.parallelProduction,
      this.organicUnit,
      this.hiredLabour,
      this.riskCategory,
      this.numCofTrees,
      this.vermiUnit,
      this.docIdNo,
      this.coffeeMac,
      this.pltStatus,
      this.totLand,
      this.insType,
      this.inspName,
      this.insDate,
      this.inspDetList,
      this.dynfield,
      this.geoStatus);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["farmIrrigation"] = farmIrrigation;
    map["NC"] = NC;
    map["convenYield"] = convenYield;
    map["convenCrop"] = convenCrop;
    map["convenLand"] = convenLand;
    map["fallowPastureLand"] = fallowPastureLand;
    map["landICSstatus"] = landICSstatus;
    map["surveyNo"] = surveyNo;
    map["nameInteralIns"] = nameInteralIns;
    map["dateInternalIns"] = dateInternalIns;
    map["beginofConver"] = beginofConver;
    map["chemicalAppLastDate"] = chemicalAppLastDate;
    map["soilFert"] = soilFert;
    map["soilTyp"] = soilTyp;
    map["irrigationMth"] = irrigationMth;
    map["irrigationRes"] = irrigationRes;
    map["areaIrrigation"] = areaIrrigation;
    map["farmOwned"] = farmOwned;
    map["seasonalWorkerCnt"] = seasonalWorkerCnt;
    map["fullTimeWorkerCnt"] = fullTimeWorkerCnt;
    map["partTimeWorkerCnt"] = partTimeWorkerCnt;
    map["waterBodiesCnt"] = waterBodiesCnt;
    map["landMeasure"] = landMeasure;
    map["farmAddress"] = farmAddress;
    map["isSameFarmerAddress"] = isSameFarmerAddress;
    map["timeStamp"] = timeStamp;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["image"] = image;
    map["farmIDT"] = farmIDT;
    map["farmArea"] = farmArea;
    map["farmName"] = farmName;
    map["farmerId"] = farmerId;
    map["prodLand"] = prodLand;
    map["notProdLand"] = notProdLand;
    map["landProd"] = landProd;
    map["landNProd"] = landNProd;
    map["isSynched"] = isSynched;
    map["recptId"] = recptId;
    map["farmStatus"] = farmStatus;
    map["landOwner"] = landOwner;
    map["landGradient"] = landGradient;
    map["approachRoad"] = approachRoad;
    map["year"] = year;
    map["soilTexture"] = soilTexture;
    map["otherIrrigationRes"] = otherIrrigationRes;
    map["verifyStatus"] = verifyStatus;
    map["labourDetails"] = labourDetails;
    map["seasonYear"] = seasonYear;
    map["landTopography"] = landTopography;
    map["soilTest"] = soilTest;
    map["testPhoto"] = testPhoto;
    map["otherLandOwn"] = otherLandOwn;
    map["farmRegNo"] = farmRegNo;
    map["currentConversion"] = currentConversion;
    map["inspectionDate"] = inspectionDate;
    map["nameInspector"] = nameInspector;
    map["qualify"] = qualify;
    map["reasonSanction"] = reasonSanction;
    map["durationSanction"] = durationSanction;
    map["farmId"] = farmId;
    map["farmDistrict"] = farmDistrict;
    map["farmTaluk"] = farmTaluk;
    map["farmPanchayat"] = farmPanchayat;
    map["farmVillage"] = farmVillage;
    map["farmSamithee"] = farmSamithee;
    map["farmFPOFG"] = farmFPOFG;
    map["farmLandDetails"] = farmLandDetails;
    map["farmCrop"] = farmCrop;
    map["farmVariety"] = farmVariety;
    map["tenantId"] = tenantId;
    map["farmcertYear"] = farmcertYear;
    map["farmPlatNo"] = farmPlatNo;
    map["waterHarvest"] = waterHarvest;
    map["avgStorage"] = avgStorage;
    map["treeName"] = treeName;
    map["distProcessUnit"] = distProcessUnit;
    map["processAct"] = processAct;
    map["farmdeleteStatus"] = farmdeleteStatus;
    map["farmCertType"] = farmCertType;
    map["waterSource"] = waterSource;
    map["locCroTree"] = locCroTree;
    map["numCroTrees"] = numCroTrees;
    map["irrLand"] = irrLand;
    map["ownLand"] = ownLand;
    map["leaseLand"] = leaseLand;
    map["frPhoto"] = frPhoto;
    map["fieldName"] = fieldName;
    map["fieldArea"] = fieldArea;
    map["fieldCrop"] = fieldCrop;
    map["qtyApply"] = qtyApply;
    map["lstDtCheApp"] = lstDtCheApp;
    map["inputsApp"] = inputsApp;
    map["inpSource"] = inpSource;
    map["actCocFarm"] = actCocFarm;
    map["presenceBanana"] = presenceBanana;
    map["parallelProduction"] = parallelProduction;
    map["organicUnit"] = organicUnit;
    map["hiredLabour"] = hiredLabour;
    map["riskCategory"] = riskCategory;
    map["numCofTrees"] = numCofTrees;
    map["vermiUnit"] = vermiUnit;
    map["docIdNo"] = docIdNo;
    map["coffeeMac"] = coffeeMac;
    map["pltStatus"] = pltStatus;
    map["totLand"] = totLand;
    map["insType"] = insType;
    map["inspName"] = inspName;
    map["insDate"] = insDate;
    map["inspDetList"] = inspDetList;
    map["dynfield"] = dynfield;
    map["geoStatus"] = geoStatus;
    return map;
  }

}


