class Croplistvalues {
  Response? response;

  Croplistvalues({this.response});

  factory Croplistvalues.fromJson(Map<String, dynamic> json) {
    return Croplistvalues(
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
  List<Crop>? cropList;
  String? fCropRevNo;

  Body({this.cropList, this.fCropRevNo});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      cropList: json['cropList'] != null
          ? (json['cropList'] as List).map((i) => Crop.fromJson(i)).toList()
          : null,
      fCropRevNo: json['fCropRevNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fCropRevNo'] = this.fCropRevNo;
    if (this.cropList != null) {
      data['cropList'] = this.cropList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Crop {
  String? blockId;
  String? cropId;
  String? farmerId;
  String? sowDt;
  String? blockName;
  String? variety;
  String? cultArea;
  String? farmCode;
  String? status;
  String? gCode;
  String? plantingId;
  String? expHarvestQty;
  String? fcropId;
  String? maxPhiDate;
  String? commonRec;
  String? scoutDate;
  String? dateOfEve;

  Crop({
    this.blockId,
    this.cropId,
    this.farmerId,
    this.sowDt,
    this.cultArea,
    this.blockName,
    this.variety,
    this.farmCode,
    this.status,
    this.gCode,
    this.plantingId,
    this.expHarvestQty,
    this.fcropId,
    this.maxPhiDate,
    this.commonRec,
    this.scoutDate,
    this.dateOfEve,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      blockId: json['blockId'],
      cropId: json['cropId'],
      farmerId: json['farmerId'],
      sowDt: json['sowDt'],
      blockName: json['blockName'],
      variety: json['variety'],
      cultArea: json['cultArea'],
      farmCode: json['farmCode'],
      status: json['status'],
      gCode: json['gCode'],
      plantingId: json['plantingId'],
      expHarvestQty: json['expHarvestQty'],
      fcropId: json['fcropId'],
      maxPhiDate: json['maxPhiDate'],
      commonRec: json['sctRecommendation'],
      scoutDate: json['scoutDate'],
      dateOfEve: json['eDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockId'] = this.blockId;
    data['cropId'] = this.cropId;
    data['farmerId'] = this.farmerId;
    data['sowDt'] = this.sowDt;
    data['blockName'] = this.blockName;
    data['variety'] = this.variety;
    data['cultArea'] = this.cultArea;
    data['farmCode'] = this.farmCode;
    data['status'] = this.status;
    data['gCode'] = this.gCode;
    data['plantingId'] = this.plantingId;
    data['expHarvestQty'] = this.expHarvestQty;
    data['fcropId'] = this.fcropId;
    data['maxPhiDate'] = this.maxPhiDate;
    data['sctRecommendation'] = this.commonRec;
    data['scoutDate'] = this.scoutDate;
    data['eDate'] = this.dateOfEve;

    return data;
  }
}
