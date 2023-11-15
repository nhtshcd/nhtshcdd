import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/secure_storage.dart';
import 'package:nhts/main.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:package_info/package_info.dart';
//import 'package:shared_preferences/shared_preferences.dart';



class restplugin {
  AppDatas appDatas = new AppDatas();
  var db = DatabaseHelper();


  Future<String> loginApi(String username, String Password) async {

    String getUserName=username.trim();
    String getPassword=Password.trim();
    String userPsw = getUserName + getPassword;
    final key = 'STRACE@12345SAKTHIATHISOURCETRACE';


    print("username:"+username+Password);

   // String token = JwtHS256(userPsw, key);
    String token = await SecureStorage().encryptAES(userPsw);

   /* String txnurl = await SecureStorage().encryptAES(appDatas.TXN_URLs);
    String imageuploadurl = await SecureStorage().encryptAES(appDatas.ImageUploadUrls);
    String shipmentUrl = await SecureStorage().encryptAES(appDatas.shipmentUCRUrls);
    String apkdownloadUrl = await SecureStorage().encryptAES(appDatas.apkdownloadurls);
     String dbdownloadurl = await SecureStorage().encryptAES(appDatas.DBdownloadurls);*/
    //String latestversion = await SecureStorage().encryptAES(appDatas.LatestVersionURLs);

    // print("txnurl:"+txnurl);
    // print("imgupload:"+imageuploadurl);
    // print("shipment:"+shipmentUrl);
    // print("apkdownload:"+apkdownloadUrl);
    //  print("dbdownload:"+dbdownloadurl);
    //print("latestversion:"+latestversion);

    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
   /* String deTxnUrl = await SecureStorage().decryptAES(txnurl);
    String deimgUrl = await SecureStorage().decryptAES(imageuploadurl);
    String shipurl = await SecureStorage().decryptAES(shipmentUrl);
    String apkurl = await SecureStorage().decryptAES(apkdownloadUrl);
    String dbdownurl = await SecureStorage().decryptAES(dbdownloadurl);*/
    //String latestv = await SecureStorage().decryptAES(latestversion);

    // print("txnurl:"+deTxnUrl);
    // print("imgupload:"+deimgUrl);
    // print("shipment:"+shipurl);
    // print("apkdownload:"+apkurl);
    // print("dbdownload:"+dbdownurl);
   // print("latestversion:"+latestv);








    await SecureStorage().writeSecureData("agentId", getUserName);
    await SecureStorage().writeSecureData("agentToken", token);
    String serialnumber =  await SecureStorage().readSecureData("serialnumber");
    //print("serialnumber " + serialnumber!);
    String _modelNumber = await getModelNumber();
    String _androidversion = await getAndroidVersion();

    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    //print("agentToken :" + token);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();
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
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");
    List<Map> agents;
    String seasoncode;
    String servicePointId;
    String agentName;
    String pricePatternRev = "0";
    String locationRev = "0";
    String fieldStaffRev = "0";
    String farmerOutStandBalRev = "0";
    String productDwRev = "0";
    String seasonDwRev = "0";
    String farmCrpDwRev = "0";
    String procurementProdDwRev = "0";
    String villageWareHouseDwRev = "0";
    String gradeDwRev = "0";
    String wareHouseStockDwRev = "0";
    String coOperativeDwRev = "0";
    String buyerDwRev = "0";
    String supplierDwRev = "0";
    String eventDwRev = "0";
    String catalogDwRev = "0";
    String researchStationDwRev = "0";
    String plannerRev = "0";
    String farmerStockBalRev = "0";
    String dynamicDwRev = "0";
    String followUpRevNo = "0";
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    if (agents.isEmpty) {
      seasoncode = "";
      servicePointId = "";
      agentName = "";
    } else {
      seasoncode = agents[0]['currentSeasonCode'].toString();
      servicePointId = agents[0]['servicePointId'].toString();
      agentName = agents[0]['agentName'].toString();
      pricePatternRev = agents[0]['pricePatternRev'].toString();
      locationRev = agents[0]['locationRev'].toString();
      fieldStaffRev = agents[0]['fieldStaffRev'].toString();
      farmerOutStandBalRev = agents[0]['farmerOutStandBalRev'].toString();
      productDwRev = agents[0]['productDwRev'].toString();
      seasonDwRev = agents[0]['seasonDwRev'].toString();
      farmCrpDwRev = agents[0]['farmCrpDwRev'].toString();
      procurementProdDwRev = agents[0]['procurementProdDwRev'].toString();
      villageWareHouseDwRev = agents[0]['villageWareHouseDwRev'].toString();
      gradeDwRev = agents[0]['gradeDwRev'].toString();
      wareHouseStockDwRev = agents[0]['wareHouseStockDwRev'].toString();
      coOperativeDwRev = agents[0]['coOperativeDwRev'].toString();
      buyerDwRev = agents[0]['buyerDwRev'].toString();
      supplierDwRev = agents[0]['supplierDwRev'].toString();
      eventDwRev = agents[0]['eventDwRev'].toString();
      catalogDwRev = agents[0]['catalogDwRev'].toString();
      researchStationDwRev = agents[0]['researchStationDwRev'].toString();
      plannerRev = agents[0]['plannerRev'].toString();
      farmerStockBalRev = agents[0]['farmerStockBalRev'].toString();
      dynamicDwRev = agents[0]['dynamicDwRev'].toString();
      followUpRevNo = agents[0]['followUpRevNo'].toString();
    }

    var data2 = jsonEncode({
      "body": {
        "ppRevNo": pricePatternRev,
        "lRevNo": locationRev,
        "fsRevNo": fieldStaffRev,
        "fobRevNo": farmerOutStandBalRev,
        "prodRevNo": productDwRev,
        "seasonRevNo": seasonDwRev,
        "fcmRevNo": farmCrpDwRev,
        "procProdRevNo": procurementProdDwRev,
        "vwsRevNo": villageWareHouseDwRev,
        "gRevNo": gradeDwRev,
        "wsRevNo": wareHouseStockDwRev,
        "coRevNo": coOperativeDwRev,
        "byrRevNo": buyerDwRev,
        "supRevNo": supplierDwRev,
        "eventRevNo": eventDwRev,
        "catRevNo": catalogDwRev,
        "resStatRevNo": researchStationDwRev,
        "cSeasonCode": seasoncode,
        "agroVersion": "1",
        "plannerRevNo": plannerRev,
        "stRevNo": farmerStockBalRev,
        "dynLatestRevNo": dynamicDwRev,
        "followUpRevNo": followUpRevNo,
        "androidVersion": _androidversion,
        "mobileModel": _modelNumber
      },
      "head": {
        "agentId": username.trim(),
        "agentToken": token,
        "txnType": "301",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": servicePointId,
        "branchId": "",
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
    });
    printWrapped("LoginRequest " + data2.toString());



    Response response = await Dio().post(decTxnUrl, data: data2);
    print('loginApi ' + response.toString());
    return response.toString();
  }

  Future<String> OnlineFormerDownload() async {
    String? agentid =  await SecureStorage().readSecureData("agentId");
    String? agentToken =  await SecureStorage().readSecureData("agentToken");
    String? serialnumber =  await SecureStorage().readSecureData("serialnumber");
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");
    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "farmerRevNo", "value": "0"}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken": agentToken,
          "txnType": "315",
          "operType": "01",
          "txnTime": formatter,
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": serialnumber,
          "versionNo": versionlist[0] + "|" + DBVERSION!,
          "fsTrackerSts": "0|1",
          "tenantId": appDatas.tenent,
          "mobileModel": _modelNumber
        }
      }
    });
    print("reqdata315 : " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);
    return response.toString();
  }

  Future<String> CroplistDownload() async {
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);

    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();
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
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    String cropRevNo = agents[0]['farmerfarmcropRev'].toString();
    var datareq = jsonEncode(//{"Request":
        {
      "body": {"fCropRevNo": "0"}, //{"fCropRevNo": cropRevNo}
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "386",
        "operType": "01",
        "txnTime": formatter,
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "0|1",
        "tenantId": appDatas.tenent,
        "mobileModel": _modelNumber,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
    }
        //}
        );
    print("datareq 386" + datareq);
    Response response = await Dio().post(decTxnUrl, data: datareq);
    print("datareq 386" + response.toString());
    return response.toString();
  }

  Future<String> Download322() async {
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String _modelNumber = await getModelNumber();
    String _androidversion = await getAndroidVersion();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();

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
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    String seasoncode;
    String servicePointId;
    String agentName;
    String pricePatternRev = "0";
    String locationRev = "0";
    String fieldStaffRev = "0";
    String farmerOutStandBalRev = "0";
    String productDwRev = "0";
    String seasonDwRev = "0";
    String farmCrpDwRev = "0";
    String procurementProdDwRev = "0";
    String villageWareHouseDwRev = "0";
    String gradeDwRev = "0";
    String wareHouseStockDwRev = "0";
    String coOperativeDwRev = "0";
    String buyerDwRev = "0";
    String supplierDwRev = "0";
    String eventDwRev = "0";
    String catalogDwRev = "0";
    String researchStationDwRev = "0";
    String plannerRev = "0";
    String farmerStockBalRev = "0";
    String dynamicDwRev = "0";
    String followUpRevNo = "0";

    seasoncode = agents[0]['currentSeasonCode'].toString();
    servicePointId = agents[0]['servicePointId'].toString();
    agentName = agents[0]['agentName'].toString();
    pricePatternRev = agents[0]['pricePatternRev'].toString();
    locationRev = agents[0]['locationRev'].toString();
    fieldStaffRev = agents[0]['fieldStaffRev'].toString();
    farmerOutStandBalRev = agents[0]['farmerOutStandBalRev'].toString();
    productDwRev = agents[0]['productDwRev'].toString();
    seasonDwRev = agents[0]['seasonDwRev'].toString();
    farmCrpDwRev = agents[0]['farmCrpDwRev'].toString();
    procurementProdDwRev = "0|0|0";
    //procurementProdDwRev = agents[0]['procurementProdDwRev'].toString();
    villageWareHouseDwRev = agents[0]['villageWareHouseDwRev'].toString();
    gradeDwRev = agents[0]['gradeDwRev'].toString();
    wareHouseStockDwRev = agents[0]['wareHouseStockDwRev'].toString();
    coOperativeDwRev = agents[0]['coOperativeDwRev'].toString();
    buyerDwRev = agents[0]['buyerDwRev'].toString();
    supplierDwRev = agents[0]['supplierDwRev'].toString();
    eventDwRev = agents[0]['eventDwRev'].toString();
    catalogDwRev = agents[0]['catalogDwRev'].toString();
    researchStationDwRev = agents[0]['researchStationDwRev'].toString();
    plannerRev = agents[0]['plannerRev'].toString();
    farmerStockBalRev = agents[0]['farmerStockBalRev'].toString();
    dynamicDwRev = agents[0]['dynamicDwRev'].toString();
    followUpRevNo = agents[0]['followUpRevNo'].toString();
    followUpRevNo = agents[0]['followUpRevNo'].toString();

    var data = jsonEncode({
      //"Request": {
      "body": {
        "ppRevNo": pricePatternRev,
        "lRevNo": locationRev,
        "fsRevNo": fieldStaffRev,
        "fobRevNo": farmerOutStandBalRev,
        "prodRevNo": productDwRev,
        "seasonRevNo": seasonDwRev,
        "fcmRevNo": farmCrpDwRev,
        "procProdRevNo": procurementProdDwRev,
        "vwsRevNo": villageWareHouseDwRev,
        "gRevNo": gradeDwRev,
        "wsRevNo": wareHouseStockDwRev,
        "coRevNo": coOperativeDwRev,
        "byrRevNo": buyerDwRev,
        "supRevNo": supplierDwRev,
        "eventRevNo": eventDwRev,
        "catRevNo": catalogDwRev,
        "resStatRevNo": researchStationDwRev,
        "cSeasonCode": seasoncode,
        "agroVersion": "1",
        "plannerRevNo": plannerRev,
        "stRevNo": farmerStockBalRev,
        "dynLatestRevNo": dynamicDwRev,
        "followUpRevNo": followUpRevNo,
        "androidVersion": _androidversion,
        "mobileModel": _modelNumber
      },
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "322",
        "operType": "01",
        "txnTime": formatter,
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "0|1",
        "tenantId": appDatas.tenent,
        "branchId": appDatas.tenent,
        "mobileModel": _modelNumber,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
      // }
    });
    print("reqdata322 : " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);

    return response.toString();
  }

  Future<String> FarmerDownload() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);

    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();
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
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");
    String farmerRevNo = agents[0]['farmerRev'].toString();
    var data = jsonEncode({
      //"Request": {
      "body": {"farmerRevNo": "0"},
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "315",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": agents[0]['servicePointId'],
        "branchId": appDatas.tenent,
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
      //}
    });
    print("reqdata 315: " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);
    print("reqdata 315: " + response.toString());

    return response.toString();
  }

  Future<String> FarmDownload() async {
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String ipAddress = await getIPAddress();
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
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");
    String farmRevNo = agents[0]['farmerfarmRev'].toString();
    var data = jsonEncode({
      //"Request": {
      "body": {"farmRevNo": "0"}, //{"farmRevNo": farmRevNo}
      "head": {
        "agentId": agentid,
        "agentToken": agentToken,
        "txnType": "385",
        "txnTime": formatter,
        "operType": "01",
        "mode": "01",
        "msgNo": msgNo,
        "resentCount": "0",
        "serialNo": serialnumber,
        "servPointId": agents[0]['servicePointId'].toString(),
        "branchId": appDatas.tenent,
        "versionNo": versionlist[0] + "|" + DBVERSION!,
        "fsTrackerSts": "1|1",
        "tenantId": appDatas.tenent,
        "ipAddress": ipAddress,
        "lat": latitude,
        "lon": longitude,
      }
      //}
    });
    print("reqdata385: " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);
    return response.toString();
  }

  Future<String> ClientProjectDownload() async {
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String? _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");
    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "revNo", "value": "0"}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken":
              "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ1YmhhMTIzNDU2In0.fP6fFULQow6Y73Q9hmjU7kawUxyT6CXU7i5pz1galfk",
          "txnType": "356",
          "txnTime": formatter,
          "operType": "01",
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": "499ee46858391a2caf9e567589d1db8f",
          "servPointId": "SP001",
          "branchId": appDatas.tenent,
          "versionNo": versionlist[0] + "|" + DBVERSION!,
          "fsTrackerSts": "1|1",
          "tenantId": "agro"
        }
      }
    });
    print("reqdata : " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);
    return response.toString();
  }

  Future<String> GetLatestVersion() async {
    String delatestVersionUrl = await SecureStorage().decryptAES(appDatas.LatestVersionURL);
    //print("de  latestVersionUrl url:"+delatestVersionUrl);
    Response response = await Dio().get(delatestVersionUrl);
    return response.toString();
  }

  Future<String> SeedlingReceptionTxn(
    String respdate,
    String RecNo,
    String Longitude,
    String Latitude,
    String RespBatNo,
    String noOfseed,
    String recVariety,
    String nursery,
    String areaCode,
    String cSeasonCode,
    String BatchNo,
  ) async {
    String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    String? serialnumber = await SecureStorage().readSecureData("serialnumber");
    String _modelNumber = await getModelNumber();
    final now = new DateTime.now();
    String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");
    var data = jsonEncode({
      "Request": {
        "body": {
          "data": [
            {"key": "respDate", "value": respdate},
            {"key": "recNo", "value": RecNo},
            {"key": "longitude", "value": Longitude},
            {"key": "latitude", "value": Latitude},
            {"key": "respBatNo", "value": RespBatNo},
            {"key": "noOfseed", "value": noOfseed},
            {"key": "recVariety", "value": recVariety},
            {"key": "nursery", "value": nursery},
            {"key": "areaCode", "value": areaCode},
            {"key": "cSeasonCode", "value": cSeasonCode}
          ]
        },
        "head": {
          "agentId": agentid,
          "agentToken": agentToken,
          "txnType": "608",
          "txnTime": formatter,
          "operType": "01",
          "mode": "01",
          "msgNo": msgNo,
          "resentCount": "0",
          "serialNo": serialnumber,
          "servPointId": "",
          "branchId": BatchNo,
          "versionNo": versionlist[0] + "|" + DBVERSION!,
          "tenantId": appDatas.tenent,
          "mobileModel": _modelNumber
        }
      }
    });

    print("reqdata : " + data.toString());
    Response response = await Dio().post(decTxnUrl, data: data);
    return response.toString();
  }

  Future<String> InputReturn(String reqdat) async {
    Response response = await Dio().post(
        "http://62.138.16.229:9001/agrotxnFlutter/rs/processTxnJson",
        data: reqdat);
    return response.toString();
  }

  String JwtHS256(String subdata, String hmacKey) {
    final hmac = Hmac(sha256, hmacKey.codeUnits);

    final header =
        SplayTreeMap<String, String>.from(<String, String>{'alg': 'HS256'});
    final claim =
        SplayTreeMap<String, String>.from(<String, String>{'sub': subdata});

    final String encHdr = B64urlEncRfc7515.encodeUtf8(json.encode(header));
    final String encPld = B64urlEncRfc7515.encodeUtf8(json.encode(claim));
    final String data = '${encHdr}.${encPld}';
    final String encSig =
        B64urlEncRfc7515.encode(hmac.convert(data.codeUnits).bytes);
    return data + '.' + encSig;
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<String> getSerialnumber() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String serial_number = '';
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      serial_number = iosInfo.identifierForVendor!;
      serial_number = serial_number.replaceAll("-", "");//"622B8EF7B0FF4BD2842EF85EC15CBEC5"
      print('serial_number : ' + serial_number);
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var sdkint = androidInfo.version.sdkInt;
      print("serial_numberrelease " + sdkint.toString());

      var androidDeviceInfo = await deviceInfo.androidInfo;
      serial_number = androidDeviceInfo.androidId!;
      serial_number = generateMd5(serial_number);
      print("serial_number " + serial_number);
    }
    // unique ID on Android

    // }else{
    //   print("serial_number "+serial_number);
    //   serial_number = generateMd5(serial_number);
    //   print("serial_number "+serial_number);
    // }

    return serial_number;
  }

  Future<String> getIPAddress() async {
    String ipAddressValue = '';
    try {
      final ipv4 = await Ipify.ipv4();
      ipAddressValue = ipv4.toString();
    } catch (e) {
      ipAddressValue = '';
    }
    return ipAddressValue;
  }

  Future<String> getModelNumber() async {
    String Modelnumber = "";
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Modelnumber = iosInfo.utsname.machine!;
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Modelnumber = androidInfo.model!;
    }
    return Modelnumber;
  }

  Future<String> getAndroidVersion() async {
    String AndoridVersion = "";
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      AndoridVersion = androidInfo.version.release!;
    }
    return AndoridVersion;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
