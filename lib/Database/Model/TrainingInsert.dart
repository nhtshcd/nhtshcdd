class TrainingInsert {
  String recNo;
  String date;
  String season;
  String village;
  String learnGroup;
  String FarmersIds;
  String remarks;
  String isSynched;
  String latitude;
  String longitude;
  String Farmerscount;
  String trainingDetail;
  String trainingTopic;
  String trainingSubTopic;
  String trainingMaterial;
  String trainingMethod;
  String trainingObservation;
  String trainingAssistent;
  String trainingTime;

  TrainingInsert(
      this.recNo,
      this.date,
      this.season,
      this.village,
      this.learnGroup,
      this.FarmersIds,
      this.remarks,
      this.isSynched,
      this.latitude,
      this.longitude,
      this.Farmerscount,
      this.trainingDetail,
      this.trainingTopic,
      this.trainingSubTopic,
      this.trainingMaterial,
      this.trainingMethod,
      this.trainingObservation,
      this.trainingAssistent,
      this.trainingTime);
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["recNo"]=recNo;
    map["date"]=date;
    map["season"]=season;
    map["village"]=village;
    map["learnGroup"]=learnGroup;
    map["FarmersIds"]=FarmersIds;
    map["remarks"]=remarks;
    map["isSynched"]=isSynched;
    map["latitude"]=latitude;
    map["longitude"]=longitude;
    map["Farmerscount"]=Farmerscount;
    map["trainingDetail"]=trainingDetail;
    map["trainingTopic"]=trainingTopic;
    map["trainingSubTopic"]=trainingSubTopic;
    map["trainingMaterial"]=trainingMaterial;
    map["trainingMethod"]=trainingMethod;
    map["trainingObservation"]=trainingObservation;
    map["trainingAssistent"]=trainingAssistent;
    map["trainingTime"]=trainingTime;
    return map;
  }
}