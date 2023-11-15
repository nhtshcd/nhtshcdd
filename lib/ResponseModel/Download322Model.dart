import 'Stock.dart';

class Download322 {
  Response? response;

  Download322({this.response});

  factory Download322.fromJson(Map<String, dynamic> json) {
    return Download322(
      response: json['Response'] != null ? Response.fromJson(json['Response']) : null,
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
  Data3? data3;
  Data10? data10;
  Data12? data12;
  Data16? data16;
  Data17? data17;
  Data2? data2;
  Data5? data5;
  Data6? data6;
  Data7? data7;
  Data8? data8;
  Data9? data9;

  Body({this.agentLogin, this.data0, this.data1, this.data3, this.data10, this.data12, this.data16, this.data17, this.data2, this.data5, this.data6, this.data7, this.data8, this.data9});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      agentLogin: json['agentLogin'] != null ? AgentLogin.fromJson(json['agentLogin']) : null,
      data0: json['data0'] != null ? Data0.fromJson(json['data0']) : null,
      data1: json['data1'] != null ? Data1.fromJson(json['data1']) : null,
      data3: json['data3'] != null ? Data3.fromJson(json['data3']) : null,
      data10: json['data10'] != null ? Data10.fromJson(json['data10']) : null,
      data12: json['data12'] != null ? Data12.fromJson(json['data12']) : null,
      data16: json['data16'] != null ? Data16.fromJson(json['data16']) : null,
      data17: json['data17'] != null ? Data17.fromJson(json['data17']) : null,
      data2: json['data2'] != null ? Data2.fromJson(json['data2']) : null,
      data5: json['data5'] != null ? Data5.fromJson(json['data5']) : null,
      data6: json['data6'] != null ? Data6.fromJson(json['data6']) : null,
      data7: json['data7'] != null ? Data7.fromJson(json['data7']) : null,
      data8: json['data8'] != null ? Data8.fromJson(json['data8']) : null,
      data9: json['data9'] != null ? Data9.fromJson(json['data9']) : null,
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
    if (this.data3 != null) {
      data['data3'] = this.data3!.toJson();
    }
    if (this.data10 != null) {
      data['data10'] = this.data10!.toJson();
    }
    if (this.data12 != null) {
      data['data12'] = this.data12!.toJson();
    }

    if (this.data16 != null) {
      data['data16'] = this.data16!.toJson();
    }
    if (this.data17 != null) {
      data['data17'] = this.data17!.toJson();
    }
    if (this.data2 != null) {
      data['data2'] = this.data2!.toJson();
    }

    if (this.data5 != null) {
      data['data5'] = this.data5!.toJson();
    }
    if (this.data6 != null) {
      data['data6'] = this.data6!.toJson();
    }
    if (this.data7 != null) {
      data['data7'] = this.data7!.toJson();
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

class AgentLogin {
  String? currentSeasonCode;
  int? fCropRevNo;
  int? farmRevNo;
  int? farmerRevNo;
  int? fsRevNo;
  List<Samithi>? samithis;

  AgentLogin({this.currentSeasonCode, this.fCropRevNo, this.farmRevNo, this.farmerRevNo, this.fsRevNo, this.samithis});

  factory AgentLogin.fromJson(Map<String, dynamic> json) {
    return AgentLogin(
      currentSeasonCode: json['currentSeasonCode'],
      fCropRevNo: json['fCropRevNo'],
      farmRevNo: json['farmRevNo'],
      farmerRevNo: json['farmerRevNo'],
      fsRevNo: json['fsRevNo'],
      samithis: json['samithis'] != null ? (json['samithis'] as List).map((i) => Samithi.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentSeasonCode'] = this.currentSeasonCode;
    data['fCropRevNo'] = this.fCropRevNo;
    data['farmRevNo'] = this.farmRevNo;
    data['farmerRevNo'] = this.farmerRevNo;
    data['fsRevNo'] = this.fsRevNo;
    if (this.samithis != null) {
      data['samithis'] = this.samithis!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Samithi {
  String? samCode;

  Samithi({this.samCode});

  factory Samithi.fromJson(Map<String, dynamic> json) {
    return Samithi(
      samCode: json['samCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['samCode'] = this.samCode;
    return data;
  }
}

class Data3 {
  List<Stock>? stocks;
  String? wsRevNo;

  Data3({this.stocks, this.wsRevNo});

  factory Data3.fromJson(Map<String, dynamic> json) {
    return Data3(
      stocks: json['stocks'] != null ? (json['stocks'] as List).map((i) => Stock.fromJson(i)).toList() : null,
      wsRevNo: json['wsRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wsRevNo'] = this.wsRevNo;
    if (this.stocks != null) {
      data['stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Data7 {
  List<Byr>? byrList;
  String? byrRevNo;

  Data7({this.byrList, this.byrRevNo});

  factory Data7.fromJson(Map<String, dynamic> json) {
    return Data7(
      byrList: json['byrList'] != null ? (json['byrList'] as List).map((i) => Byr.fromJson(i)).toList() : null,
      byrRevNo: json['byrRevNo'],
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

class Byr {
  String? byrId;
  String? byrName;

  Byr({this.byrId, this.byrName});

  factory Byr.fromJson(Map<String, dynamic> json) {
    return Byr(
      byrId: json['byrId'],
      byrName: json['byrName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['byrId'] = this.byrId;
    data['byrName'] = this.byrName;
    return data;
  }
}

class Data10 {
  String? supRevNo;
  List<Object>? supTypLst;

  Data10({this.supRevNo, this.supTypLst});

  factory Data10.fromJson(Map<String, dynamic> json) {
    return Data10(
      supRevNo: json['supRevNo'],
      supTypLst: json['supTypLst'] ,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supRevNo'] = this.supRevNo;
    if (this.supTypLst != null) {
      data['supTypLst'] = this.supTypLst;
    }
    return data;
  }
}

class Data5 {
  String? fobRevNo;
  List<FrBal>? frBalList;

  Data5({this.fobRevNo, this.frBalList});

  factory Data5.fromJson(Map<String, dynamic> json) {
    return Data5(
      fobRevNo: json['fobRevNo'],
      frBalList: json['frBalList'] != null ? (json['frBalList'] as List).map((i) => FrBal.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fobRevNo'] = this.fobRevNo;
    if (this.frBalList != null) {
      data['frBalList'] = this.frBalList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FrBal {
  String? cumInt;
  String? farmerId;
  String? farmerName;
  String? osBal;
  String? pAmt;
  String? roi;

  FrBal({this.cumInt, this.farmerId, this.farmerName, this.osBal, this.pAmt, this.roi});

  factory FrBal.fromJson(Map<String, dynamic> json) {
    return FrBal(
      cumInt: json['cumInt'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      osBal: json['osBal'],
      pAmt: json['pAmt'],
      roi: json['roi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cumInt'] = this.cumInt;
    data['farmerId'] = this.farmerId;
    data['farmerName'] = this.farmerName;
    data['osBal'] = this.osBal;
    data['pAmt'] = this.pAmt;
    data['roi'] = this.roi;
    return data;
  }
}

class Data2 {
  List<Country>? countryList;
  String? lRevNo;

  Data2({this.countryList, this.lRevNo});

  factory Data2.fromJson(Map<String, dynamic> json) {
    return Data2(
      countryList: json['countryList'] != null ? (json['countryList'] as List).map((i) => Country.fromJson(i)).toList() : null,
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
      lang: json['lang'] ,
      stateList: json['stateList'] != null ? (json['stateList'] as List).map((i) => States.fromJson(i)).toList() : null,
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
  List<Object>? lang;
  String? stateCode;
  String? stateName;

  States({this.districtList, this.lang, this.stateCode, this.stateName});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      districtList: json['districtList'] != null ? (json['districtList'] as List).map((i) => District.fromJson(i)).toList() : null,
      lang: json['lang'] ,
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
      data['lang'] ;
    }
    return data;
  }
}

class District {
  List<City>? cityList;
  String? districtCode;
  String? districtName;
  List<Object>? lang;

  District({this.cityList, this.districtCode, this.districtName, this.lang});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      cityList: json['cityList'] != null ? (json['cityList'] as List).map((i) => City.fromJson(i)).toList() : null,
      districtCode: json['districtCode'],
      districtName: json['districtName'],
      lang: json['lang'] ,
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
  List<Lang>? lang;
  List<Village>? villageList;

  City({this.cityCode, this.cityName, this.lang, this.villageList});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityCode: json['cityCode'],
      cityName: json['cityName'],
      lang: json['lang'] != null ? (json['lang'] as List).map((i) => Lang.fromJson(i)).toList() : null,
      villageList: json['villageList'] != null ? (json['villageList'] as List).map((i) => Village.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityCode'] = this.cityCode;
    data['cityName'] = this.cityName;
    if (this.lang != null) {
      data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    }
    if (this.villageList != null) {
      data['villageList'] = this.villageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Panchayat {
  List<Object>? lang;
  String? panCode;
  String? panName;
  List<Village>? villageList;

  Panchayat({this.lang, this.panCode, this.panName, this.villageList});

  factory Panchayat.fromJson(Map<String, dynamic> json) {
    return Panchayat(
      lang: json['lang'],
      panCode: json['panCode'],
      panName: json['panName'],
      villageList: json['villageList'] != null ? (json['villageList'] as List).map((i) => Village.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panCode'] = this.panCode;
    data['panName'] = this.panName;
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
  List<LangX>? lang;
  String? villageCode;
  String? villageName;

  Village({this.lang, this.villageCode, this.villageName});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      lang: json['lang'] != null ? (json['lang'] as List).map((i) => LangX.fromJson(i)).toList() : null,
      villageCode: json['villageCode'],
      villageName: json['villageName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['villageCode'] = this.villageCode;
    data['villageName'] = this.villageName;
    if (this.lang != null) {
      data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lang {
  String? langCode;
  String? langValue;

  Lang({this.langCode, this.langValue});

  factory Lang.fromJson(Map<String, dynamic> json) {
    return Lang(
      langCode: json['langCode'],
      langValue: json['langValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['langCode'] = this.langCode;
    data['langValue'] = this.langValue;
    return data;
  }
}

class LangX {
  String? langCode;
  String? langValue;

  LangX({this.langCode, this.langValue});

  factory LangX.fromJson(Map<String, dynamic> json) {
    return LangX(
      langCode: json['langCode'],
      langValue: json['langValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['langCode'] = this.langCode;
    data['langValue'] = this.langValue;
    return data;
  }
}

class Data8 {
  List<Cat>? catList;
  String? catRevNo;

  Data8({this.catList, this.catRevNo});

  factory Data8.fromJson(Map<String, dynamic> json) {
    return Data8(
      catList: json['catList'] != null ? (json['catList'] as List).map((i) => Cat.fromJson(i)).toList() : null,
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
  List<LangXXX>? lang;
  int? seqNo;

  Cat({this.catId, this.catName, this.catType, this.lang, this.seqNo});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      catId: json['catId'],
      catName: json['catName'],
      catType: json['catType'],
      lang: json['lang'] != null ? (json['lang'] as List).map((i) => LangXXX.fromJson(i)).toList() : null,
      seqNo: json['seqNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['catName'] = this.catName;
    data['catType'] = this.catType;
    data['seqNo'] = this.seqNo;
    if (this.lang != null) {
      data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LangXX {
  String? langCode;
  String? langValue;

  LangXX({this.langCode, this.langValue});

  factory LangXX.fromJson(Map<String, dynamic> json) {
    return LangXX(
      langCode: json['langCode'],
      langValue: json['langValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['langCode'] = this.langCode;
    data['langValue'] = this.langValue;
    return data;
  }
}

class Data0 {
  String? prodRevNo;
  List<Product>? products;

  Data0({this.prodRevNo, this.products});

  factory Data0.fromJson(Map<String, dynamic> json) {
    return Data0(
      prodRevNo: json['prodRevNo'],
      products: json['products'] != null ? (json['products'] as List).map((i) => Product.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodRevNo'] = this.prodRevNo;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? categoryCode;
  String? categoryName;
  String? ingredient;
  List<Object>? lang;
  List<Object>? langCat;
  String? manufacture;
  String? manufactureId;
  String? price;
  String? productCode;
  String? productName;
  String? unit;

  Product({this.categoryCode,this.categoryName, this.ingredient, this.lang, this.langCat, this.manufacture, this.manufactureId, this.price, this.productCode, this.productName, this.unit});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      categoryCode: json['categoryCode'],
      categoryName: json['categoryName'],
      ingredient: json['ingredient'],
      lang: json['lang'],
      langCat: json['langCat'] ,
      manufacture: json['manufacture'],
      manufactureId: json['manufactureId'],
      price: json['price'],
      productCode: json['productCode'],
      productName: json['productName'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['ingredient'] = this.ingredient;
    data['manufacture'] = this.manufacture;
    data['manufactureId'] = this.manufactureId;
    data['price'] = this.price;
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['unit'] = this.unit;
    if (this.lang != null) {
      data['lang'] = this.lang;
    }
    if (this.langCat != null) {
      data['langCat'] = this.langCat;
    }
    return data;
  }
}

class Data6 {
  String? procProdRevNo;
  List<ProductX>? products;

  Data6({this.procProdRevNo, this.products});

  factory Data6.fromJson(Map<String, dynamic> json) {
    return Data6(
      procProdRevNo: json['procProdRevNo'],
      products: json['products'] != null ? (json['products'] as List).map((i) => ProductX.fromJson(i)).toList() : null,
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

class ProductX {
  String? crpType;
  List<Object>? lang;
  String? msp;
  String? pmsp;
  String? ppCode;
  String? ppName;
  String? ppUnit;
  List<VrtLst>? vrtLst;

  ProductX({this.crpType, this.lang, this.msp, this.pmsp, this.ppCode, this.ppName, this.ppUnit, this.vrtLst});

  factory ProductX.fromJson(Map<String, dynamic> json) {
    return ProductX(
      crpType: json['crpType'],
      lang: json['lang'],
      msp: json['msp'],
      pmsp: json['pmsp'],
      ppCode: json['ppCode'],
      ppName: json['ppName'],
      ppUnit: json['ppUnit'],
      vrtLst: json['vrtLst'] != null ? (json['vrtLst'] as List).map((i) => VrtLst.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crpType'] = this.crpType;
    data['msp'] = this.msp;
    data['pmsp'] = this.pmsp;
    data['ppCode'] = this.ppCode;
    data['ppName'] = this.ppName;
    data['ppUnit'] = this.ppUnit;
    if (this.lang != null) {
      data['lang'];
    }
    if (this.vrtLst != null) {
      data['vrtLst'] = this.vrtLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VrtLst {
  List<CalandarLst>? calandarLst;
  String? estDays;
  List<GrdLst>? grdLst;
  List<LangXX>? lang;
  String? ppVarCode;
  String? ppVarName;

  VrtLst({this.calandarLst, this.estDays, this.grdLst, this.lang, this.ppVarCode, this.ppVarName});

  factory VrtLst.fromJson(Map<String, dynamic> json) {
    return VrtLst(
      calandarLst: json['calandarLst'] != null ? (json['calandarLst'] as List).map((i) => CalandarLst.fromJson(i)).toList() : null,
      estDays: json['estDays'],
      grdLst: json['grdLst'] != null ? (json['grdLst'] as List).map((i) => GrdLst.fromJson(i)).toList() : null,
      lang: json['lang'] != null ? (json['lang'] as List).map((i) => LangXX.fromJson(i)).toList() : null,
      ppVarCode: json['ppVarCode'],
      ppVarName: json['ppVarName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estDays'] = this.estDays;
    data['ppVarCode'] = this.ppVarCode;
    data['ppVarName'] = this.ppVarName;
    if (this.calandarLst != null) {
      data['calandarLst'] = this.calandarLst!.map((v) => v.toJson()).toList();
    }
    if (this.grdLst != null) {
      data['grdLst'] = this.grdLst!.map((v) => v.toJson()).toList();
    }
    if (this.lang != null) {
      data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LangXXX {
  String? langCode;
  String? langValue;

  LangXXX({this.langCode, this.langValue});

  factory LangXXX.fromJson(Map<String, dynamic> json) {
    return LangXXX(
      langCode: json['langCode'],
      langValue: json['langValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['langCode'] = this.langCode;
    data['langValue'] = this.langValue;
    return data;
  }
}

class CalandarLst {
  String? calActiveMethod;
  String? calActiveType;
  String? calName;
  String? cropSeason;
  String? noOfDays;

  CalandarLst({this.calActiveMethod, this.calActiveType, this.calName, this.cropSeason, this.noOfDays});

  factory CalandarLst.fromJson(Map<String, dynamic> json) {
    return CalandarLst(
      calActiveMethod: json['calActiveMethod'],
      calActiveType: json['calActiveType'],
      calName: json['calName'],
      cropSeason: json['cropSeason'],
      noOfDays: json['noOfDays'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calActiveMethod'] = this.calActiveMethod;
    data['calActiveType'] = this.calActiveType;
    data['calName'] = this.calName;
    data['cropSeason'] = this.cropSeason;
    data['noOfDays'] = this.noOfDays;
    return data;
  }
}

class GrdLst {
  List<Object>? lang;
  String? ppGraCode;
  String? ppGraName;
  String? ppGraPrice;

  GrdLst({this.lang, this.ppGraCode, this.ppGraName, this.ppGraPrice});

  factory GrdLst.fromJson(Map<String, dynamic> json) {
    return GrdLst(
      lang: json['lang'] ,
      ppGraCode: json['ppGraCode'],
      ppGraName: json['ppGraName'],
      ppGraPrice: json['ppGraPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppGraCode'] = this.ppGraCode;
    data['ppGraName'] = this.ppGraName;
    data['ppGraPrice'] = this.ppGraPrice;
    if (this.lang != null) {
      data['lang'];
    }
    return data;
  }
}



class Data9 {
  List<CoOperative>? coOperatives;
  String? coRevNo;
  List<SamithiX>? samithis;

  Data9({this.coOperatives, this.coRevNo, this.samithis});

  factory Data9.fromJson(Map<String, dynamic> json) {
    return Data9(
      coOperatives: json['coOperatives'] != null ? (json['coOperatives'] as List).map((i) => CoOperative.fromJson(i)).toList() : null,
      coRevNo: json['coRevNo'],
      samithis: json['samithis'] != null ? (json['samithis'] as List).map((i) => SamithiX.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coRevNo'] = this.coRevNo;
    if (this.coOperatives != null) {
      data['coOperatives'] = this.coOperatives!.map((v) => v.toJson()).toList();
    }
    if (this.samithis != null) {
      data['samithis'] = this.samithis!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SamithiX {
  String? samCode;
  String? samName;
  int? utzStatus;

  SamithiX({this.samCode, this.samName, this.utzStatus});

  factory SamithiX.fromJson(Map<String, dynamic> json) {
    return SamithiX(
      samCode: json['samCode'],
      samName: json['samName'],
      utzStatus: json['utzStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['samCode'] = this.samCode;
    data['samName'] = this.samName;
    data['utzStatus'] = this.utzStatus;
    return data;
  }
}

class CoOperative {
  String? coCode;
  String? coName;

  CoOperative({this.coCode, this.coName});

  factory CoOperative.fromJson(Map<String, dynamic> json) {
    return CoOperative(
      coCode: json['coCode'],
      coName: json['coName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coCode'] = this.coCode;
    data['coName'] = this.coName;
    return data;
  }
}

class Data12 {
  int? plannerRevNo;
  List<TrLists>? trLists;

  Data12({this.plannerRevNo, this.trLists});

  factory Data12.fromJson(Map<String, dynamic> json) {
    return Data12(
      plannerRevNo: json['plannerRevNo'],
      trLists: json['trLists'] != null ? (json['trLists'] as List).map((i) => TrLists.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plannerRevNo'] = this.plannerRevNo;
    if (this.trLists != null) {
      data['trLists'] = this.trLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrLists {
  List<Planner>? planners;
  List<Tmaterial>? tmaterial;
  List<Tmethod>? tmethod;
  List<TopicLists>? topicLists;
  String? trCode;
  String? trName;
  List<Trob>? trobs;

  TrLists({this.planners, this.tmaterial, this.tmethod, this.topicLists, this.trCode, this.trName, this.trobs});

  factory TrLists.fromJson(Map<String, dynamic> json) {
    return TrLists(
      planners: json['planners'] != null ? (json['planners'] as List).map((i) => Planner.fromJson(i)).toList() : null,
      tmaterial: json['tmaterial'] != null ? (json['tmaterial'] as List).map((i) => Tmaterial.fromJson(i)).toList() : null,
      tmethod: json['tmethod'] != null ? (json['tmethod'] as List).map((i) => Tmethod.fromJson(i)).toList() : null,
      topicLists: json['topicLists'] != null ? (json['topicLists'] as List).map((i) => TopicLists.fromJson(i)).toList() : null,
      trCode: json['trCode'],
      trName: json['trName'],
      trobs: json['trobs'] != null ? (json['trobs'] as List).map((i) => Trob.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trCode'] = this.trCode;
    data['trName'] = this.trName;
    if (this.planners != null) {
      data['planners'] = this.planners!.map((v) => v.toJson()).toList();
    }
    if (this.tmaterial != null) {
      data['tmaterial'] = this.tmaterial!.map((v) => v.toJson()).toList();
    }
    if (this.tmethod != null) {
      data['tmethod'] = this.tmethod!.map((v) => v.toJson()).toList();
    }
    if (this.topicLists != null) {
      data['topicLists'] = this.topicLists!.map((v) => v.toJson()).toList();
    }
    if (this.trobs != null) {
      data['trobs'] = this.trobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trob {
  String? obscode;
  String? obsname;

  Trob({this.obscode, this.obsname});

  factory Trob.fromJson(Map<String, dynamic> json) {
    return Trob(
      obscode: json['obscode'],
      obsname: json['obsname'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obscode'] = this.obscode;
    data['obsname'] = this.obsname;
    return data;
  }
}

class TopicLists {
  String? ccCode;
  String? ccName;
  String? criteria;

  TopicLists({this.ccCode, this.ccName, this.criteria});

  factory TopicLists.fromJson(Map<String, dynamic> json) {
    return TopicLists(
      ccCode: json['ccCode'],
      ccName: json['ccName'],
      criteria: json['criteria'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccCode'] = this.ccCode;
    data['ccName'] = this.ccName;
    data['criteria'] = this.criteria;
    return data;
  }
}

class Tmaterial {
  String? tmatcode;
  String? tmatname;

  Tmaterial({this.tmatcode, this.tmatname});

  factory Tmaterial.fromJson(Map<String, dynamic> json) {
    return Tmaterial(
      tmatcode: json['tmatcode'],
      tmatname: json['tmatname'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tmatcode'] = this.tmatcode;
    data['tmatname'] = this.tmatname;
    return data;
  }
}

class Tmethod {
  String? tmcode;
  String? tmname;

  Tmethod({this.tmcode, this.tmname});

  factory Tmethod.fromJson(Map<String, dynamic> json) {
    return Tmethod(
      tmcode: json['tmcode'],
      tmname: json['tmname'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tmcode'] = this.tmcode;
    data['tmname'] = this.tmname;
    return data;
  }
}

class Planner {
  String? planner;
  String? trCodePlanRef;

  Planner({this.planner, this.trCodePlanRef});

  factory Planner.fromJson(Map<String, dynamic> json) {
    return Planner(
      planner: json['planner'],
      trCodePlanRef: json['trCodePlanRef'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planner'] = this.planner;
    data['trCodePlanRef'] = this.trCodePlanRef;
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
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList() : null,
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
  List<Object>? lang;
  String? sCode;
  String? sName;

  Season({this.lang, this.sCode, this.sName});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      lang: json['lang'] ,
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

class Data17 {
  List<Object>? eventLst;
  String? eventRevNo;

  Data17({this.eventLst, this.eventRevNo});

  factory Data17.fromJson(Map<String, dynamic> json) {
    return Data17(
      eventLst: json['eventLst'] ,
      eventRevNo: json['eventRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventRevNo'] = this.eventRevNo;
    if (this.eventLst != null) {
      data['eventLst'] = this.eventLst;
    }
    return data;
  }
}

class Data16 {
  List<Object>? frStockList;
  String? stRevNo;

  Data16({this.frStockList, this.stRevNo});

  factory Data16.fromJson(Map<String, dynamic> json) {
    return Data16(
      frStockList: json['frStockList'] ,
      stRevNo: json['stRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stRevNo'] = this.stRevNo;
    if (this.frStockList != null) {
      data['frStockList'] = this.frStockList;
    }
    return data;
  }
}