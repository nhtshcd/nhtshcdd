class GeoPloattingFarm {
  String Latitude;
  String Longitude;
  String State;
  int orderofGps;

  GeoPloattingFarm(
      this.Latitude, this.Longitude, this.State, this.orderofGps);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Latitude"] = Latitude;
    map["Longitude"] = Longitude;
    map["State"] = State;
    map["OrderofGps"] = orderofGps.toString();
    return map;
  }
}
