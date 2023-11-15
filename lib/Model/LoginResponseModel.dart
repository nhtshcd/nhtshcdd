class LoginResponseModel {
    Response? response;

    LoginResponseModel({this.response});

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
        return LoginResponseModel(
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
    Data14? data14;

    Body({this.agentLogin, this.data14});

    factory Body.fromJson(Map<String, dynamic> json) {
        return Body(
            agentLogin: json['agentLogin'] != null ? AgentLogin.fromJson(json['agentLogin']) : null,
            data14: json['data14'] != null ? Data14.fromJson(json['data14']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.agentLogin != null) {
            data['agentLogin'] = this.agentLogin!.toJson();
        }
        if (this.data14 != null) {
            data['data14'] = this.data14!.toJson();
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
    Object? digitalSign;
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
    Object? isBuyer;
    String? isGeneric;
    String? isGrampnchayat;
    String? isQrs;
    String? isTracker;
    String? lRevNo;
    String? parentId;
    int? plannerRevNo;
    String? preIR;
    String? procProdRevNo;
    String? prodRevNo;
    String? rApkV;
    String? rConfV;
    String? rDbV;
    String? roi;
    List<Samithi>? samithis;
    String? seasonRevNo;
    String? servPointId;
    String? servPointName;
    String? spIdSeq;
    String? supRevNo;
    String? syncTS;
    String? tare;
    int? tcRevNo;
    int? tccRevNo;
    String? vwsRevNo;
    String? warehouseId;
    Object? warehouseSeason;
    String? wsRevNo;

    AgentLogin({this.acMod, this.agentName, this.agentType, this.areaType, this.bal, this.branchId, this.byrRevNo, this.catRevNo, this.clientIdSeq, this.clientRevNo, this.coRevNo, this.cropCalandar, this.currency, this.currentSeasonCode, this.deviceId, this.digitalSign, this.dispDtFormat, this.displayTSFormat, this.distImgAvil, this.dynLatestRevNo, this.eFrom, this.fCropRevNo, this.farmRevNo, this.farmerRevNo, this.fobRevNo, this.fsRevNo, this.ftpPath, this.ftpPw, this.ftpUrl, this.ftpUs, this.gFReq, this.gRad, this.iRateA, this.isAExF, this.isBatchAvail, this.isBuyer, this.isGeneric, this.isGrampnchayat, this.isQrs, this.isTracker, this.lRevNo, this.parentId, this.plannerRevNo, this.preIR, this.procProdRevNo, this.prodRevNo, this.rApkV, this.rConfV, this.rDbV, this.roi, this.samithis, this.seasonRevNo, this.servPointId, this.servPointName, this.spIdSeq, this.supRevNo, this.syncTS, this.tare, this.tcRevNo, this.tccRevNo, this.vwsRevNo, this.warehouseId, this.warehouseSeason, this.wsRevNo});

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
            digitalSign: json['digitalSign'] != null ,
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
            isBuyer: json['isBuyer'] != null ,
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
            samithis: json['samithis'] != null ? (json['samithis'] as List).map((i) => Samithi.fromJson(i)).toList() : null,
            seasonRevNo: json['seasonRevNo'],
            servPointId: json['servPointId'],
            servPointName: json['servPointName'],
            spIdSeq: json['spIdSeq'],
            supRevNo: json['supRevNo'],
            syncTS: json['syncTS'],
            tare: json['tare'],
            tcRevNo: json['tcRevNo'],
            tccRevNo: json['tccRevNo'],
            vwsRevNo: json['vwsRevNo'],
            warehouseId: json['warehouseId'],
            warehouseSeason: json['warehouseSeason'] != null ,
            wsRevNo: json['wsRevNo'],
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
        data['seasonRevNo'] = this.seasonRevNo;
        data['servPointId'] = this.servPointId;
        data['servPointName'] = this.servPointName;
        data['spIdSeq'] = this.spIdSeq;
        data['supRevNo'] = this.supRevNo;
        data['syncTS'] = this.syncTS;
        data['tare'] = this.tare;
        data['tcRevNo'] = this.tcRevNo;
        data['tccRevNo'] = this.tccRevNo;
        data['vwsRevNo'] = this.vwsRevNo;
        data['warehouseId'] = this.warehouseId;
        data['wsRevNo'] = this.wsRevNo;
        if (this.digitalSign != null) {
            data['digitalSign'] = this.digitalSign;
        }
        if (this.isBuyer != null) {
            data['isBuyer'] = this.isBuyer;
        }
        if (this.samithis != null) {
            data['samithis'] = this.samithis!.map((v) => v.toJson()).toList();
        }
        if (this.warehouseSeason != null) {
            data['warehouseSeason'] = this.warehouseSeason;
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

class Data14 {
    int? dynLatestRevNo;
    List<Menulist>? menulist;

    Data14({this.dynLatestRevNo, this.menulist});

    factory Data14.fromJson(Map<String, dynamic> json) {
        return Data14(
            dynLatestRevNo: json['dynLatestRevNo'],
            menulist: json['menulist'] != null ? (json['menulist'] as List).map((i) => Menulist.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['dynLatestRevNo'] = this.dynLatestRevNo;
        if (this.menulist != null) {
            data['menulist'] = this.menulist!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Menulist {
    String? agentType;
    String? entity;
    String? iconClass;
    List<Object>? lang;
    String? menuId;
    String? menuLabel;
    String? menuOrder;
    String? seasonFlag;
    List<Section>? sections;
    String? txnTypeId;

    Menulist({this.agentType, this.entity, this.iconClass, this.lang, this.menuId, this.menuLabel, this.menuOrder, this.seasonFlag, this.sections, this.txnTypeId});

    factory Menulist.fromJson(Map<String, dynamic> json) {
        return Menulist(
            agentType: json['agentType'],
            entity: json['entity'],
            iconClass: json['iconClass'],
            lang: json['lang'],
            menuId: json['menuId'],
            menuLabel: json['menuLabel'],
            menuOrder: json['menuOrder'],
            seasonFlag: json['seasonFlag'],
            sections: json['sections'] != null ? (json['sections'] as List).map((i) => Section.fromJson(i)).toList() : null,
            txnTypeId: json['txnTypeId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['agentType'] = this.agentType;
        data['entity'] = this.entity;
        data['iconClass'] = this.iconClass;
        data['menuId'] = this.menuId;
        data['menuLabel'] = this.menuLabel;
        data['menuOrder'] = this.menuOrder;
        data['seasonFlag'] = this.seasonFlag;
        data['txnTypeId'] = this.txnTypeId;
        if (this.lang != null) {
            data['lang'] = this.lang;
        }
        if (this.sections != null) {
            data['sections'] = this.sections!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Section {
    String? afterInsert;
    String? beforeInsert;
    String? blockId;
    List<Field>? fieldList;
    List<Lists>? lists;
    String? secId;
    String? secName;
    String? txnTypeId;

    Section({this.afterInsert, this.beforeInsert, this.blockId, this.fieldList, this.lists, this.secId, this.secName, this.txnTypeId});

    factory Section.fromJson(Map<String, dynamic> json) {
        return Section(
            afterInsert: json['afterInsert'],
            beforeInsert: json['beforeInsert'],
            blockId: json['blockId'],
            fieldList: json['fieldList'] != null ? (json['fieldList'] as List).map((i) => Field.fromJson(i)).toList() : null,
            lists: json['lists'] != null ? (json['lists'] as List).map((i) => Lists.fromJson(i)).toList() : null,
            secId: json['secId'],
            secName: json['secName'],
            txnTypeId: json['txnTypeId'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['afterInsert'] = this.afterInsert;
        data['beforeInsert'] = this.beforeInsert;
        data['blockId'] = this.blockId;
        data['secId'] = this.secId;
        data['secName'] = this.secName;
        data['txnTypeId'] = this.txnTypeId;
        if (this.fieldList != null) {
            data['fieldList'] = this.fieldList!.map((v) => v.toJson()).toList();
        }
        if (this.lists != null) {
            data['lists'] = this.lists!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Lists {
    String? listId;
    String? listName;

    Lists({this.listId, this.listName});

    factory Lists.fromJson(Map<String, dynamic> json) {
        return Lists(
            listId: json['listId'],
            listName: json['listName'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['listId'] = this.listId;
        data['listName'] = this.listName;
        return data;
    }
}

class Field {
    String? afterFld;
    String? beforeFld;
    String? blockId;
    String? catDepKey;
    String? catType;
    String? compoId;
    String? compoLabel;
    String? compoType;
    String? dataFormat;
    String? dependentField;
    String? formulaDependency;
    String? isOther;
    String? isRequired;
    List<Object>? lang;
    String? listId;
    String? listMethodName;
    String? maxLength;
    String? minLength;
    String? order;
    String? parentDepend;
    String? parentField;
    String? secId;
    String? txnTypeId;
    String? validType;

    Field({this.afterFld, this.beforeFld, this.blockId, this.catDepKey, this.catType, this.compoId, this.compoLabel, this.compoType, this.dataFormat, this.dependentField, this.formulaDependency, this.isOther, this.isRequired, this.lang, this.listId, this.listMethodName, this.maxLength, this.minLength, this.order, this.parentDepend, this.parentField, this.secId, this.txnTypeId, this.validType});

    factory Field.fromJson(Map<String, dynamic> json) {
        return Field(
            afterFld: json['afterFld'],
            beforeFld: json['beforeFld'],
            blockId: json['blockId'],
            catDepKey: json['catDepKey'],
            catType: json['catType'],
            compoId: json['compoId'],
            compoLabel: json['compoLabel'],
            compoType: json['compoType'],
            dataFormat: json['dataFormat'],
            dependentField: json['dependentField'],
            formulaDependency: json['formulaDependency'],
            isOther: json['isOther'],
            isRequired: json['isRequired'],
            lang: json['lang']  ,
            listId: json['listId'],
            listMethodName: json['listMethodName'],
            maxLength: json['maxLength'],
            minLength: json['minLength'],
            order: json['order'],
            parentDepend: json['parentDepend'],
            parentField: json['parentField'],
            secId: json['secId'],
            txnTypeId: json['txnTypeId'],
            validType: json['validType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['afterFld'] = this.afterFld;
        data['beforeFld'] = this.beforeFld;
        data['blockId'] = this.blockId;
        data['catDepKey'] = this.catDepKey;
        data['catType'] = this.catType;
        data['compoId'] = this.compoId;
        data['compoLabel'] = this.compoLabel;
        data['compoType'] = this.compoType;
        data['dataFormat'] = this.dataFormat;
        data['dependentField'] = this.dependentField;
        data['formulaDependency'] = this.formulaDependency;
        data['isOther'] = this.isOther;
        data['isRequired'] = this.isRequired;
        data['listId'] = this.listId;
        data['listMethodName'] = this.listMethodName;
        data['maxLength'] = this.maxLength;
        data['minLength'] = this.minLength;
        data['order'] = this.order;
        data['parentDepend'] = this.parentDepend;
        data['parentField'] = this.parentField;
        data['secId'] = this.secId;
        data['txnTypeId'] = this.txnTypeId;
        data['validType'] = this.validType;
        if (this.lang != null) {
            data['lang'] = this.lang;
        }
        return data;
    }
}