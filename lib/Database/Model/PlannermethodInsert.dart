class PlannermethodInsert{
  String methodCode;
  String methodName;
  String trainingCode;

  PlannermethodInsert(this.methodCode, this.methodName, this.trainingCode);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["methodCode"]= methodCode;
    map["methodName"]= methodName;
    map["trainingCode"]= trainingCode;
    return map;
  }
}