class TrainingtopicesInsert{
String criteriaCatName;
String criteriaCatCode;
String trainingCode;

TrainingtopicesInsert(
      this.criteriaCatName, this.criteriaCatCode, this.trainingCode);

Map<String, dynamic> toMap() {
  var map = new Map<String, dynamic>();
  map["criteriaCatName"]= criteriaCatName;
  map["criteriaCatCode"]= criteriaCatCode;
  map["trainingCode"]= trainingCode;

  return map;
}
}