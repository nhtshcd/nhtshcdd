class SynchDownload {
  Response? response;

  SynchDownload({this.response});

  factory SynchDownload.fromJson(Map<String, dynamic> json) {
    return SynchDownload(
      response:
          json['Response'] != null ? Response.fromJson(json['Response']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Body? body;
  Status? status;

  Response({this.body, this.status});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Status {
  String? code;
  String? message;

  Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Body {
  AgentLogin? agentLogin;
  Data0? data0;
  Data1? data1;
  Data2? data2;
  Data3? data3;
  Data6? data6;
  Data8? data8;
  Data9? data9;
  Data10? data10;
  Data11? data11;

  Body(
      {this.agentLogin,
      this.data0,
      this.data1,
      this.data2,
      this.data3,
      this.data6,
      this.data8,
      this.data9,
      this.data10,
      this.data11});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      agentLogin: json['agentLogin'] != null
          ? AgentLogin.fromJson(json['agentLogin'])
          : null,
      data0: json['data0'] != null ? Data0.fromJson(json['data0']) : null,
      data1: json['data1'] != null ? Data1.fromJson(json['data1']) : null,
      data2: json['data2'] != null ? Data2.fromJson(json['data2']) : null,
      data3: json['data3'] != null ? Data3.fromJson(json['data3']) : null,
      data6: json['data6'] != null ? Data6.fromJson(json['data6']) : null,
      data8: json['data8'] != null ? Data8.fromJson(json['data8']) : null,
      data9: json['data9'] != null ? Data9.fromJson(json['data9']) : null,
      data10: json['data10'] != null ? Data10.fromJson(json['data10']) : null,
      data11: json['data11'] != null ? Data11.fromJson(json['data11']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agentLogin != null) {
      data['agentLogin'] = this.agentLogin!.toJson();
    }
    if (this.data0 != null) {
      data['data0'] = this.data0!.toJson();
    }
    if (this.data1 != null) {
      data['data1'] = this.data1!.toJson();
    }
    if (this.data2 != null) {
      data['data2'] = this.data2!.toJson();
    }
    if (this.data3 != null) {
      data['data3'] = this.data3!.toJson();
    }
    if (this.data6 != null) {
      data['data6'] = this.data6!.toJson();
    }
    if (this.data8 != null) {
      data['data8'] = this.data8!.toJson();
    }
    if (this.data9 != null) {
      data['data9'] = this.data9!.toJson();
    }
    return data;
  }
}

class Data1 {
  String? seasonRevNo;
  List<Season>? seasons;

  Data1({this.seasonRevNo, this.seasons});

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      seasonRevNo: json['seasonRevNo'],
      seasons: json['seasons'] != null
          ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonRevNo'] = this.seasonRevNo;
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Season {
  List? lang;
  String? sCode;
  String? sName;

  Season({this.lang, this.sCode, this.sName});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      lang: json['lang'],
      sCode: json['sCode'],
      sName: json['sName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sCode'] = this.sCode;
    data['sName'] = this.sName;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class Data2 {
  List<Country>? countryList;
  String? lRevNo;

  Data2({this.countryList, this.lRevNo});

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      countryList: json['countryList'] != null
          ? (json['countryList'] as List)
              .map((i) => Country.fromJson(i))
              .toList()
          : null,
      lRevNo: json['lRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lRevNo'] = this.lRevNo;
    if (this.countryList != null) {
      data['countryList'] = this.countryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  String? countryCode;
  String? countryName;
  List? lang;
  List<States>? stateList;

  Country({this.countryCode, this.countryName, this.lang, this.stateList});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['countryCode'],
      countryName: json['countryName'],
      lang: json['lang'],
      stateList: json['stateList'] != null
          ? (json['stateList'] as List).map((i) => States.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['countryName'] = this.countryName;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    if (this.stateList != null) {
      data['stateList'] = this.stateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  List<District>? districtList;
  List? lang;
  String? stateCode;
  String? stateName;

  States({this.districtList, this.lang, this.stateCode, this.stateName});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      districtList: json['districtList'] != null
          ? (json['districtList'] as List)
              .map((i) => District.fromJson(i))
              .toList()
          : null,
      lang: json['lang'],
      stateCode: json['stateCode'],
      stateName: json['stateName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateCode'] = this.stateCode;
    data['stateName'] = this.stateName;
    if (this.districtList != null) {
      data['districtList'] = this.districtList!.map((v) => v.toJson()).toList();
    }
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class District {
  List<City>? cityList;
  String? districtCode;
  String? districtName;
  List? lang;

  District({this.cityList, this.districtCode, this.districtName, this.lang});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      cityList: json['cityList'] != null
          ? (json['cityList'] as List).map((i) => City.fromJson(i)).toList()
          : null,
      districtCode: json['districtCode'],
      districtName: json['districtName'],
      lang: json['lang'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtCode'] = this.districtCode;
    data['districtName'] = this.districtName;
    if (this.cityList != null) {
      data['cityList'] = this.cityList!.map((v) => v.toJson()).toList();
    }
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class City {
  String? cityCode;
  String? cityName;
  List? lang;
  List<Village>? villageList;

  City({this.cityCode, this.cityName, this.lang, this.villageList});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityCode: json['cityCode'],
      cityName: json['cityName'],
      lang: json['lang'],
      villageList: json['villageList'] != null
          ? (json['villageList'] as List)
              .map((i) => Village.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityCode'] = this.cityCode;
    data['cityName'] = this.cityName;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    if (this.villageList != null) {
      data['villageList'] = this.villageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Village {
  List? lang;
  String? villageCode;
  String? villageName;

  Village({this.lang, this.villageCode, this.villageName});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      lang: json['lang'],
      villageCode: json['villageCode'],
      villageName: json['villageName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['villageCode'] = this.villageCode;
    data['villageName'] = this.villageName;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class Data3 {
  List<PcbpList>? pcbpList;

  Data3({this.pcbpList});

  factory Data3.fromJson(Map<String, dynamic> json) {
    return Data3(
      pcbpList: json['pcbpList'] != null
          ? (json['pcbpList'] as List).map((i) => PcbpList.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pcbpList != null) {
      data['countryList'] = this.pcbpList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PcbpList {
  String? dosage;
  String? cropVariety;
  String? chemicalName;
  String? cropCat;
  String? phiIn;
  String? crop;
  String? pid;
  String? uom;

  PcbpList(
      {this.dosage,
      this.cropVariety,
      this.chemicalName,
      this.cropCat,
      this.phiIn,
      this.crop,
      this.pid,
      this.uom});

  factory PcbpList.fromJson(Map<String, dynamic> json) {
    return PcbpList(
      dosage: json['dosage'],
      cropVariety: json['cropVariety'],
      chemicalName: json['chemicalName'],
      cropCat: json['cropCat'],
      phiIn: json['phiIn'],
      crop: json['crop'],
      pid: json['pid'],
      uom: json['uom'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dosage'] = this.dosage;
    data['cropVariety'] = this.cropVariety;
    data['chemicalName'] = this.chemicalName;
    data['cropCat'] = this.cropCat;
    data['phiIn'] = this.phiIn;
    data['crop'] = this.crop;
    data['pid'] = this.pid;
    data['uom'] = this.uom;

    return data;
  }
}

class Data8 {
  List<Cat>? catList;
  String? catRevNo;

  Data8({this.catList, this.catRevNo});

  factory Data8.fromJson(Map<String, dynamic> json) {
    return Data8(
      catList: json['catList'] != null
          ? (json['catList'] as List).map((i) => Cat.fromJson(i)).toList()
          : null,
      catRevNo: json['catRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catRevNo'] = this.catRevNo;
    if (this.catList != null) {
      data['catList'] = this.catList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cat {
  String? catId;
  String? catName;
  int? catType;
  List? lang;
  String? pCatId;
  int? seqNo;

  Cat(
      {this.catId,
      this.catName,
      this.catType,
      this.lang,
      this.pCatId,
      this.seqNo});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      catId: json['catId'],
      catName: json['catName'],
      catType: json['catType'],
      lang: json['lang'],
      pCatId: json['pCatId'],
      seqNo: json['seqNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['catName'] = this.catName;
    data['catType'] = this.catType;
    data['pCatId'] = this.pCatId;
    data['seqNo'] = this.seqNo;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class Data6 {
  String? procProdRevNo;
  List<Product>? products;

  Data6({this.procProdRevNo, this.products});

  factory Data6.fromJson(Map<String, dynamic> json) {
    return Data6(
      procProdRevNo: json['procProdRevNo'],
      products: json['products'] != null
          ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['procProdRevNo'] = this.procProdRevNo;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? ppCode;
  String? ppName;
  String? ppUnit;
  List<VrtLst>? vrtLst;

  Product({this.ppCode, this.ppName, this.ppUnit, this.vrtLst});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ppCode: json['ppCode'],
      ppName: json['ppName'],
      ppUnit: json['ppUnit'],
      vrtLst: json['vrtLst'] != null
          ? (json['vrtLst'] as List).map((i) => VrtLst.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppCode'] = this.ppCode;
    data['ppName'] = this.ppName;
    data['ppUnit'] = this.ppUnit;
    if (this.vrtLst != null) {
      data['vrtLst'] = this.vrtLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VrtLst {
  List<GrdLst>? grdLst;
  List? lang;
  String? ppVarCode;
  String? ppVarName;
  String? uom;
  //String? hsCode;

  VrtLst({this.grdLst, this.lang, this.ppVarCode, this.ppVarName, this.uom});

  factory VrtLst.fromJson(Map<String, dynamic> json) {
    return VrtLst(
      grdLst: json['grdLst'] != null
          ? (json['grdLst'] as List).map((i) => GrdLst.fromJson(i)).toList()
          : null,
      lang: json['lang'],
      ppVarCode: json['ppVarCode'],
      ppVarName: json['ppVarName'],
     uom: json['uom']
     // hsCode: json['hsCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppVarCode'] = this.ppVarCode;
    data['ppVarName'] = this.ppVarName;
    data['uom']=this.uom;
    if (this.grdLst != null) {
      data['grdLst'] = this.grdLst!.map((v) => v.toJson()).toList();
    }
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class GrdLst {
  List? lang;
  String? ppGraCode;
  String? ppGraName;
  String? ppGraPrice;
  String? estDays;
  String? cropCycle;
  String? hsCode;
  double? estAcre;

  GrdLst(
      {this.lang,
      this.ppGraCode,
      this.ppGraName,
      this.ppGraPrice,
      this.estDays,
      this.cropCycle,
      this.hsCode,
      this.estAcre});

  factory GrdLst.fromJson(Map<String, dynamic> json) {
    return GrdLst(
      lang: json['lang'],
      ppGraCode: json['ppGraCode'],
      ppGraName: json['ppGraName'],
      ppGraPrice: json['ppGraPrice'],
      estDays: json['estDays'],
      cropCycle: json['cropCycle'],
      hsCode: json['hsCode'],
      estAcre: json['estAcre'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppGraCode'] = this.ppGraCode;
    data['ppGraName'] = this.ppGraName;
    data['ppGraPrice'] = this.ppGraPrice;
    data['estDays'] = this.estDays;
    data['cropCycle'] = this.cropCycle;
    data['hsCode'] = this.hsCode;
    data['estAcre'] = this.estAcre;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class Data0 {
  String? prodRevNo;
  List? products;

  Data0({this.prodRevNo, this.products});

  factory Data0.fromJson(Map<String, dynamic> json) {
    return Data0(
      prodRevNo: json['prodRevNo'],
      products: json['products'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodRevNo'] = this.prodRevNo;
    if (this.products != null) {
      data['products'] = this.products;
    }
    return data;
  }
}

class Data9 {
  List<coOperative>? coOperatives;
  String? coRevNo;
  // List<Samithi>? samithis;

  Data9({this.coOperatives, this.coRevNo});

  factory Data9.fromJson(Map<String, dynamic> json) {
    return Data9(
      coRevNo: json['coRevNo'],
      coOperatives: json['coOperatives'] != null
          ? (json['coOperatives'] as List)
              .map((i) => coOperative.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coRevNo'] = this.coRevNo;
    if (this.coOperatives != null) {
      data['coOperatives'] = this.coOperatives!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class coOperative {
  String? coCode;
  String? coName;
  String? copTyp;

  coOperative({this.coCode, this.coName, this.copTyp});

  factory coOperative.fromJson(Map<String, dynamic> json) {
    return coOperative(
      coCode: json['coCode'],
      coName: json['coName'],
      copTyp: json['copTyp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coCode'] = this.coCode;
    data['coName'] = this.coName;
    data['copTyp'] = this.copTyp;
    return data;
  }
}

class Data10 {
  List<Stock>? stocks;
  String? vwsRevNo;

  Data10({this.stocks, this.vwsRevNo});

  factory Data10.fromJson(Map<String, dynamic> json) {
    return Data10(
      vwsRevNo: json['vwsRevNo'],
      stocks: json['stocks'] != null
          ? (json['stocks'] as List).map((i) => Stock.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vwsRevNo'] = this.vwsRevNo;
    if (this.stocks != null) {
      data['stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stock {
  String? batchNo;
  String? wCode;
  String? productName;
  String? sortedWt;
  String? blockId;
  String? farmerId;
  String? lastHarDate;
  String? wName;
  String? blockname;
  String? variety;
  String? pCode;
  String? varietyName;
  String? grossWt;
  String? lossWt;
  String? farmCode;
  String? plantingId;
  String? stType;
  String? farmName;
  String? farmerName;
  String? state_name;
  String? state;
  String? harvestWt;
  String? QRBatchNo;
  String? pkBatchNo;
  String? ptTransferFromCode;
  String? ptDate;
  String? ptTransferToCode;
  String? ptTruckNo;
  String? ptDriverName;
  String? ptDriverLicenseNo;
  String? ptTransferToName;
  String? ptTransferFromName;
  String? bbDate;

  Stock({
    this.batchNo,
    this.wCode,
    this.productName,
    this.sortedWt,
    this.blockId,
    this.farmerId,
    this.lastHarDate,
    this.wName,
    this.blockname,
    this.variety,
    this.pCode,
    this.varietyName,
    this.grossWt,
    this.lossWt,
    this.farmCode,
    this.plantingId,
    this.stType,
    this.farmName,
    this.farmerName,
    this.state_name,
    this.state,
    this.harvestWt,
    this.QRBatchNo,
    this.pkBatchNo,
    this.ptDate,
    this.ptTransferFromCode,
    this.ptTransferToCode,
    this.ptTruckNo,
    this.ptDriverName,
    this.ptDriverLicenseNo,
    this.ptTransferToName,
    this.ptTransferFromName,
    this.bbDate,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      batchNo: json['batchNo'],
      wCode: json['wCode'],
      productName: json['productName'],
      sortedWt: json['sortedWt'],
      blockId: json['blockId'],
      farmerId: json['farmerId'],
      lastHarDate: json['lastHarDate'],
      wName: json['wName'],
      blockname: json['blockname'],
      variety: json['variety'],
      pCode: json['pCode'],
      varietyName: json['varietyName'],
      grossWt: json['grossWt'],
      lossWt: json['lossWt'],
      farmCode: json['farmCode'],
      plantingId: json['plantingId'],
      stType: json['stType'],
      farmName: json['farmName'],
      farmerName: json['farmerName'],
      state_name: json['state_name'],
      state: json['state'],
      harvestWt: json['harvestWt'],
      QRBatchNo: json['QRBatchNo'],
      pkBatchNo: json['pkBatchNo'],
      ptDate: json['ptDate'],
      ptTransferFromCode: json['ptTransferFromCode'],
      ptTransferToCode: json['ptTransferToCode'],
      ptTruckNo: json['ptTruckNo'],
      ptDriverName: json['ptDriverName'],
      ptDriverLicenseNo: json['ptDriverLicenseNo'],
      ptTransferToName: json['ptTransferToName'],
      ptTransferFromName: json['ptTransferFromName'],
      bbDate: json['bbDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchNo'] = this.batchNo;
    data['wCode'] = this.wCode;
    data['productName'] = this.productName;
    data['sortedWt'] = this.sortedWt;
    data['blockId'] = this.blockId;
    data['farmerId'] = this.farmerId;
    data['lastHarDate'] = this.lastHarDate;
    data['wName'] = this.wName;
    data['blockname'] = this.blockname;
    data['variety'] = this.variety;
    data['pCode'] = this.pCode;
    data['varietyName'] = this.varietyName;
    data['grossWt'] = this.grossWt;
    data['lossWt'] = this.lossWt;
    data['plantingId'] = this.plantingId;
    data['stType'] = this.stType;
    data['farmName'] = this.farmName;
    data['farmerName'] = this.farmerName;
    data['state_name'] = this.state_name;
    data['state'] = this.state;
    data['harvestWt'] = this.harvestWt;
    data['qrUniqId'] = this.QRBatchNo;
    data['resBatNo'] = this.pkBatchNo;
    data['transferFrom'] = this.ptTransferFromCode;
    data['txnDate'] = this.ptDate;
    data['transferTo'] = this.ptTransferToCode;
    data['truck'] = this.ptTruckNo;
    data['driver'] = this.ptDriverName;
    data['licenseNo'] = this.ptDriverLicenseNo;
    data['transferToName'] = this.ptTransferToName;
    data['transferFromName'] = this.ptTransferToName;
    data['bbDate'] = this.bbDate;

    return data;
  }
}
class Data11 {
  List<BuyerList>? byrList;
  String? byrRevNo;

  Data11({this.byrList, this.byrRevNo});

  factory Data11.fromJson(Map<String, dynamic> json) {
    return Data11(
      byrRevNo: json['byrRevNo'],
      byrList: json['byrList'] != null
          ? (json['byrList'] as List).map((i) => BuyerList.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['byrRevNo'] = this.byrRevNo;
    if (this.byrList != null) {
      data['byrList'] = this.byrList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuyerList {
  String? byrId;
  String? byrName;
  String? buyersCountry;
  String? buyersCountryCode;
  BuyerList({
    this.byrId,
    this.byrName,
    this.buyersCountry,
    this.buyersCountryCode,
  });

  factory BuyerList.fromJson(Map<String, dynamic> json) {
    return BuyerList(
      byrId: json['byrId'],
      byrName: json['byrName'],
      buyersCountry: json['buyrCountry'],
      buyersCountryCode: json['buyrCountryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['byrId'] = this.byrId;
    data['byrName'] = this.byrName;
    data['buyrCountry'] = this.buyersCountry;
    data['buyrCountryCode'] = this.buyersCountryCode;
    return data;
  }
}

class AgentLogin {
  String? currentSeasonCode;
  int? fCropRevNo;
  int? farmRevNo;
  int? farmerRevNo;
  int? fsRevNo;

  AgentLogin(
      {this.currentSeasonCode,
      this.fCropRevNo,
      this.farmRevNo,
      this.farmerRevNo,
      this.fsRevNo});

  factory AgentLogin.fromJson(Map<String, dynamic> json) {
    return AgentLogin(
      currentSeasonCode: json['currentSeasonCode'],
      fCropRevNo: json['fCropRevNo'],
      farmRevNo: json['farmRevNo'],
      farmerRevNo: json['farmerRevNo'],
      fsRevNo: json['fsRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentSeasonCode'] = this.currentSeasonCode;
    data['fCropRevNo'] = this.fCropRevNo;
    data['farmRevNo'] = this.farmRevNo;
    data['farmerRevNo'] = this.farmerRevNo;
    data['fsRevNo'] = this.fsRevNo;
    return data;
  }
}
