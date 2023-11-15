class opeDayInsert{
  String recNo;
  String date;
  String season;
  String station;
  String isSynched;
  String latitude;
  String longitude;
  String status;

  opeDayInsert(
      this.recNo,
      this.date,
      this.season,
      this.station,
      this.isSynched,
      this.latitude,
      this.longitude,
      this.status,
      );
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["recNo"]=recNo;
    map["dateOpen"]=date;
    map["season"]=season;
    map["station"]=station;
    map["isSynched"]=isSynched;
    map["latitude"]=latitude;
    map["longitude"]=longitude;
    map["status"]=status;
    return map;
  }
}