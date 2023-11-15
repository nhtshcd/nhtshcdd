class PlannerobservationInsert{
  String observCode;
  String observName;
  String trainingCode;

  PlannerobservationInsert(this.observCode, this.observName, this.trainingCode);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["observCode"]= observCode;
    map["observName"]= observName;
    map["trainingCode"]= trainingCode;
    return map;
  }
}