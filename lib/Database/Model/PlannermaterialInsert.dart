class PlannermaterialInsert{

  String materialCode;
  String materialName;
  String trainingCode;

  PlannermaterialInsert(
      this.materialCode, this.materialName, this.trainingCode);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["materialCode"]= materialCode;
    map["materialName"]= materialName;
    map["trainingCode"]= trainingCode;
    return map;
  }
}