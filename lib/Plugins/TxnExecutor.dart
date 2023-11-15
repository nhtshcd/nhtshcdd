import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';


import 'package:dart_ipify/dart_ipify.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/main.dart';
import 'package:package_info/package_info.dart';


import '../Utils/secure_storage.dart';
import '../login.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class TxnExecutor {
  void CheckCustTrasactionTable() async {
    bool isOnline = await hasNetwork();

    try {
      var db = DatabaseHelper();
      var now = new DateTime.now();
      var Timestamp = new DateFormat('dd-MM-yyyy HH:mm:ss');
      String timestamp = Timestamp.format(now);
      print("timestamp_timestamppp" + timestamp.toString());

      String? serialnumber = await SecureStorage().readSecureData("serialnumber");
      String? threadid = await SecureStorage().readSecureData("threadid");
      int differenceInseconds = 0;
      if (threadid != null) {
        DateTime oldTransactionDate = Timestamp.parse(threadid.trim());

        differenceInseconds = now.difference(oldTransactionDate).inSeconds;
        print('differenceInseconds ' +
            differenceInseconds.toString() +
            " " +
            threadid!);
        if (differenceInseconds > 300) {
          await SecureStorage().writeSecureData("isRunning", "0");
        }
      } else {
        differenceInseconds = 10;
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      List<String> versionlist = version
          .split(
              '.') // split the text into an array/ put the text inside a widget
          .toList();
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");

      String? runningValue;
      try {
        runningValue =  await SecureStorage().readSecureData("isRunning");
      } catch (e) {
        runningValue = "";
      }

      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (custTransactions.length == 0) {
        await SecureStorage().writeSecureData("isRunning", "0");
        runningValue =  await SecureStorage().readSecureData("isRunning");
      } else if (runningValue == null || runningValue.length == 0) {
        await SecureStorage().writeSecureData("isRunning", "0");
        runningValue = await SecureStorage().readSecureData("isRunning");
      }

      // if (threadid == timestamp || differenceInseconds < 5) {
      //print('threadid duplicate' + timestamp);
      //} else {
      await SecureStorage().writeSecureData("threadid", timestamp);
      runningValue = await SecureStorage().readSecureData("isRunning");
      String imageUploadTxn = await SecureStorage().decryptAES(appDatas.ImageUploadUrl);
      //print("imageUploadTxn:"+imageUploadTxn);
      if (custTransactions.length > 0) {
        try {
          print('isOnline' + isOnline.toString());
          print('runningValue ' + runningValue.toString());
          if (isOnline && runningValue == "0") {
           await SecureStorage().writeSecureData("isRunning", '1');
            for (int i = 0; i < custTransactions.length; i++) {
              print('custTransactionslengthValue' +
                  custTransactions.length.toString());
              var now = new DateTime.now();
              var Timestamp = new DateFormat('dd-MM-yyyy HH:mm:ss');
              String timestamp = Timestamp.format(now);
              print("forLoopTimeStamp" + timestamp.toString());
              String txnConfigId =
                  custTransactions[i]["txnConfigId"].toString();
              print("txnConfigId_forloop" + txnConfigId.toString());
              AppDatas datas = new AppDatas();
              String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
              if (txnConfigId == datas.txnScouting) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId" + custTxnsRefId);

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnScouting,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount": "0",
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> scouting = await db.RawQuery(
                      "SELECT * FROM scouting where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");
                  print("scouting_scouting" + scouting.toString());

                  for (int i = 0; i < scouting.length; i++) {
                    print("scouting_scouting" + scouting.length.toString());

                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": scouting[i]["farmerId"],
                        "farmId": scouting[i]["farmId"],
                        "blockid": scouting[i]["blockId"],
                        "plantingId": scouting[i]["cropId"],
                        "date": scouting[i]["dateSco"],
                        "insects": scouting[i]["insects"],
                        "nameIns": scouting[i]["nameInsect"],
                        "perIns": scouting[i]["perInsects"],
                        "disease": scouting[i]["disease"],
                        "nameDis": scouting[i]["nameDisease"],
                        "perDis": scouting[i]["perDisease"],
                        "weedObs": scouting[i]["weed"],
                        "weed": scouting[i]["nameWeed"],
                        "perWeed": scouting[i]["perWeed"],
                        "recom": scouting[i]["recommentation"],
                        "irrType": scouting[i]["irrType"],
                        "irrMet": scouting[i]["irrMethod"],
                        "area": scouting[i]["irrArea"],
                        "recNo": scouting[i]["recNo"],
                        "source": scouting[i]["waterSource"],
                        "sprayingRequired": scouting[i]["ownerSign"],
                        "sctRecommendation": scouting[i]["cmnRec"],
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("Request400" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    print(" Request400Response" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue(
                          'scouting', 'isSynched', '1', 'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txn_spray) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  var db = DatabaseHelper();
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);

                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": datas.txn_spray,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  int resentCount = int.parse(headerList[0]['resentCount']);
                  resentCount = resentCount + 1;
                  print('resentCount: ' + resentCount.toString());
                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ:' + succ.toString());

                  List<Map> sprayList = await db.RawQuery(
                      'select * from spray where isSynched = 0 and recNo=\'' +
                          custTxnsRefId +
                          '\'');

                  /*print('sprayListCount' + sprayList.length.toString());*/
                  for (int i = 0; i < sprayList.length; i++) {
                    String farmerId = sprayList[i]['farmerId'].toString();
                    String farmId = sprayList[i]['farmId'].toString();
                    String plantingId = sprayList[i]['plantingId'].toString();
                    String blockId = sprayList[i]['blockId'].toString();
                    String sprayDate = sprayList[i]['sprayDate'].toString();
                    String chemicalName =
                        sprayList[i]['chemicalName'].toString();
                    String Dosage = sprayList[i]['Dosage'].toString();
                    String uom = sprayList[i]['uom'].toString();
                    String operatorName =
                        sprayList[i]['operatorName'].toString();
                    String sprayerNumber =
                        sprayList[i]['sprayerNumber'].toString();
                    String equipmentType =
                        sprayList[i]['equipmentType'].toString();
                    String applicationMethod =
                        sprayList[i]['applicationMethod'].toString();
                    String chemicalPhi = sprayList[i]['chemicalPhi'].toString();
                    String TrainingStatus =
                        sprayList[i]['TrainingStatus'].toString();
                    String agrovert = sprayList[i]['agrovert'].toString();
                    String lastDate = sprayList[i]['lastDate'].toString();
                    int isSynched = sprayList[i]['isSynched'];
                    String recNo = sprayList[i]['recNo'].toString();
                    String diseaseTargeted = sprayList[i]['diseaseTargeted'].toString();
                    String activeIng = sprayList[i]['activeIng'].toString();
                    String endSprayDate =
                        sprayList[i]['endSprayDate'].toString();
                    String oprMedRpt = sprayList[i]['oprMedRpt'].toString();
                    String recommendation = sprayList[i]['recommendation'].toString();

                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": farmerId,
                        "farmcode": farmId,
                        "plantingId": plantingId,
                        "blockId": blockId,
                        "date": sprayDate,
                        "chem": chemicalName,
                        "dose": Dosage,
                        "uom": uom,
                        "operator": operatorName,
                        "sprayMob": sprayerNumber,
                        "appEq": equipmentType,
                        "moa": applicationMethod,
                        "ph": chemicalPhi,
                        "trOpe": TrainingStatus,
                        "agrovet": agrovert,
                        "dateOfCal": lastDate,
                        "recNo": recNo,
                        "dis": diseaseTargeted,
                        "activeIngredient": activeIng,
                        "endSprayDate": endSprayDate,
                        "oprMedRpt": oprMedRpt,
                        "recommendation": recommendation,
                      },
                      "head": jsonDecode(headdata),
                    });
                    printWrapped('sprayReqData1:' + reqdata.toString());
                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    printWrapped("CHECKRESPONSE " + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue(
                          'spray', 'isSynched', '1', 'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnFarmerRegistration) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }
                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValue_farmer" + ipAddressValue.toString());

                  print("elseif_farmerRegistration");
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";
                  print("farmerRegistration_headerqry" + headerqry.toString());

                  List<Map> headerList = await db.RawQuery(headerqry);
                  print("headerList_headerList" + headerList.toString());
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnFarmerRegistration,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);

                  List<Map> farmerRegistration = await db.RawQuery(
                      "SELECT police_station as farmOwnerShip,otherElectric as cropVariety,dob,farmerType,ctName as companyName,objective as certificate,trader as kRNPin,fName ,farmerId,gender,Age,phoneNo,cropname,country,state,city,district,village,photo,IdProofphoto,"
                              "IdProofTimeStamp,email,noOfMembers ,adultCntSiteFe,schoolChildFe,childCntSiteFe ,education,"
                              "assemnt,houseType,houseOwnership ,isSynched,timeStamp,longitude,latitude,"
                              "idProofVal,cropCategory,education, customVillageName,farmerCategory FROM farmer where isSynched = 0 and farmerId = '" +
                          custTxnsRefId +
                          "';");
                  print("farmerRegistration" + farmerRegistration.toString());

                  for (int i = 0; i < farmerRegistration.length; i++) {
                    String fPhoto = "";
                    String nPhoto = "";
                    try {
                      String farmerPhoto = farmerRegistration[i]["photo"];
                      String nationalPhoto =
                          farmerRegistration[i]["IdProofphoto"];
                      if (farmerPhoto.isNotEmpty) {
                        File farmerImage = File(farmerRegistration[i]['photo']);
                        List<int> imageBytes = farmerImage.readAsBytesSync();
                        fPhoto = base64Encode(imageBytes);
                      }
                      if (nationalPhoto.isNotEmpty) {
                        File nationalImage =
                            File(farmerRegistration[i]['IdProofphoto']);
                        List<int> imageBytes = nationalImage.readAsBytesSync();
                        nPhoto = base64Encode(imageBytes);
                      }
                    } catch (e) {
                      fPhoto = "";
                      nPhoto = "";
                    }
                    var reqdata = jsonEncode({
                      "body": {
                        "fName": farmerRegistration[i]["fName"],
                        "farmerId": farmerRegistration[i]["farmerId"],
                        "gender": farmerRegistration[i]["gender"],
                        "Age": farmerRegistration[i]["Age"],
                        "phoneNo": farmerRegistration[i]["phoneNo"],
                        "country": farmerRegistration[i]["country"],
                        "state": farmerRegistration[i]["state"],
                        "city": farmerRegistration[i]["city"],
                        "district": farmerRegistration[i]["district"],
                        "village": farmerRegistration[i]["village"],
                        "photo": fPhoto,
                        "idProofImg": nPhoto,
                        "email": farmerRegistration[i]["email"],
                        "noOfMembers": farmerRegistration[i]["noOfMembers"],
                        "adCntFe": farmerRegistration[i]["adultCntSiteFe"],
                        "schChCntFe": farmerRegistration[i]["schoolChildFe"],
                        "chCntFe": farmerRegistration[i]["childCntSiteFe"],
                        "education": farmerRegistration[i]["education"],
                        "assemnt": farmerRegistration[i]["assemnt"],
                        "ht": farmerRegistration[i]["houseType"],
                        "hop": farmerRegistration[i]["houseOwnership"],
                        "pcTime": farmerRegistration[i]["timeStamp"],
                        "lat": farmerRegistration[i]["longitude"],
                        "lon": farmerRegistration[i]["latitude"],
                        "idpValue": farmerRegistration[i]["idProofVal"],
                        "cropCategory": farmerRegistration[i]["cropCategory"],
                        "cropname": farmerRegistration[i]["cropname"],
                        "vName": farmerRegistration[i]["customVillageName"],
                        "farmerCatgory": farmerRegistration[i]["farmerCategory"],
                        "fcategory": farmerRegistration[i]["farmOwnerShip"],
                        "krapin": farmerRegistration[i]["kRNPin"],
                        "compName": farmerRegistration[i]["companyName"],
                        "regCert": farmerRegistration[i]["certificate"],
                        "fType": farmerRegistration[i]["farmerType"],
                        "dob": farmerRegistration[i]["dob"],
                        "cropVarity": farmerRegistration[i]["cropVariety"],
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("FarmerRegistrationReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('farmer', 'isSynched', '1',
                          'farmerId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnFarmRegistration) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValue_farm" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";
                  print("farmRegistration_headerqry" + headerqry.toString());

                  List<Map> headerList = await db.RawQuery(headerqry);
                  print("headerList_headerList" + headerList.toString());
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnFarmRegistration,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);

                  List<Map> farmRegistration = await db.RawQuery(
                      "SELECT farmCount,customVillageName,country,state,city,district,village,farmName,farmIDT, farmerId,farmArea,landOwner,prodLand,landGradient,landTopography,image,isSameFarmerAddress,farmAddress,testPhoto ,farmRegNo,isSynched,recptId,longitude,latitude,timeStamp FROM farm where isSynched = 0 and recptId = '" +
                          custTxnsRefId +
                          "';");

                  String farmerId = "", farmId = "", recId = "";
                  for (int k = 0; k < farmRegistration.length; k++) {
                    farmerId = farmRegistration[k]['farmerId'];
                    farmId = farmRegistration[k]['farmIDT'];
                    recId = farmRegistration[k]['recptId'];
                  }

                  List<String> farmLocationJsonList = [];
                  List<Map> farmLocationList = await db.RawQuery(
                      "select longitude,latitude,OrderOFGPS from farm_GPSLocation_Exists WHERE farmerId='" +
                          farmerId +
                          "' AND farmId ='" +
                          farmId +
                          "' and reciptId='" +
                          recId +
                          "' order by OrderOFGPS;");

                  for (int j = 0; j < farmLocationList.length; j++) {
                    var reqfarmLocation = jsonEncode({
                      "laLon": farmLocationList[j]["longitude"],
                      "laLat": farmLocationList[j]["latitude"],
                      "orderNo": farmLocationList[j]["OrderOFGPS"].toString(),
                    });
                    farmLocationJsonList.add(reqfarmLocation);
                  }

                  for (int i = 0; i < farmRegistration.length; i++) {
                    String fPhoto = "";
                    String dPhoto = "";

                    try {
                      String farmPhoto = farmRegistration[i]["image"];
                      String documentPhoto = farmRegistration[i]["testPhoto"];
                      if (farmPhoto.isNotEmpty) {
                        File farmImage = File(farmRegistration[i]["image"]);
                        List<int> imageBytes = farmImage.readAsBytesSync();
                        fPhoto = base64Encode(imageBytes);
                      }
                      if (documentPhoto.isNotEmpty) {
                        File documentImage =
                            File(farmRegistration[i]["testPhoto"]);
                        List<int> imageBytes = documentImage.readAsBytesSync();
                        dPhoto = base64Encode(imageBytes);
                      }
                    } catch (e) {
                      fPhoto = "";
                      dPhoto = "";
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "farmName": farmRegistration[i]["farmName"],
                        "farmCode": farmRegistration[i]["farmIDT"],
                        "farmerId": farmRegistration[i]["farmerId"],
                        "totLaAra": farmRegistration[i]["farmArea"],
                        "prPlAra": farmRegistration[i]["prodLand"],
                        "fo": farmRegistration[i]["landOwner"],
                        "ldGrd": farmRegistration[i]["landGradient"],
                        "ldTopo": farmRegistration[i]["landTopography"],
                        "fPhoto": fPhoto,
                        "isSameAddress": farmRegistration[i]
                            ["isSameFarmerAddress"],
                        "farmAddress": farmRegistration[i]["farmAddress"],
                        "regPhoto": dPhoto,
                        "regNo": farmRegistration[i]["farmRegNo"],
                        "recptId": farmRegistration[i]["recptId"],
                        "fLon": farmRegistration[i]["longitude"],
                        "fLat": farmRegistration[i]["latitude"],
                        "fpcTime": farmRegistration[i]["timeStamp"],
                        "country": farmRegistration[i]["country"],
                        "state": farmRegistration[i]["state"],
                        "city": farmRegistration[i]["city"],
                        "district": farmRegistration[i]["district"],
                        "village": farmRegistration[i]["village"],
                        "vName": farmRegistration[i]["customVillageName"],
                        "farmCount":
                            farmRegistration[i]["farmCount"].toString(),
                        "lAgps": jsonDecode(farmLocationJsonList.toString())
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("FarmRegistrationReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue(
                          'farm', 'isSynched', '1', 'recptId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }

              else if (txnConfigId == datas.txnSitePreparation) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValueSite" + ipAddressValue.toString());

                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnSitePreparation,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);

                  List<Map> sitePreparation = await db.RawQuery(
                      "SELECT blockId,txnDate,recNo, prevCrop,isSynched,farmerId,farmId,envAss,envAssPhoto,riskAss,riskAssPhoto,solAnly,solAnlyPhoto,waterAnly ,waterAnlyPhoto,isSynched FROM sitePreparation where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  for (int i = 0; i < sitePreparation.length; i++) {
                    String ePhoto = "", rPhoto = "", sPhoto = "", wPhoto = "";

                    String environmentPhoto = sitePreparation[i]["envAssPhoto"];
                    String riskAnalysisPhoto =
                        sitePreparation[i]["riskAssPhoto"];
                    String soilAnalysisPhoto =
                        sitePreparation[i]["solAnlyPhoto"];
                    String waterAnalysisPhoto =
                        sitePreparation[i]["waterAnlyPhoto"];
                    File? eImage;
                    File? rImage;
                    File? sImage;
                    File? wImage;

                    String referenceNo = "",
                        referenceNo2 = "",
                        referenceNo3 = "",
                        referenceNo4 = "";

                    if (environmentPhoto.isNotEmpty) {
                      eImage = File(sitePreparation[i]["envAssPhoto"]);
                      //List<int> imageBytes = eImage.readAsBytesSync();
                      //ePhoto = base64Encode(imageBytes);

                      Random rnd = new Random();
                      int refNo = 100000 + rnd.nextInt(999999 - 100000);
                      referenceNo = refNo.toString();
                      uploadImage(referenceNo, eImage!);
                    }
                    if (riskAnalysisPhoto.isNotEmpty) {
                      rImage = File(sitePreparation[i]["riskAssPhoto"]);
                      //List<int> imageBytes = rImage.readAsBytesSync();
                      //rPhoto = base64Encode(imageBytes);
                      Random rnd = new Random();
                      int refNo2 = 100000 + rnd.nextInt(999999 - 100000);
                      referenceNo2 = refNo2.toString();
                      uploadImage(referenceNo2, rImage!);
                    }

                    if (soilAnalysisPhoto.isNotEmpty) {
                      sImage = File(sitePreparation[i]["solAnlyPhoto"]);
                      //List<int> imageBytes = sImage.readAsBytesSync();
                      //sPhoto = base64Encode(imageBytes);
                      Random rnd = new Random();
                      int refNo3 = 100000 + rnd.nextInt(999999 - 100000);
                      referenceNo3 = refNo3.toString();
                      uploadImage(referenceNo3, sImage!);
                    }
                    if (waterAnalysisPhoto.isNotEmpty) {
                      wImage = File(sitePreparation[i]["waterAnlyPhoto"]);

                      Random rnd = new Random();
                      int refNo4 = 100000 + rnd.nextInt(999999 - 100000);
                      referenceNo4 = refNo4.toString();
                      uploadImage(referenceNo4, wImage!);
                      //List<int> imageBytes = wImage.readAsBytesSync();
                      //wPhoto = base64Encode(imageBytes);
                    }

                    var reqdata = jsonEncode({
                      "body": {
                        "pcTime": sitePreparation[i]["txnDate"],
                        "recNo": sitePreparation[i]["recNo"],
                        "farmerId": sitePreparation[i]["farmerId"],
                        "farmId": sitePreparation[i]["farmId"],
                        "pCrop": sitePreparation[i]["prevCrop"],
                        "envAss": sitePreparation[i]["envAss"],
                        "envPhoto": referenceNo,
                        "riskAss": sitePreparation[i]["riskAss"],
                        "riskPhoto": referenceNo2,
                        "soilAnal": sitePreparation[i]["solAnly"],
                        "soilPhoto": referenceNo3,
                        "waterAnal": sitePreparation[i]["waterAnly"],
                        "waterPhoto": referenceNo4,
                        "blockId": sitePreparation[i]["blockId"],
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("SitePreparationReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('sitePreparation', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnLandPreparation) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValueLand" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnLandPreparation,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> landPreparation = await db.RawQuery(
                      "SELECT txnDate,recNo,isSynched,farmerId,farmId,doe,blockId FROM landPreparation where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");
                  List<String> landPreparationDetailList = [];
                  List<Map> landPreparationList = await db.RawQuery(
                      "select recNo,activity,mode,noOfLab from landPreparationDet WHERE recNo='" +
                          custTxnsRefId +
                          "';");

                  for (int j = 0; j < landPreparationList.length; j++) {
                    var reqLandPreparation = jsonEncode({
                      "activity": landPreparationList[j]["activity"],
                     // "mode": landPreparationList[j]["mode"],
                      "noOfLab": landPreparationList[j]["noOfLab"],
                    });
                    landPreparationDetailList.add(reqLandPreparation);
                  }

                  for (int i = 0; i < landPreparation.length; i++) {
                    var reqdata = jsonEncode({
                      "body": {
                        "pcTime": landPreparation[i]["txnDate"],
                        "recNo": landPreparation[i]["recNo"],
                        "farmerId": landPreparation[i]["farmerId"],
                        "farmId": landPreparation[i]["farmId"],
                        "blockId": landPreparation[i]["blockId"],
                        "eDate": landPreparation[i]["doe"],
                        "activityList":
                            jsonDecode(landPreparationDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("LandPreparationReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];
                    if (code.toString() == '00') {
                      db.UpdateTableValue('landPreparation', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnBlockRegistration) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValue_planting" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";
                  print("BlockRegistrationQry" + headerqry.toString());

                  List<Map> headerList = await db.RawQuery(headerqry);
                  print("headerList_headerList" + headerList.toString());
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnBlockRegistration,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);

                  List<Map> blockAreaList = await db.RawQuery(
                      "SELECT farmerId,farmId ,farmId,blockId,season,recNo,isSynched,blockArea,blockName,txnDate  FROM blockDetails where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");

                  String farmerId = "", farmId = "", recNo = "", blockId = "";
                  for (int k = 0; k < blockAreaList.length; k++) {
                    farmerId = blockAreaList[k]['farmerId'];
                    farmId = blockAreaList[k]['farmId'];
                    blockId = blockAreaList[k]['blockId'];
                    recNo = blockAreaList[k]['recNo'];
                  }

                  List<String> blockAreaJsonList = [];
                  List<Map> blockAreaPlottingList = await db.RawQuery(
                      "select longitude,latitude,OrderOFGPS ,reciptId from block_GPSLocation_Details WHERE farmerId='" +
                          farmerId +
                          "' AND farmId ='" +
                          farmId +
                          "' and reciptId='" +
                          recNo +
                          "' and blockId='" +
                          blockId +
                          "' order by OrderOFGPS;");
                  print("qryBlockPlotting" +
                      "select longitude,latitude,OrderOFGPS ,reciptId from block_GPSLocation_Details WHERE farmerId='" +
                      farmerId +
                      "' AND farmId ='" +
                      farmId +
                      "' and reciptId='" +
                      recNo +
                      "' and blockId='" +
                      blockId +
                      "' order by OrderOFGPS;");

                  print("blockAreaPlottingList" +
                      blockAreaPlottingList.toString());
                  for (int j = 0; j < blockAreaPlottingList.length; j++) {
                    var reqBlockPlotting = jsonEncode({
                      "laLon": blockAreaPlottingList[j]["longitude"],
                      "laLat": blockAreaPlottingList[j]["latitude"],
                      "orderNo":
                          blockAreaPlottingList[j]["OrderOFGPS"].toString(),
                    });
                    blockAreaJsonList.add(reqBlockPlotting);
                  }

                  for (int j = 0; j < blockAreaList.length; j++) {
                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": blockAreaList[j]["farmerId"],
                        "farmCode": blockAreaList[j]["farmId"],
                        "blockname": blockAreaList[j]["blockName"],
                        "cultiArea": blockAreaList[j]["blockArea"],
                        "blockId": blockAreaList[j]["blockId"],
                        "pcTime": blockAreaList[j]["txnDate"],
                        "seasonCode": blockAreaList[j]["season"],
                        "lAgps": jsonDecode(blockAreaJsonList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("BlockReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('blockDetails', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnPlanting) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValue_planting" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";
                  print("plantingHeaderQry" + headerqry.toString());

                  List<Map> headerList = await db.RawQuery(headerqry);
                  print("headerList_headerList" + headerList.toString());
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnPlanting,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);

                  List<Map> existFarmerList = await db.RawQuery(
                      "SELECT recId,farmerId as farmerId,farmId as farmCode,farmertimeStamp as pcTime,farmlatitude as fLat,farmlongitude as fLon,farmtimeStamp as fpcTime,prodLand as landProd,notProdLand as landNProd, currentSeason as cSeasonCode FROM exists_farmer where isSynched = 0 and recId = '" +
                          custTxnsRefId +
                          "';");

                  String farmerId = "", farmId = "", recId = "";
                  for (int k = 0; k < existFarmerList.length; k++) {
                    farmerId = existFarmerList[k]['farmerId'];
                    farmId = existFarmerList[k]['farmCode'];
                    recId = existFarmerList[k]['recId'];
                  }
                  List<Map> farmCropList = await db.RawQuery(
                      "SELECT cropCount,farmerId,farmCodeRef, blockName,blockArea,blockId,cropCode,cropVariety,cropgrade,seedType,dateOfSown,seedLotNo,borderCropType ,seedTreatment,seedCheQty,otherSeedTreatment,seedQty,fertilizer,fertiType,fertiLotNo,fertiQty,unit,expWeek,mode,production,cropSeason,cropCategory,reciptId,estHarvestDt ,plantWeek,farmcrpIDT as plantingId FROM farmCropExists  WHERE farmerId='" +
                          farmerId +
                          "' AND farmCodeRef ='" +
                          farmId +
                          "' and reciptId ='" +
                          recId +
                          "';");
                  print("farmCropList_farmCropList" + farmCropList.toString());

                  String farmCode = "", farmer = "", receiptId = "";
                  for (int k = 0; k < farmCropList.length; k++) {
                    farmCode = farmCropList[k]['farmCodeRef'];
                    receiptId = farmCropList[k]['reciptId'];
                    farmer = farmCropList[k]['farmerId'];
                  }

                  List<String> farmCropLocationJsonList = [];
                  List<Map> farmCropLocationList = await db.RawQuery(
                      "select longitude,latitude,OrderOFGPS from farmCrop_GPSLocation_Exists WHERE farmerId='" +
                          farmer +
                          "' AND farmId ='" +
                          farmCode +
                          "' and reciptId='" +
                          receiptId +
                          "' order by OrderOFGPS;");

                  print(
                      "farmCropLocationList" + farmCropLocationList.toString());
                  for (int j = 0; j < farmCropLocationList.length; j++) {
                    var reqfarmCropLocation = jsonEncode({
                      "laLon": farmCropLocationList[j]["longitude"],
                      "laLat": farmCropLocationList[j]["latitude"],
                      "orderNo":
                          farmCropLocationList[j]["OrderOFGPS"].toString(),
                    });
                    farmCropLocationJsonList.add(reqfarmCropLocation);
                  }

                  for (int j = 0; j < farmCropList.length; j++) {
                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": farmCropList[j]["farmerId"],
                        "farmCode": farmCropList[j]["farmCodeRef"],
                        "blockname": farmCropList[j]["blockName"],
                        "cultiArea": farmCropList[j]["blockArea"],
                        "blockId": farmCropList[j]["blockId"],
                        "seasonCode": farmCropList[j]["cropSeason"],
                        "variety": farmCropList[j]["cropVariety"],
                        "grade": farmCropList[j]["cropgrade"],
                        "seedSource": farmCropList[j]["seedType"],
                        "plantingDate": farmCropList[j]["dateOfSown"],
                        "lotNo": farmCropList[j]["seedLotNo"],
                        "cropCat": farmCropList[j]["borderCropType"],
                        "chemUsed": farmCropList[j]["seedTreatment"],
                        "fieldType": farmCropList[j]["otherSeedTreatment"],
                        "chemQty": farmCropList[j]["seedCheQty"],
                        "seedQtyPlanted": farmCropList[j]["seedQty"],
                        "seedWeek": farmCropList[j]["plantWeek"],
                        "fert": farmCropList[j]["fertilizer"],
                        "tyFert": farmCropList[j]["fertiType"],
                        "fLotNo": farmCropList[j]["fertiLotNo"],
                        "fertQty": farmCropList[j]["fertiQty"],
                        "unit": farmCropList[j]["unit"],
                        "modeApp": farmCropList[j]["mode"],
                        "expHarvestWeek": farmCropList[j]["expWeek"],
                        "expHarvestQty": farmCropList[j]["production"],
                        "plantingId": farmCropList[j]["plantingId"],
                        "cropCount": farmCropList[j]["cropCount"],
                        "lAgps":
                            jsonDecode(farmCropLocationJsonList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("plantingReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('exists_farmer', 'isSynched', '1',
                          'recId', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnHarvest) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  print("ipAddressValue_harvest" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  var db = DatabaseHelper();
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);

                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": datas.txnHarvest,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  int resentCount = int.parse(headerList[0]['resentCount']);
                  resentCount = resentCount + 1;
                  print('resentCount: ' + resentCount.toString());
                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ:' + succ.toString());

                  List<Map> harvestList = await db.RawQuery(
                      'select * from cropHarvest where isSynched = 0 and recNo=\'' +
                          custTxnsRefId +
                          '\'');

                  /*print('sprayListCount' + sprayList.length.toString());*/
                  for (int i = 0; i < harvestList.length; i++) {
                    String farmerId = harvestList[i]['farmerId'].toString();
                    String farmId = harvestList[i]['farmId'].toString();
                    String blockId = harvestList[i]['blockId'].toString();
                    String plantingId = harvestList[i]['plantingId'].toString();
                    String harvestDate =
                        harvestList[i]['harvestDate'].toString();
                    String noofStem = harvestList[i]['noofStem'].toString();
                    String quantityharvested =
                        harvestList[i]['quantityharvested'].toString();
                    String harvestedYields =
                        harvestList[i]['harvestedYields'].toString();
                    String expectedYield =
                        harvestList[i]['expectedYield'].toString();
                    String harvesterName =
                        harvestList[i]['harvesterName'].toString();
                    String harvestEquipment =
                        harvestList[i]['harvestEquipment'].toString();
                    String NofUnits = harvestList[i]['NofUnits'].toString();
                    String packingUnit =
                        harvestList[i]['packingUnit'].toString();
                    String colCenter = harvestList[i]['colCenter'].toString();
                    String produceId = harvestList[i]['produceId'].toString();
                    String phiObservation =
                        harvestList[i]['phiObservation'].toString();
                    String season = harvestList[i]['season'].toString();
                    String recNo = harvestList[i]['recNo'].toString();
                    String weightType = harvestList[i]['weightType'].toString();

                    var reqdata = jsonEncode({
                      "body": {
                        "farmerId": farmerId,
                        "farmCode": farmId,
                        "plantingId": plantingId,
                        "blockId": blockId,
                        "date": harvestDate,
                        "noStems": noofStem,
                        "qtyHvst": quantityharvested,
                        "yldHvst": harvestedYields,
                        "expVol": expectedYield,
                        "nmeHvst": harvesterName,
                        "eqpHvst": harvestEquipment,
                        "noUnts": NofUnits,
                        "pkUnt": packingUnit,
                        "obsPhi": phiObservation,
                        "season": season,
                        "recNo": recNo,
                        "weightType": weightType,
                      },
                      "head": jsonDecode(headdata),
                    });
                    printWrapped('HarvestReqData:' + reqdata.toString());
                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    printWrapped("CHECKRESPONSE " + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('cropHarvest', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {}
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txn_sorting) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  print("ipAddressValue_sorting" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  var db = DatabaseHelper();
                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);

                  print('txnexecutor headerList ' + headerList.toString());
                  print('txnexecutor headerList ' + headerqry);

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": datas.txn_sorting,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  int resentCount = int.parse(headerList[0]['resentCount']);
                  resentCount = resentCount + 1;
                  print('resentCount: ' + resentCount.toString());
                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ:' + succ.toString());

                  List<Map> sortList = await db.RawQuery(
                      'select * from sorter where isSynched = 0 and recNo=\'' +
                          custTxnsRefId +
                          '\'');

                  /*print('sprayListCount' + sprayList.length.toString());*/
                  for (int i = 0; i < sortList.length; i++) {
                    String sorDate = sortList[i]['sorDate'].toString();
                    String farmerId = sortList[i]['farmerId'].toString();
                    String farmId = sortList[i]['farmId'].toString();
                    String rejectedqty = sortList[i]['rejectedqty'].toString();
                    String sortedqty = sortList[i]['sortedqty'].toString();
                    String recNo = sortList[i]['recNo'].toString();
                    int isSynched = sortList[i]['isSynched'];
                    String season = sortList[i]['season'].toString();
                    String blockId = sortList[i]['blockId'].toString();
                    String plantingId = sortList[i]['plantingId'].toString();
                    String harvestDate = sortList[i]['harvestDate'].toString();
                    String harvestqty = sortList[i]['harvestqty'].toString();
                    String truckType = sortList[i]['truckType'].toString();
                    String truckNumber = sortList[i]['truckNumber'].toString();
                    String driverName = sortList[i]['driverName'].toString();
                    String driverNo = sortList[i]['driverNo'].toString();

                    var reqdata = jsonEncode({
                      "body": {
                        "sorDate": sorDate,
                        "farmerId": farmerId,
                        "farmcode": farmId,
                        "plantingId": plantingId,
                        "blockId": blockId,
                        "harDate": harvestDate,
                        "harQty": harvestqty,
                        "rejQty": rejectedqty,
                        "netQty": sortedqty,
                        "season": season,
                        "recNo": recNo,
                        "trType": truckType,
                        "trNo": truckNumber,
                        "drName": driverName,
                        "drCt": driverNo,
                        "QRCodeUnq": recNo,
                      },
                      "head": jsonDecode(headdata),
                    });
                    printWrapped('sortReqData1:' + reqdata.toString());
                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);
                    printWrapped("CHECKRESPONSE " + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      print("sortingResponseIF");
                      db.UpdateTableValue(
                          'sorter', 'isSynched', '1', 'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {
                      print("sortingResponseElse");
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnIncomingShipment) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("incomingTxnId" + custTxnsRefId.toString());
                  print("custTransactionsLengthValue" + i.toString());

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnIncomingShipment,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> productReception = await db.RawQuery(
                      "SELECT txnDate,recNo,batchNo,isSynched,pHouseId,totWeight,truckType,truckNumber,driverName,driverNo,driverNote,season FROM productReception where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");
                  print("productReception_Value" + productReception.toString());
                  List<String> productReceptionDetailList = [];
                  List<Map> productReceptionList = await db.RawQuery(
                      "select sortingId,qrUniqId,plantingId,lossWt,batchNo, recNo,blockId,pCode,vCode,transWt,recWt,recUnit,noOfUnit from productReceptionDetails WHERE recNo='" +
                          custTxnsRefId +
                          "';");

                  for (int j = 0; j < productReceptionList.length; j++) {
                    var reqIncoming = jsonEncode({
                      "plantingId": productReceptionList[j]["plantingId"],
                      "prodCode": productReceptionList[j]["pCode"],
                      "VarietyCode": productReceptionList[j]["vCode"],
                      "trWt": productReceptionList[j]["transWt"],
                      "recWt": productReceptionList[j]["recWt"],
                      "lossWt": productReceptionList[j]["lossWt"],
                      "uom": productReceptionList[j]["recUnit"],
                      "noOfBag": productReceptionList[j]["noOfUnit"],
                      "QRCodeUnq": productReceptionList[j]["qrUniqId"],
                      "sortingId": productReceptionList[j]["sortingId"],
                    });
                    productReceptionDetailList.add(reqIncoming);
                  }

                  print(
                      "productReceptionList" + productReceptionList.toString());

                  for (int i = 0; i < productReception.length; i++) {
                    print("productReception_length" +
                        productReceptionList.length.toString());
                    var reqdata = jsonEncode({
                      "body": {
                        "date": productReception[i]["txnDate"],
                        "packhouse": productReception[i]["pHouseId"],
                        "totWt": productReception[i]["totWeight"],
                        "trType": productReception[i]["truckType"],
                        "trNo": productReception[i]["truckNumber"],
                        "drName": productReception[i]["driverName"],
                        "drCt": productReception[i]["driverNo"],
                        "batchNo": productReception[i]["batchNo"],
                        "productList":
                            jsonDecode(productReceptionDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("IncomingShipmentReq" + reqdata);

                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    printWrapped(
                        "IncomingShipmentResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('productReception', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {
                      print('incomingelse ' + code.toString());
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }

              else if (txnConfigId == datas.txnProductTransfer) {
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  String custTxnsRefId =
                  custTransactions[i]["txnRefId"].toString();
                  print("ProductTransferID" + custTxnsRefId.toString());
                  print("custTransactionsLengthValue" + i.toString());

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnProductTransfer,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                    headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> productTransfer = await db.RawQuery(
                      "SELECT transferDate,exporter,transferFrom,transferTo,truck,driver,licenseNo,transferID ,recNo FROM transferProduct where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");
                  print("productTransferValue" + productTransfer.toString());
                  List<String> productTransferDetailList = [];
                  List<Map> productTransferList = await db.RawQuery(
                      "select availableWt,batchNo,blockId,plantingId,pCode,vCode, transWt from transferProductDetail WHERE recNo='" +
                          custTxnsRefId +
                          "';");

                  for (int j = 0; j < productTransferList.length; j++) {
                    var reqIncoming = jsonEncode({
                      "batchNo": productTransferList[j]["batchNo"],
                      "blockId": productTransferList[j]["blockId"],
                      "plantingId": productTransferList[j]["plantingId"],
                      "product": productTransferList[j]["pCode"],
                      "variety": productTransferList[j]["vCode"],
                      "transWt": productTransferList[j]["transWt"],
                      "avlWT": productTransferList[j]["availableWt"],

                    });
                    productTransferDetailList.add(reqIncoming);
                  }

                  print(
                      "productTransferList" + productTransferList.toString());

                  for (int i = 0; i < productTransfer.length; i++) {
                    print("productTransfer_length" +
                        productTransfer.length.toString());
                    var reqdata = jsonEncode({
                      "body": {
                        "tDate": productTransfer[i]["transferDate"],
                        "exporter": productTransfer[i]["exporter"],
                        "from": productTransfer[i]["transferFrom"],
                        "To": productTransfer[i]["transferTo"],
                        "truckNo": productTransfer[i]["truck"],
                        "drName": productTransfer[i]["driver"],
                        "license": productTransfer[i]["licenseNo"],
                        "transferId": productTransfer[i]["transferID"],
                        "transferList":
                        jsonDecode(productTransferDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("ProductTransferReq" + reqdata);

                    Response response =
                    await Dio().post(decTxnUrl, data: reqdata);

                    printWrapped(
                        "ProductTransferResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue('transferProduct', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                    db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {
                      print('productTransferelse ' + code.toString());
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }

              else if (txnConfigId == datas.txnProductReception) {
                  print("trycatchReception");
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }
                  String custTxnsRefId =
                  custTransactions[i]["txnRefId"].toString();
                  print("ProductReceptionID" + custTxnsRefId.toString());
                  print("ProductReceptionIDLength" + i.toString());

                  String headerqry =
                      "select * from txnHeader where txnRefId like '%" +
                          custTxnsRefId +
                          "%';";

                  List<Map> headerList = await db.RawQuery(headerqry);
                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken": headerList[0]['agentToken'],
                    "txnType": datas.txnProductReception,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'],
                    "resentCount":
                    headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId": headerList[0]['servPointId'],
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';
                  int succ = await db.RawUpdate(updateqry);
                  print('succ' + succ.toString());

                  List<Map> receptionProduct = await db.RawQuery(
                      "SELECT recBatchNo,txnDate,recNo,isSynched,receiptId,transferDate,transferFrom,transferTo,truck,driver,licenseNo,recNo FROM receptionProduct where isSynched = 0 and recNo = '" +
                          custTxnsRefId +
                          "';");
                  print("ReceptionProductValue" + receptionProduct.toString());
                  List<String> receptionListDetailList = [];
                  List<Map> receptionList = await db.RawQuery(
                      "select recordNo,batchNo,blockId,plantingId,pCode,vCode, transWt,recWt,recNo from receptionProductDetail WHERE recordNo='" +
                          custTxnsRefId +
                          "';");

                  for (int j = 0; j < receptionList.length; j++) {
                    var reqIncoming = jsonEncode({
                     // "batchNo": receptionList[j]["batchNo"],
                      "blockId": receptionList[j]["blockId"],
                      "plantingId": receptionList[j]["plantingId"],
                      "product": receptionList[j]["pCode"],
                      "variety": receptionList[j]["vCode"],
                      "transWt": receptionList[j]["transWt"],
                      "recWt": receptionList[j]["recWt"],
                    });
                    receptionListDetailList.add(reqIncoming);
                  }

                  print(
                      "receptionList" + receptionList.toString());

                  for (int i = 0; i < receptionProduct.length; i++) {
                    print("receptionProduct_length" +
                        receptionProduct.length.toString());
                    var reqdata = jsonEncode({
                      "body": {
                        "receiptId": receptionProduct[i]["receiptId"],
                        "tDate": receptionProduct[i]["transferDate"],
                        "from": receptionProduct[i]["transferFrom"],
                        "To": receptionProduct[i]["transferTo"],
                        "truckNo": receptionProduct[i]["truck"],
                        "drName": receptionProduct[i]["driver"],
                        "license": receptionProduct[i]["licenseNo"],
                        "txnDate": receptionProduct[i]["txnDate"],
                        "batNo": receptionProduct[i]["recBatchNo"],
                        "receptionList":
                        jsonDecode(receptionListDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });
                    printWrapped("ReceptionProduct" + reqdata);


                    Response response =
                    await Dio().post(decTxnUrl, data: reqdata);

                    printWrapped(
                        "ReceptionProductResponse" + response.toString());

                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                          db.UpdateTableValue('receptionProduct', 'isSynched', '1',
                          'recNo', custTxnsRefId);
                     db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {
                      print('ReceptionProductelse ' + code.toString());
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }
              else if (txnConfigId == datas.txnPacking) {
                print("packingFunctionCalled");
                //try {
                String ipAddressValue = '';
                try {
                  final ipv4 = await Ipify.ipv4();
                  ipAddressValue = ipv4.toString();
                } catch (e) {
                  ipAddressValue = '';
                }

                String latitude = '', longitude = '';
                try {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  latitude = position.latitude.toString();
                  longitude = position.longitude.toString();
                } catch (e) {
                  latitude = '';
                  longitude = '';
                }

                print("ipAddressValue_packing" + ipAddressValue.toString());
                String custTxnsRefId =
                    custTransactions[i]["txnRefId"].toString();
                print("custTxnsRefIdPacking" + custTxnsRefId.toString());

                String headerqry =
                    "select * from txnHeader where txnRefId like '%" +
                        custTxnsRefId +
                        "%';";
                print("Header Qry Called");

                List<Map> headerList = await db.RawQuery(headerqry);
                print("headerList_packing" + headerList.length.toString());

                var headdata = jsonEncode({
                  "agentId": headerList[0]['agentId'],
                  "agentToken": headerList[0]['agentToken'],
                  "txnType": datas.txnPacking,
                  "txnTime": headerList[0]['txnTime'],
                  "operType": "01",
                  "mode": "02",
                  "msgNo": headerList[0]['msgNo'],
                  "resentCount":
                      headerList[0]['resentCount'].replaceAll(' ', ''),
                  "serialNo": serialnumber,
                  "servPointId": headerList[0]['servPointId'],
                  "branchId": appDatas.tenent,
                  "versionNo": versionlist[0] + "|" + DBVERSION!,
                  "fsTrackerSts": "2|1",
                  "tenantId": appDatas.tenent,
                  "ipAddress": ipAddressValue,
                  "lat": latitude,
                  "lon": longitude,
                });

                print('resentCount' +
                    headerList[0]['resentCount'] +
                    '->' +
                    custTxnsRefId);
                int resentCount = int.parse(headerList[0]['resentCount']);

                resentCount = resentCount + 1;
                print('resentCount' + resentCount.toString());

                String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                    resentCount.toString() +
                    '\' WHERE txnRefId LIKE "%' +
                    custTxnsRefId +
                    '%"';
                int succ = await db.RawUpdate(updateqry);
                print('succ_packing' + succ.toString());
                List<Map> packingList = await db.RawQuery(
                    "SELECT packingDate,packingId,lotNo,recNo,isSynched,packerName FROM packHouse where isSynched = 0 and recNo = '" +
                        custTxnsRefId +
                        "';");
                print("packing_Value" + packingList.toString());

                List<String> packingDetailList = [];
                List<Map> packing = await db.RawQuery(
                    "select qrUniqId,plantingId, farmerId, farmId,recBatchNo,blockId,pCode,vCode,actQty,packedQty,price,prodVal,bestBeforeDate,county,recNo,rejectedQty from packHouseDetails WHERE recNo='" +
                        custTxnsRefId +
                        "';");
                if (packing.length > 0) {
                  for (int j = 0; j < packing.length; j++) {
                    var reqPacking = jsonEncode({
                      "farmerId": packing[j]["farmerId"],
                      "farmId": packing[j]["farmId"],
                      "blockId": packing[j]["blockId"],
                      "resBatchNo": packing[j]["recBatchNo"],
                      "pCode": packing[j]["pCode"],
                      "vCode": packing[j]["vCode"],
                      "avlWt": packing[j]["actQty"],
                      "packWt": packing[j]["packedQty"],
                      "price": packing[j]["price"],
                      "productValue": packing[j]["prodVal"],
                      "bbDate": packing[j]["bestBeforeDate"],
                      "rejectWt": packing[j]["rejectedQty"],
                      "plantingId": packing[j]["plantingId"],
                      "QRCodeUnq": packing[j]["qrUniqId"],
                    });
                    packingDetailList.add(reqPacking);
                  }
                } else {
                  print("emptyPacking");
                }

                for (int i = 0; i < packingList.length; i++) {
                  print("packingList_length" + packingList.length.toString());
                  var reqdata = jsonEncode({
                    "body": {
                      "packDate": packingList[i]["packingDate"],
                      "packhouse": packingList[i]["packingId"],
                      "packerName": packingList[i]["packerName"],
                      "lotNo": packingList[i]["lotNo"],
                      "packingList": jsonDecode(packingDetailList.toString()),
                    },
                    "head": jsonDecode(headdata)
                  });
                  printWrapped("packingReceptionReq" + reqdata);

                  Response response =
                      await Dio().post(decTxnUrl, data: reqdata);

                  print("custTxnsRefId_Packing" + custTxnsRefId);
                  printWrapped(
                      "packingReceptionResponse" + response.toString());

                  final responsebody = json.decode(response.toString());
                  final jsonresponse = responsebody['Response'];
                  final statusobjectr = jsonresponse['status'];
                  final code = statusobjectr['code'];
                  final message = statusobjectr['message'];

                  if (code.toString() == '00') {
                    db.UpdateTableValue(
                        'packHouse', 'isSynched', '1', 'recNo', custTxnsRefId);
                    db.DeleteTableRecord(
                        'custTransactions', 'txnRefId', custTxnsRefId);

                    print('afterdelete packing' + custTxnsRefId.toString());
                  } else {
                    print('else code packing ' + code.toString());
                  }
                }

                //} catch (e) {
                //  print('packHouseException' + e.toString());
                //}
              }
              else if (txnConfigId == datas.txnShipment) {
                print("shipment called");
                try {
                  String ipAddressValue = '';
                  try {
                    final ipv4 = await Ipify.ipv4();
                    ipAddressValue = ipv4.toString();
                  } catch (e) {
                    ipAddressValue = '';
                  }

                  String latitude = '', longitude = '';
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  } catch (e) {
                    latitude = '';
                    longitude = '';
                  }

                  print("ipAddressValue_shipment" + ipAddressValue.toString());
                  String custTxnsRefId =
                      custTransactions[i]["txnRefId"].toString();
                  print("custTxnsRefId_Shipment" + custTxnsRefId.toString());

                  List<Map> shipment = await db.RawQuery(
                      'SELECT * from shipment where isSynched = \'0\'  and recNo = \'' +
                          custTxnsRefId +
                          '\';');

                  print("shipment_Value" + shipment.toString());

                  String headerqry =
                      "select * from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';";
                  List<Map> headerList = await db.RawQuery(headerqry);
                  print("headerListshipment" + headerList.length.toString());

                  var headdata = jsonEncode({
                    "agentId": headerList[0]['agentId'],
                    "agentToken":
                        headerList[0]['agentToken'].replaceAll(' ', ''),
                    "txnType": appDatas.txnShipment,
                    "txnTime": headerList[0]['txnTime'],
                    "operType": "01",
                    "mode": "02",
                    "msgNo": headerList[0]['msgNo'].replaceAll(' ', ''),
                    "resentCount":
                        headerList[0]['resentCount'].replaceAll(' ', ''),
                    "serialNo": serialnumber,
                    "servPointId":
                        headerList[0]['servPointId'].replaceAll(' ', ''),
                    "branchId": appDatas.tenent,
                    "versionNo": versionlist[0] + "|" + DBVERSION!,
                    "fsTrackerSts": "2|1",
                    "tenantId": appDatas.tenent,
                    "ipAddress": ipAddressValue,
                    "lat": latitude,
                    "lon": longitude,
                  });
                  print('headerData ' + headdata.toString());

                  print('resentCount' +
                      headerList[0]['resentCount'] +
                      '->' +
                      custTxnsRefId);
                  int resentCount = int.parse(headerList[0]['resentCount']);

                  resentCount = resentCount + 1;
                  print('resentCount' + resentCount.toString());

                  String updateqry = 'UPDATE txnHeader SET resentCount =\'' +
                      resentCount.toString() +
                      '\' WHERE txnRefId LIKE "%' +
                      custTxnsRefId +
                      '%"';

                  print('updateqry_shipment' + updateqry.toString());
                  int succ = await db.RawUpdate(updateqry);
                  print('succ_resetCount' + succ.toString());

                  print(
                      "select resentCount from txnHeader where txnRefId  like '%" +
                          custTxnsRefId +
                          "%';" '');

                  List<String> shipmentDetailList = [];
                  List<Map> shipmentList = await db.RawQuery(
                      "select plantingId, lotNo, produce,variety,lotQty,packUnit,packQty,recNo,blockId from shipmentDetails WHERE recNo='" +
                          custTxnsRefId +
                          "';");
                  print("shipmentListshipmentList" + shipmentList.toString());

                  List<Map> shipmentDocList = await db.RawQuery(
                      "select docName, docPath, recNo from shipmentDocDetails WHERE recNo='" +
                          custTxnsRefId +
                          "';");

                  List refNumbers = [];

                  try{
                    if(shipmentDocList.isNotEmpty){
                      for (int j = 0; j < shipmentDocList.length; j++) {
                        Random rnd = new Random();
                        int refNo = 100000 + rnd.nextInt(999999 - 100000);
                        String referenceNo = refNo.toString();
                        File docImage = File(shipmentDocList[j]["docPath"]);

                        refNumbers.add(referenceNo);
                        String fileName = docImage!.path.split('/').last;
                        print('fileName-- ' + fileName.toString());

                        final nameWithoutExtension = basenameWithoutExtension(docImage.path);

                        print('nameWithoutExtension' +nameWithoutExtension);
                        print('name--path' +docImage!.path);


                        FormData formData = FormData.fromMap({
                          "file": await MultipartFile.fromFile(
                            docImage!.path,
                            filename: fileName,
                          ),
                          "reference": referenceNo
                        });



                        Response response = await Dio().post(imageUploadTxn, data: formData);
                        final responsebody = json.decode(response.toString());
                        final jsonresponse = responsebody['Response'];
                        final statusobjectr = jsonresponse['status'];
                        final code = statusobjectr['code'];
                        final message = statusobjectr['message'];
                        printWrapped("photo_uploadStatus" + message + j.toString());

                      }
                    }
                    print('refNumber' +refNumbers.toString());
                  }catch(e){
                    print('docsException' +e.toString());
                  }

                  // List<String> shipmentDocDetailList = [];
                  // List<Map> shipmentDocList = await db.RawQuery(
                  //     "select docName, docPath, recNo from shipmentDocDetails WHERE recNo='" +
                  //         custTxnsRefId +
                  //         "';");
                  //
                  // for (int j = 0; j < shipmentDocList.length; j++) {
                  //   File docImage = File(shipmentDocList[j]["docPath"]);
                  //
                  //   print('docImage--' +docImage.toString());
                  //   List<int> imageBytes = docImage.readAsBytesSync();
                  //   String docPhoto = base64Encode(imageBytes);
                  //   print('fPhoto--' +docPhoto);
                  //
                  //   var reqShipment = jsonEncode({
                  //     "docPath": docPhoto
                  //   });
                  //   shipmentDocDetailList.add(reqShipment);
                  // }
                  //


                  for (int j = 0; j < shipmentList.length; j++) {
                    var reqShipment = jsonEncode({
                      "lotNo": shipmentList[j]["lotNo"],
                      "blockId": shipmentList[j]["blockId"],
                      "lotQty": shipmentList[j]["lotQty"],
                      "packUnit": shipmentList[j]["packUnit"],
                      "packQty": shipmentList[j]["packQty"],
                      "plantingId": shipmentList[j]["plantingId"],
                    });
                    shipmentDetailList.add(reqShipment);
                  }

                  for (int i = 0; i < shipment.length; i++) {
                    print("shipment_length" + shipment.length.toString());
                    var reqdata = jsonEncode({
                      "body": {
                        "shipDate": shipment[i]["shipDate"],
                        "packhouse": shipment[i]["packHouseId"],
                        "expLicNo": shipment[i]["expLicNo"],
                        "consignNo": shipment[i]["consNo"],
                        "totalQty": shipment[i]["totQty"],
                        "buyer": shipment[i]["buyer"],
                        "traceCode": shipment[i]["traceCode"],
                        "QRCodeUnq": shipment[i]["recNo"],
                        // "shipmentDestination": shipment[i]["destinationCode"],
                        "shipmentList":
                            jsonDecode(shipmentDetailList.toString()),
                        "shipmentDocuments":refNumbers,
                        // "shipmentDocList":
                        //  jsonDecode(shipmentDocDetailList.toString()),
                      },
                      "head": jsonDecode(headdata)
                    });

                    printWrapped("shipmentReq " + reqdata.toString());
                    Response response =
                        await Dio().post(decTxnUrl, data: reqdata);

                    printWrapped('Shipmentresponse' + response.toString());
                    final responsebody = json.decode(response.toString());
                    final jsonresponse = responsebody['Response'];
                    final statusobjectr = jsonresponse['status'];
                    final code = statusobjectr['code'];
                    final message = statusobjectr['message'];

                    if (code.toString() == '00') {
                      db.UpdateTableValue(
                          'shipment', 'isSynched', '1', 'recNo', custTxnsRefId);
                      db.DeleteTableRecord(
                          'custTransactions', 'txnRefId', custTxnsRefId);
                    } else {
                      print('else code shipment' + code.toString());
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }
              else {
                await SecureStorage().writeSecureData("isRunning", "0");
                runningValue = await SecureStorage().readSecureData("isRunning");
                print("running Else condition" + runningValue.toString());
              }
              if (i + 1 == custTransactions.length) {
                await SecureStorage().writeSecureData("isRunning", "0");
              }

              runningValue = await SecureStorage().readSecureData("isRunning");
              print("forLooPIsRunninglast" + runningValue.toString());
            }
          } else {
            runningValue = await SecureStorage().readSecureData("isRunning");
            print('Offline or is running' + runningValue.toString());
          }
        } catch (e) {
          print(e);
          runningValue = await SecureStorage().readSecureData("isRunning");
          print('Catch' + runningValue.toString());
        }
      } else {
        await SecureStorage().writeSecureData("isRunning", "0");
        runningValue = await SecureStorage().readSecureData("isRunning");
      }
      //}
    } catch (Exception) {
      print("txnexecutor err 316" + Exception.toString());
      // toast('Executor Error ' + Exception.toString());
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }


}

Future<void> sendDocToMultipart(String referenceNo, File docImage, int j) async{

  String fileName = docImage!.path.split('/').last;
  print('fileName-- ' + fileName.toString());

  String imageUploadTxn = await SecureStorage().decryptAES(appDatas.ImageUploadUrl);
  //print("imageUploadTxn:"+imageUploadTxn);

  final nameWithoutExtension = basenameWithoutExtension(docImage.path);

  print('nameWithoutExtension' +nameWithoutExtension);
  print('name--path' +docImage!.path);



  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      docImage!.path,
      filename: fileName,
    ),
    "reference": referenceNo
  });

  Response response = await Dio().post(imageUploadTxn, data: formData);
  final responsebody = json.decode(response.toString());
  final jsonresponse = responsebody['Response'];
  final statusobjectr = jsonresponse['status'];
  final code = statusobjectr['code'];
  final message = statusobjectr['message'];
  printWrapped("photo_uploadStatus" + message + j.toString());
}

// Future<void> sendDocToMultipart(String referenceNo, String custTxnsRefId) async{
//   List<Map> shipmentDocList = await db.RawQuery(
//       "select docName, docPath, recNo from shipmentDocDetails WHERE recNo='" +
//           custTxnsRefId +
//           "';");
//
//   var formData = FormData.fromMap({
//     "reference": referenceNo
//   });
//
//   for (int j = 0; j < shipmentDocList.length; j++) {
//     File docImage = File(shipmentDocList[j]["docPath"]);
//     print('docImageDc--' +docImage.toString());
//     String fileName = docImage!.path.split('/').last;
//     print('fileNameDC-- ' + fileName.toString());
//     String fileNameKey = "file"+(j+1).toString();
//     formData.files.addAll([
//       MapEntry(
//         fileNameKey, await MultipartFile.fromFile(
//           docImage!.path,
//           filename: fileName
//       ),
//       )
//     ]);
//   }
//
//   formData.files.forEach((element) {
//     print('id: ${element.key}, title: ${element.value.filename}');
//
//   });
//
//
//   Response response = await Dio().post(appDatas.ImageUploadUrl, data: formData);
//   final responsebody = json.decode(response.toString());
//   printWrapped("docs_uploadStatus" + responsebody);
//
//   final jsonresponse = responsebody['Response'];
//   final statusobjectr = jsonresponse['status'];
//   final code = statusobjectr['code'];
//   final message = statusobjectr['message'];
//   printWrapped("docs_uploadStatus" + message);
//
// }


Future<void> uploadImage(String referenceNo, File imageFile) async {
  String fileName = imageFile!.path.split('/').last;
  print('fileName-- ' + fileName.toString());

  String imageUploadTxn = await SecureStorage().decryptAES(appDatas.ImageUploadUrl);
  //print("imageUploadTxn:"+imageUploadTxn);

  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      imageFile!.path,
      filename: fileName,
    ),
    "reference": referenceNo
  });

  Response response = await Dio().post(imageUploadTxn, data: formData);
  final responsebody = json.decode(response.toString());
  final jsonresponse = responsebody['Response'];
  final statusobjectr = jsonresponse['status'];
  final code = statusobjectr['code'];
  final message = statusobjectr['message'];
  printWrapped("photo_uploadStatus" + message);
}
