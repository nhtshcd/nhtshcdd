class farmerlistresponsemodel {
  Response? response;

  farmerlistresponsemodel({this.response});

  factory farmerlistresponsemodel.fromJson(Map<String, dynamic> json) {
    return farmerlistresponsemodel(
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
  List<Farmer>? farmerList;
  String? revNo;

  Body({this.farmerList, this.revNo});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      farmerList: json['farmerList'] != null
          ? (json['farmerList'] as List).map((i) => Farmer.fromJson(i)).toList()
          : null,
      revNo: json['revNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['revNo'] = this.revNo;
    if (this.farmerList != null) {
      data['farmerList'] = this.farmerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Farmer {
  String? firstName;
  String? lastName;
  String? farmerId;
  String? exporter;
  String? address;
  String? fMobNo;
  String? village;
  String? farmerCode;
  String? exporterCode;
  String? status;
  String? NatId;
  String? state_name;
  String? state;
  String? farmerKRA;

  Farmer({
    this.firstName,
    this.lastName,
    this.farmerId,
    this.exporter,
    this.address,
    this.fMobNo,
    this.village,
    this.farmerCode,
    this.exporterCode,
    this.status,
    this.NatId,
    this.state_name,
    this.state,
    this.farmerKRA,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      firstName: json['firstName'],
      lastName: json['lastName'],
      farmerId: json['farmerId'],
      exporter: json['exporter'],
      address: json['address'],
      fMobNo: json['fMobNo'],
      village: json['village'],
      farmerCode: json['farmerCode'],
      exporterCode: json['exporterCode'],
      status: json['status'],
      NatId: json['NatId'],
      state_name: json['state_name'],
      state: json['state'],
      farmerKRA: json['farmerKRA'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['farmerId'] = this.farmerId;
    data['exporter'] = this.exporter;
    data['address'] = this.address;
    data['fMobNo'] = this.fMobNo;
    data['village'] = this.village;
    data['farmerCode'] = this.farmerCode;
    data['exporterCode'] = this.exporterCode;
    data['status'] = this.status;
    data['NatId'] = this.NatId;
    data['state_name'] = this.state_name;
    data['state'] = this.state;
    data['farmerKRA'] = this.farmerKRA;

    return data;
  }
}
