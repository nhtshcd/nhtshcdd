class PlannertrainingInsert{
  String trainingCode;
  String trainingName;

  PlannertrainingInsert(this.trainingCode, this.trainingName);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["trainingCode"]= trainingCode;
    map["trainingName"]= trainingName;
    return map;
  }
}