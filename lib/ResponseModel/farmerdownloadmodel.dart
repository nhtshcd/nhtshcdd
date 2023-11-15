class farmerdownloadmodel {
    Response? response;

    farmerdownloadmodel({this.response});

    factory farmerdownloadmodel.fromJson(Map<String, dynamic> json) {
        return farmerdownloadmodel(
            response: json['response'] != null ? Response.fromJson(json['response']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.response != null) {
            data['response'] = this.response!.toJson();
        }
        return data;
    }
}

class Response {
    Body? body;

    Response({this.body});

    factory Response.fromJson(Map<String, dynamic> json) {
        return Response(
            body: json['body'] != null ? Body.fromJson(json['body']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.body != null) {
            data['body'] = this.body!.toJson();
        }
        return data;
    }
}

class Body {
    List<Farmer>? farmerList;
    String? txnLogId;

    Body({this.farmerList, this.txnLogId});

    factory Body.fromJson(Map<String, dynamic> json) {
        return Body(
            farmerList: json['farmerList'] != null ? (json['farmerList'] as List).map((i) => Farmer.fromJson(i)).toList() : null,
            txnLogId: json['txnLogId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['txnLogId'] = this.txnLogId;
        if (this.farmerList != null) {
            data['farmerList'] = this.farmerList!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Farmer {
    String? address;
    String? cSeasonCode;
    String? cityCode;
    String? cop;
    String? ctName;
    String? districtCode;
    String? fMobNo;
    String? farmerCertStatus;
    String? farmerCode;
    String? farmerId;
    String? farmerIdd;
    String? farms;
    String? fct;
    String? firstName;
    String? frPhoto;
    String? hhid;
    String? icsCode;
    String? icsFrTrac;
    String? idProof;
    String? isCertFarmer;
    String? lastName;
    String? maritalStatus;
    String? panCode;
    String? phoneNo;
    String? rifanId;
    String? samCode;
    String? stateCode;
    String? status;
    String? surName;
    String? trader;
    String? utzStatus;
    String? village;

    Farmer({this.address, this.cSeasonCode, this.cityCode, this.cop, this.ctName, this.districtCode, this.fMobNo, this.farmerCertStatus, this.farmerCode, this.farmerId, this.farmerIdd, this.farms, this.fct, this.firstName, this.frPhoto, this.hhid, this.icsCode, this.icsFrTrac, this.idProof, this.isCertFarmer, this.lastName, this.maritalStatus, this.panCode, this.phoneNo, this.rifanId, this.samCode, this.stateCode, this.status, this.surName, this.trader, this.utzStatus, this.village});

    factory Farmer.fromJson(Map<String, dynamic> json) {
        return Farmer(
            address: json['address'],
            cSeasonCode: json['cSeasonCode'],
            cityCode: json['cityCode'],
            cop: json['cop'],
            ctName: json['ctName'],
            districtCode: json['districtCode'],
            fMobNo: json['fMobNo'],
            farmerCertStatus: json['farmerCertStatus'],
            farmerCode: json['farmerCode'],
            farmerId: json['farmerId'],
            farmerIdd: json['farmerIdd'],
            farms: json['farms'],
            fct: json['fct'],
            firstName: json['firstName'],
            frPhoto: json['frPhoto'],
            hhid: json['hhid'],
            icsCode: json['icsCode'],
            icsFrTrac: json['icsFrTrac'],
            idProof: json['idProof'],
            isCertFarmer: json['isCertFarmer'],
            lastName: json['lastName'],
            maritalStatus: json['maritalStatus'],
            panCode: json['panCode'],
            phoneNo: json['phoneNo'],
            rifanId: json['rifanId'],
            samCode: json['samCode'],
            stateCode: json['stateCode'],
            status: json['status'],
            surName: json['surName'],
            trader: json['trader'],
            utzStatus: json['utzStatus'],
            village: json['village'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['cSeasonCode'] = this.cSeasonCode;
        data['cityCode'] = this.cityCode;
        data['cop'] = this.cop;
        data['ctName'] = this.ctName;
        data['districtCode'] = this.districtCode;
        data['fMobNo'] = this.fMobNo;
        data['farmerCertStatus'] = this.farmerCertStatus;
        data['farmerCode'] = this.farmerCode;
        data['farmerId'] = this.farmerId;
        data['farmerIdd'] = this.farmerIdd;
        data['farms'] = this.farms;
        data['fct'] = this.fct;
        data['firstName'] = this.firstName;
        data['frPhoto'] = this.frPhoto;
        data['hhid'] = this.hhid;
        data['icsCode'] = this.icsCode;
        data['icsFrTrac'] = this.icsFrTrac;
        data['idProof'] = this.idProof;
        data['isCertFarmer'] = this.isCertFarmer;
        data['lastName'] = this.lastName;
        data['maritalStatus'] = this.maritalStatus;
        data['panCode'] = this.panCode;
        data['phoneNo'] = this.phoneNo;
        data['rifanId'] = this.rifanId;
        data['samCode'] = this.samCode;
        data['stateCode'] = this.stateCode;
        data['status'] = this.status;
        data['surName'] = this.surName;
        data['trader'] = this.trader;
        data['utzStatus'] = this.utzStatus;
        data['village'] = this.village;
        return data;
    }
}