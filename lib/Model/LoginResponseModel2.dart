class LoginResponse {
  Response? response;

  LoginResponse({this.response});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
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
  Data6? data6;

  Body({this.agentLogin, this.data0, this.data1, this.data2, this.data6});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      agentLogin: json['agentLogin'] != null
          ? AgentLogin.fromJson(json['agentLogin'])
          : null,
      data0: json['data0'] != null ? Data0.fromJson(json['data0']) : null,
      data1: json['data1'] != null ? Data1.fromJson(json['data1']) : null,
      data2: json['data2'] != null ? Data2.fromJson(json['data2']) : null,
      data6: json['data6'] != null ? Data6.fromJson(json['data6']) : null,
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
    if (this.data6 != null) {
      data['data6'] = this.data6!.toJson();
    }
    return data;
  }
}

class Data0 {
  String? prodRevNo;
  List<Object>? products;

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

class AgentLogin {
  String? acMod;
  String? agentName;
  String? agentType;
  String? areaType;
  String? bal;
  String? branchId;
  String? byrRevNo;
  String? catRevNo;
  String? clientIdSeq;
  int? clientRevNo;
  String? coRevNo;
  String? cropCalandar;
  String? currency;
  String? currentSeasonCode;
  String? deviceId;
  String? digitalSign;
  String? dispDtFormat;
  String? displayTSFormat;
  String? distImgAvil;
  String? dynLatestRevNo;
  String? eFrom;
  int? fCropRevNo;
  int? farmRevNo;
  int? farmerRevNo;
  String? fobRevNo;
  int? fsRevNo;
  String? ftpPath;
  String? ftpPw;
  String? ftpUrl;
  String? ftpUs;
  String? gFReq;
  String? gRad;
  String? iRateA;
  String? isAExF;
  String? isBatchAvail;
  String? isBuyer;
  String? isGeneric;
  String? isGrampnchayat;
  String? isQrs;
  String? isTracker;
  String? lRevNo;
  String? parentId;
  String? plannerRevNo;
  String? preIR;
  String? procProdRevNo;
  String? prodRevNo;
  String? rApkV;
  String? rConfV;
  String? rDbV;
  String? roi;
  String? samithis;
  String? seasonRevNo;
  String? servPointId;
  String? servPointName;
  String? supRevNo;
  String? syncTS;
  String? tare;
  String? tcRevNo;
  String? tccRevNo;
  String? vwsRevNo;
  String? warehouseId;
  String? warehouseSeason;
  String? wsRevNo;
  var packHouseId;
  String? packHouseName;
  String? expLic;
  String? packHouseCode;
  String? expName;
  var expCode;
  var ag_days;
  String? p_age;
  String? p_rem;
  String? es_date;
  String? variety;
  String? gCode;
  String? fLogin;
  String? expDate;
  String? expStatus;
  String? shipmentUrl;

  AgentLogin(
      {this.acMod,
      this.agentName,
      this.agentType,
      this.areaType,
      this.bal,
      this.branchId,
      this.byrRevNo,
      this.catRevNo,
      this.clientIdSeq,
      this.clientRevNo,
      this.coRevNo,
      this.cropCalandar,
      this.currency,
      this.currentSeasonCode,
      this.deviceId,
      this.digitalSign,
      this.dispDtFormat,
      this.displayTSFormat,
      this.distImgAvil,
      this.dynLatestRevNo,
      this.eFrom,
      this.fCropRevNo,
      this.farmRevNo,
      this.farmerRevNo,
      this.fobRevNo,
      this.fsRevNo,
      this.ftpPath,
      this.ftpPw,
      this.ftpUrl,
      this.ftpUs,
      this.gFReq,
      this.gRad,
      this.iRateA,
      this.isAExF,
      this.isBatchAvail,
      this.isBuyer,
      this.isGeneric,
      this.isGrampnchayat,
      this.isQrs,
      this.isTracker,
      this.lRevNo,
      this.parentId,
      this.plannerRevNo,
      this.preIR,
      this.procProdRevNo,
      this.prodRevNo,
      this.rApkV,
      this.rConfV,
      this.rDbV,
      this.roi,
      this.samithis,
      this.seasonRevNo,
      this.servPointId,
      this.servPointName,
      this.supRevNo,
      this.syncTS,
      this.tare,
      this.tcRevNo,
      this.tccRevNo,
      this.vwsRevNo,
      this.warehouseId,
      this.warehouseSeason,
      this.wsRevNo,
      this.packHouseId,
      this.packHouseName,
      this.expLic,
      this.packHouseCode,
      this.expCode,
      this.expName,
      this.ag_days,
      this.p_age,
      this.p_rem,
      this.variety,
      this.gCode,
      this.fLogin,
      this.expDate,
      this.expStatus,
      this.shipmentUrl});

