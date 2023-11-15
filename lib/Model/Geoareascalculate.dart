class Geoareascalculate {

  String Acre;
  String Hectare;
  String Squaremeters;


  Geoareascalculate(this.Acre, this.Hectare, this.Squaremeters);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Acre"] = Acre;
    map["Hectare"] = Hectare;
    map["Squaremeters"] = Squaremeters;
    return map;
  }

}