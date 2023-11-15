class PlannerweekInsert{
  String year;
  String month;
  String week;
  String TrainingCode;

  PlannerweekInsert(this.year, this.month, this.week,this.TrainingCode);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["year"]= year;
    map["month"]= month;
    map["week"]= week;
    map["TrainingCode"]= TrainingCode;
    return map;
  }
}