  factory AgentLogin.fromJson(Map<String, dynamic> json) {
    return AgentLogin(
      acMod: json['acMod'],
      agentName: json['agentName'],
      agentType: json['agentType'],
      areaType: json['areaType'],
      bal: json['bal'],
      branchId: json['branchId'],
      byrRevNo: json['byrRevNo'],
      catRevNo: json['catRevNo'],
      clientIdSeq: json['clientIdSeq'],
      clientRevNo: json['clientRevNo'],
      coRevNo: json['coRevNo'],
      cropCalandar: json['cropCalandar'],
      currency: json['currency'],
      currentSeasonCode: json['currentSeasonCode'],
      deviceId: json['deviceId'],
      digitalSign: json['digitalSign'],
      dispDtFormat: json['dispDtFormat'],
      displayTSFormat: json['displayTSFormat'],
      distImgAvil: json['distImgAvil'],
      dynLatestRevNo: json['dynLatestRevNo'],
      eFrom: json['eFrom'],
      fCropRevNo: json['fCropRevNo'],
      farmRevNo: json['farmRevNo'],
      farmerRevNo: json['farmerRevNo'],
      fobRevNo: json['fobRevNo'],
      fsRevNo: json['fsRevNo'],
      ftpPath: json['ftpPath'],
      ftpPw: json['ftpPw'],
      ftpUrl: json['ftpUrl'],
      ftpUs: json['ftpUs'],
      gFReq: json['gFReq'],
      gRad: json['gRad'],
      iRateA: json['iRateA'],
      isAExF: json['isAExF'],
      isBatchAvail: json['isBatchAvail'],
      isBuyer: json['isBuyer'],
      isGeneric: json['isGeneric'],
      isGrampnchayat: json['isGrampnchayat'],
      isQrs: json['isQrs'],
      isTracker: json['isTracker'],
      lRevNo: json['lRevNo'],
      parentId: json['parentId'],
      plannerRevNo: json['plannerRevNo'],
      preIR: json['preIR'],
      procProdRevNo: json['procProdRevNo'],
      prodRevNo: json['prodRevNo'],
      rApkV: json['rApkV'],
      rConfV: json['rConfV'],
      rDbV: json['rDbV'],
      roi: json['roi'],
      samithis: json['samithis'],
      seasonRevNo: json['seasonRevNo'],
      servPointId: json['servPointId'],
      servPointName: json['servPointName'],
      supRevNo: json['supRevNo'],
      syncTS: json['syncTS'],
      tare: json['tare'],
      tcRevNo: json['tcRevNo'],
      tccRevNo: json['tccRevNo'],
      vwsRevNo: json['vwsRevNo'],
      warehouseId: json['warehouseId'],
      warehouseSeason: json['warehouseSeason'],
      wsRevNo: json['wsRevNo'],
      packHouseId: json['packHouseId'],
      packHouseName: json['packHouseName'],
      expLic: json['expLic'],
      packHouseCode: json['packHouseCode'],
      expCode: json['expCode'],
      expName: json['expName'],
      ag_days: json['ag_days'],
      p_age: json['p_age'],
      p_rem: json['p_rem'],
      variety: json['variety'],
      gCode: json['gCode'],
      fLogin: json['fLogin'],
      expDate: json['expDate'],
      expStatus: json['expStatus'],
      shipmentUrl: json['shipmentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acMod'] = this.acMod;
    data['agentName'] = this.agentName;
    data['agentType'] = this.agentType;
    data['areaType'] = this.areaType;
    data['bal'] = this.bal;
    data['branchId'] = this.branchId;
    data['byrRevNo'] = this.byrRevNo;
    data['catRevNo'] = this.catRevNo;
    data['clientIdSeq'] = this.clientIdSeq;
    data['clientRevNo'] = this.clientRevNo;
    data['coRevNo'] = this.coRevNo;
    data['cropCalandar'] = this.cropCalandar;
    data['currency'] = this.currency;
    data['currentSeasonCode'] = this.currentSeasonCode;
    data['deviceId'] = this.deviceId;
    data['digitalSign'] = this.digitalSign;
    data['dispDtFormat'] = this.dispDtFormat;
    data['displayTSFormat'] = this.displayTSFormat;
    data['distImgAvil'] = this.distImgAvil;
    data['dynLatestRevNo'] = this.dynLatestRevNo;
    data['eFrom'] = this.eFrom;
    data['fCropRevNo'] = this.fCropRevNo;
    data['farmRevNo'] = this.farmRevNo;
    data['farmerRevNo'] = this.farmerRevNo;
    data['fobRevNo'] = this.fobRevNo;
    data['fsRevNo'] = this.fsRevNo;
    data['ftpPath'] = this.ftpPath;
    data['ftpPw'] = this.ftpPw;
    data['ftpUrl'] = this.ftpUrl;
    data['ftpUs'] = this.ftpUs;
    data['gFReq'] = this.gFReq;
    data['gRad'] = this.gRad;
    data['iRateA'] = this.iRateA;
    data['isAExF'] = this.isAExF;
    data['isBatchAvail'] = this.isBatchAvail;
    data['isBuyer'] = this.isBuyer;
    data['isGeneric'] = this.isGeneric;
    data['isGrampnchayat'] = this.isGrampnchayat;
    data['isQrs'] = this.isQrs;
    data['isTracker'] = this.isTracker;
    data['lRevNo'] = this.lRevNo;
    data['parentId'] = this.parentId;
    data['plannerRevNo'] = this.plannerRevNo;
    data['preIR'] = this.preIR;
    data['procProdRevNo'] = this.procProdRevNo;
    data['prodRevNo'] = this.prodRevNo;
    data['rApkV'] = this.rApkV;
    data['rConfV'] = this.rConfV;
    data['rDbV'] = this.rDbV;
    data['roi'] = this.roi;
    data['samithis'] = this.samithis;
    data['seasonRevNo'] = this.seasonRevNo;
    data['servPointId'] = this.servPointId;
    data['servPointName'] = this.servPointName;
    data['supRevNo'] = this.supRevNo;
    data['syncTS'] = this.syncTS;
    data['tare'] = this.tare;
    data['tcRevNo'] = this.tcRevNo;
    data['tccRevNo'] = this.tccRevNo;
    data['vwsRevNo'] = this.vwsRevNo;
    data['warehouseId'] = this.warehouseId;
    data['warehouseSeason'] = this.warehouseSeason;
    data['wsRevNo'] = this.wsRevNo;
    data['packHouseId'] = this.packHouseId;
    data['packHouseName'] = this.packHouseName;
    data['expLic'] = this.expLic;
    data['packHouseCode'] = this.packHouseCode;
    data['exporterID'] = this.expCode;
    data['exporterName'] = this.expName;
    data['ag_days'] = this.ag_days;
    data['p_age'] = this.p_age;
    data['p_rem'] = this.p_rem;
    data['variety'] = this.variety;
    data['gCode'] = this.gCode;
    data['fLogin'] = this.fLogin;
    data['expDate'] = this.expDate;
    data['expStatus'] = this.expStatus;
    data['effectiveFrom'] = this.shipmentUrl;
    return data;
  }
}

class Data1 {
  String? seasonRevNo;
  List<Object>? seasons;

