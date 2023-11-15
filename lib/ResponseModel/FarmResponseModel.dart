class FarmResponseModel {
  Response? response;

  FarmResponseModel({this.response});

  factory FarmResponseModel.fromJson(Map<String, dynamic> json) {
    return FarmResponseModel(
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

class Body {
  List<Farm>? farmList;
  String? farmRevNo;

  Body({this.farmList, this.farmRevNo});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      farmList: json['farmList'] != null
          ? (json['farmList'] as List).map((i) => Farm.fromJson(i)).toList()
          : null,
      farmRevNo: json['farmRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farmRevNo'] = this.farmRevNo;
    if (this.farmList != null) {
      data['farmList'] = this.farmList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Farm {
  String? fLat;
  String? fLon;
  String? farmCode;
  String? farmName;
  String? farmStatus;
  String? farmerId;
  String? frmProd;
  String? totLaAra;
  String? farmId;
  String? country_code;
  String? state;
  String? district;
  String? city;
  String? village;
  String? blockCount;
  List<BlockingList>? blockingLst;

  Farm(
      {this.fLat,
      this.fLon,
      this.farmCode,
      this.farmName,
      this.farmStatus,
      this.farmerId,
      this.frmProd,
      this.totLaAra,
      this.farmId,
      this.country_code,
      this.state,
      this.district,
      this.city,
      this.village,
      this.blockCount,
      this.blockingLst});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      fLat: json['fLat'],
      fLon: json['fLon'],
      farmCode: json['farmCode'],
      farmName: json['farmName'],
      farmStatus: json['farmStatus'],
      farmerId: json['farmerId'],
      frmProd: json['frmProd'],
      totLaAra: json['totLaAra'],
      farmId: json['farmId'],
      country_code: json['country_code'],
      state: json['state'],
      district: json['district'],
      city: json['city'],
      village: json['village'],
      blockCount: json['blockCount'],
      blockingLst: json['blockingLst'] != null
          ? (json['blockingLst'] as List)
              .map((i) => BlockingList.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fLat'] = this.fLat;
    data['fLon'] = this.fLon;
    data['farmCode'] = this.farmCode;
    data['farmName'] = this.farmName;
    data['farmStatus'] = this.farmStatus;
    data['farmerId'] = this.farmerId;
    data['frmProd'] = this.frmProd;
    data['totLaAra'] = this.totLaAra;
    data['farmId'] = this.farmId;
    data['country_code'] = this.country_code;
    data['state'] = this.state;
    data['district'] = this.district;
    data['city'] = this.city;
    data['village'] = this.village;
    data['blockCount'] = this.blockCount;
    if (this.blockingLst != null) {
      data['blockingLst'] = this.blockingLst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockingList {
  String? blockId;
  String? blockName;
  String? cultArea;

  BlockingList({this.blockId, this.blockName, this.cultArea});

  factory BlockingList.fromJson(Map<String, dynamic> json) {
    return BlockingList(
      blockId: json['blockId'],
      blockName: json['blockName'],
      cultArea: json['cultArea'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockId'] = blockId;
    data['blockName'] = blockName;
    data['cultArea'] = cultArea;
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
