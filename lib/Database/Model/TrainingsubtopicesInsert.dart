class TrainingsubtopicesInsert{
String criteriaCode;
String criteriaName;
String criteriaCatCode;
String trainingCode;

TrainingsubtopicesInsert(this.criteriaCode, this.criteriaName,
      this.criteriaCatCode, this.trainingCode);

Map<String, dynamic> toMap() {
  var map = new Map<String, dynamic>();
  map["criteriaCode"]= criteriaCode;
  map["criteriaName"]= criteriaName;
  map["criteriaCatCode"]= criteriaCatCode;
  map["trainingCode"]= trainingCode;

  return map;
}
}