  Data1({this.seasonRevNo, this.seasons});

  factory Data1.fromJson(Map<String, dynamic> json) {
    return Data1(
      seasonRevNo: json['seasonRevNo'],
      seasons: json['seasons'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasonRevNo'] = this.seasonRevNo;
    if (this.seasons != null) {
      data['seasons'] = this.seasons;
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
  List<Object>? lang;
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
  List<Object>? districtList;
  List<Object>? lang;
  String? stateCode;
  String? stateName;

  States({this.districtList, this.lang, this.stateCode, this.stateName});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      districtList: json['districtList'],
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
      data['districtList'] = this.districtList;
    }
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    return data;
  }
}

class Data6 {
  List<Object>? grdLst;
  String? procProdRevNo;
  List<Object>? products;
  List<Object>? vrtLst;

  Data6({this.grdLst, this.procProdRevNo, this.products, this.vrtLst});

  factory Data6.fromJson(Map<String, dynamic> json) {
    return Data6(
      grdLst: json['grdLst'],
      procProdRevNo: json['procProdRevNo'],
      products: json['products'],
      vrtLst: json['vrtLst'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['procProdRevNo'] = this.procProdRevNo;
    if (this.grdLst != null) {
      data['grdLst'] = this.grdLst;
    }
    if (this.products != null) {
      data['products'] = this.products;
    }
    if (this.vrtLst != null) {
      data['vrtLst'] = this.vrtLst;
    }
    return data;
  }
}
