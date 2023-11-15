class SprayInsert {
  String recommendation;
  String farmerId;
  String farmId;
  String plantingId;
  String blockId;
  String sprayDate;
  String chemicalName;
  String Dosage;
  String uom;
  String operatorName;
  String sprayerNumber;
  String equipmentType;
  String applicationMethod;
  String chemicalPhi;
  String TrainingStatus;
  String agrovert;
  String lastDate;
  int isSynched;
  String recNo;
  String diseaseTargeted;
  String activeIng;
  String endSprayDate;
  String oprMedRpt;

  SprayInsert(
    this.recommendation,
    this.farmerId,
    this.farmId,
    this.plantingId,
    this.blockId,
    this.sprayDate,
    this.chemicalName,
    this.Dosage,
    this.uom,
    this.operatorName,
    this.sprayerNumber,
    this.equipmentType,
    this.applicationMethod,
    this.chemicalPhi,
    this.TrainingStatus,
    this.agrovert,
    this.lastDate,
    this.isSynched,
    this.recNo,
    this.diseaseTargeted,
    this.activeIng,
    this.endSprayDate,
    this.oprMedRpt,
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["recommendation"] = recommendation;
    map["farmerId"] = farmerId;
    map["farmId"] = farmId;
    map["plantingId"] = plantingId;
    map["blockId"] = blockId;
    map["sprayDate"] = sprayDate;
    map["chemicalName"] = chemicalName;
    map["Dosage"] = Dosage;
    map["uom"] = uom;
    map["operatorName"] = operatorName;
    map["sprayerNumber"] = sprayerNumber;
    map["equipmentType"] = equipmentType;
    map["applicationMethod"] = applicationMethod;
    map["chemicalPhi"] = chemicalPhi;
    map["TrainingStatus"] = TrainingStatus;
    map["agrovert"] = agrovert;
    map["lastDate"] = lastDate;
    map["isSynched"] = isSynched;
    map["recNo"] = recNo;
    map["diseaseTargeted"] = diseaseTargeted;
    map["activeIng"] = activeIng;
    map["endSprayDate"] = endSprayDate;
    map["oprMedRpt"] = oprMedRpt;
    return map;
  }
}
