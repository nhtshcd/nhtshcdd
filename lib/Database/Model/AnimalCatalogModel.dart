class AnimalCatalog {
  String? catalog_code;
  String? property_value;
  String? DISP_SEQ;

  String? _ID;
  String? parentID;

  String? catStatus;

  AnimalCatalog(this.catalog_code, this.property_value, this.DISP_SEQ, this._ID,
      this.parentID, this.catStatus);

  AnimalCatalog.map(dynamic obj) {

    this.catalog_code = obj["catalog_code"];
    this.property_value = obj["property_value"];
    this.DISP_SEQ  = obj["DISP_SEQ "];
    this._ID = obj["_ID"];
    this.parentID  = obj["parentID "];
    this.catStatus = obj["catStatus"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["catalog_code"]=catalog_code;
    map["property_value"]=property_value;
    map["DISP_SEQ "]=DISP_SEQ ;
    map["_ID"]=_ID;
    map["parentID "]=parentID ;
    map["catStatus"]=catStatus;
    return map;
  }
}
