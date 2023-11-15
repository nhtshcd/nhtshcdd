import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nhts/Database/Model/AnimalCatalogModel.dart';
import 'package:nhts/Database/Model/FarmerMaster.dart';
import 'package:nhts/Model/Catelog.dart';
import 'package:nhts/Model/User.dart';
import 'package:nhts/Model/cropHarDetModel.dart';
import 'package:nhts/Model/cropHarvestModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/secure_storage.dart';
import 'Model/CostofcultivaionModel.dart';
import 'Model/CropListmodel.dart';
import 'Model/PlannermaterialInsert.dart';
import 'Model/PlannermethodInsert.dart';
import 'Model/PlannerobservationInsert.dart';
import 'Model/PlannertrainingInsert.dart';
import 'Model/PlannerweekInsert.dart';
import 'Model/SprayInsert.dart';
import 'Model/TrainingInsert.dart';
import 'Model/TrainingsubtopicesInsert.dart';
import 'Model/TrainingtopicesInsert.dart';
import 'Model/opeDayInsert.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await openDB();

    return _db!;
  }

  DatabaseHelper.internal();

  /* initDb() async {
    print("initDB executed");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bdagro.db");

    var theDb = await openDatabase(path);
    theDb.close();
     theDb = await openDatabase(path);
    print("initDB theDb"+theDb.path);

    return theDb;
  }*/

  Future openDB() async {
    print("initDB executed");
    var theDb;
    print("CHECK_COPY_DATABASE 01");
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");
    print("dbversiondbversion:"+DBVERSION!);
    int dbversion = int.parse(DBVERSION!);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    var path = join(documentsDirectory.path, "bdagro" + DBVERSION + ".db");
    var file = new File(path);
    if (!await file.exists()) {
      try {
        await deleteDatabase(path);
        print("CHECK_COPY_DATABASE 02");
        ByteData data =
        await rootBundle.load(join("assets", "bdagro" + DBVERSION + ".db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
        theDb = await openDatabase(path, readOnly: false, version: dbversion);
        print("CHECK_COPY_DATABASE 03");
      } catch (e) {
        print("CHECK_COPY_DATABASE err" + e.toString());
      }
    }
    try {
      print("CHECK_COPY_DATABASE 04");

      theDb = await openDatabase(path, readOnly: false, version: dbversion);
    } catch (e) {
      print("CHECK_COPY_DATABASE 05:" + e.toString());
    }
    print("CHECK_COPY_DATABASE 06");
    return theDb;
  }
  /* Future openDB() async {
    print("initDB executed");
    var theDb;
    print("CHECK_COPY_DATABASE 01");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? DBVERSION = prefs.getString("DBVERSION");
    int dbversion = int.parse(DBVERSION!);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "bdagro.db" + newVersion + '.db');
    var file = new File(path);
    if (!await file.exists()) {
      try {
        await deleteDatabase(path);
        print("CHECK_COPY_DATABASE 02");
        ByteData data = await rootBundle.load(join("assets", "bdagro.db"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
        theDb = await openDatabase(path, readOnly: false, version: dbversion);
        print("CHECK_COPY_DATABASE 03");
      } catch (e) {
        print("CHECK_COPY_DATABASE err" + e.toString());
      }
    }
    try {
      print("CHECK_COPY_DATABASE 04");

      theDb = await openDatabase(path, readOnly: false, version: dbversion);
    } catch (e) {
      print("CHECK_COPY_DATABASE 05:" + e.toString());
    }
    print("CHECK_COPY_DATABASE 06");
    return theDb;
  }*/

  Future<List<Map>> getCatelog() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM catalog');
    for (int i = 0; i < list.length; i++) {
      var user = new Catelog(list[i]["IN_USE"], list[i]["DISP_SEQ"],
          list[i]["_ID"], list[i]["catalog_code"], list[i]["property_value"]);
      print('CHECKSAVEDATA   ' +
          list[i]["_ID"].toString() +
          " " +
          list[i]["catalog_code"].toString() +
          " " +
          list[i]["property_value"].toString());
    }
    return list;
  }

  Future<List<FarmerMaster>> GetFarmerdata() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT distinct f.trader,f.stateCode,f.fName,f.lName,f.farmerId,f.farmerCode,f.exporter,f.villageName,f.address,f.villageId,f.phoneNo,f.exporterCode,f.exporterStatus,f.idProofVal FROM farmer_master f,villageList v where f.villageId =v.villCode');

    List<FarmerMaster> farmers = [];

    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
        list[i]["fName"].toString(),
        list[i]["lName"].toString(),
        list[i]["farmerId"].toString(),
        list[i]["farmerCode"].toString(),
        list[i]["exporter"].toString(),
        list[i]["address"].toString(),
        list[i]["villageId"].toString(),
        list[i]["phoneNo"].toString(),
        list[i]["exporterCode"].toString(),
        list[i]["exporterStatus"].toString(),
        list[i]["villageName"].toString(),
        list[i]["idProofVal"].toString(),
        list[i]["stateCode"].toString(),
        list[i]["trader "].toString(),
      );

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<List<FarmerMaster>> GetFarmerdatabyVillage(String villagecode) async {
    var dbClient = await db;

    String slctqry =
        'SELECT * FROM farmer_master where villageId=\'' + villagecode + '\'';
    print(slctqry);
    List<Map> list = await dbClient.rawQuery(slctqry);

    // print('farmer_master ' + list.toString());
    //print('farmer_master ' + villagecode);
    List<FarmerMaster> farmers = [];
    for (int i = 0; i < list.length; i++) {
      var farmerdata = new FarmerMaster(
        list[i]["fName"].toString(),
        list[i]["lName"].toString(),
        list[i]["farmerId"].toString(),
        list[i]["farmerCode"].toString(),
        list[i]["exporter"].toString(),
        list[i]["address"].toString(),
        list[i]["villageId"].toString(),
        list[i]["phoneeNo"].toString(),
        list[i]["exportrCode"].toString(),
        list[i]["exporterStatus"].toString(),
        list[i]["villageName"].toString(),
        list[i]["idProofVal"].toString(),
        list[i]["stateCode"].toString(),
        list[i]["trader"].toString(),
      );

      farmers.add(farmerdata);
    }

    return farmers;
  }

  Future<List<AnimalCatalog>> GetCatalog() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM animalCatalog');

    List<AnimalCatalog> catalog = [];
    for (int i = 0; i < list.length; i++) {
      var animalcatalog = new AnimalCatalog(
          list[i]["catalog_code"].toString(),
          list[i]["property_value"].toString(),
          list[i]["DISP_SEQ "].toString(),
          list[i]["_ID"].toString(),
          list[i]["parentID "].toString(),
          list[i]["catStatus"].toString());

      catalog.add(animalcatalog);
    }

    return catalog;
  }

  Future<int> saveFarmer(FarmerMaster farmer) async {
    var dbClient = await db;
    int res = await dbClient.insert("farmer_master", farmer.toMap());
    return res;
  }

  Future<int> saveCroplistvalues(CropListmodel cropListmodel) async {
    var dbClient = await db;
    int res = await dbClient.insert("farmCropExists", cropListmodel.toMap());
    return res;
  }

  Future<int> saveCatalog(AnimalCatalog catalog) async {
    var dbClient = await db;
    int res = await dbClient.insert("animalCatalog", catalog.toMap());
    return res;
  }

  Future<int> saveVariety(
      String prodId,
      String vCode,
      String vName,
      String days,
      String hsCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."varietyList" ( "prodId", "vCode", "vName", "days","hsCode") VALUES (?,?,?,?,?)',
        [prodId, vCode, vName, days, hsCode]);
    return res;
  }

  Future<int> SaveProcurement(
      String recNo,
      String procId,
      String procType,
      String farmerId,
      String farmerName,
      String totalAmt,
      String isSynched,
      String procDate,
      String village,
      String pmtAmt,
      String season,
      String year,
      String driverName,
      String vehicleNo,
      String chartNo,
      String pDate,
      String city,
      String poNo,
      String samCode,
      String isReg,
      String mobileNo,
      String supplierType,
      String currentSeason,
      String roadMap,
      String vehicle,
      String farmId,
      String substituteFarmer,
      String farmerAttend,
      String farmCode,
      String farmerCode,
      String longitude,
      String latitude,
      String supplierTypeTxt,
      String labourCost,
      String transportCost,
      String farmFFC,
      String cropTypeProc,
      String invoiceNo,
      String buyerProc,
      String modeTrans) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurement" ("recNo","procId","procType","farmerId","farmerName","totalAmt","isSynched","procDate","village","pmtAmt","season","year","driverName","vehicleNo","chartNo","pDate","city","poNo","samCode","isReg","mobileNo","supplierType","currentSeason","roadMap","vehicle","farmId","substituteFarmer","farmerAttend","farmCode","farmerCode","longitude","latitude","supplierTypeTxt","labourCost","transportCost","farmFFC","cropTypeProc","invoiceNo","buyerProc","modeTrans") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          procId,
          procType,
          farmerId,
          farmerName,
          totalAmt,
          isSynched,
          procDate,
          village,
          pmtAmt,
          season,
          year,
          driverName,
          vehicleNo,
          chartNo,
          pDate,
          city,
          poNo,
          samCode,
          isReg,
          mobileNo,
          supplierType,
          currentSeason,
          roadMap,
          vehicle,
          farmId,
          substituteFarmer,
          farmerAttend,
          farmCode,
          farmerCode,
          longitude,
          latitude,
          supplierTypeTxt,
          labourCost,
          transportCost,
          farmFFC,
          cropTypeProc,
          invoiceNo,
          buyerProc,
          modeTrans,
        ]);
    return res;
  }

  Future<int> SaveProcurementGrade(
      String ppCode,
      String gradeCode,
      String prodId,
      String area,
      String grade,
      String price,
      String vCode,
      String cropCycle,
      String estDays) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementGrade" ("ppCode", "gradeCode", "prodId", "yieldAcre", "grade", "price", "vCode","cropCycle","estDays") VALUES (?,?,?,?,?,?,?,?,?)',
        [
          ppCode,
          gradeCode,
          prodId,
          area,
          grade,
          price,
          vCode,
          cropCycle,
          estDays,
        ]);
    return res;
  }

  Future<int> savePcbP(
      String dosage,
      String cropVariety,
      String chemicalName,
      String cropCat,
      String phiIn,
      String crop,
      String phId,
      String uom) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."pcbpList" ("dosage", "cropVariety", "chemicalName", "cropCat", "phiIn", "crop","phId","uom") VALUES (?,?,?,?,?,?,?,?)',
        [dosage, cropVariety, chemicalName, cropCat, phiIn, crop, phId, uom]);
    return res;
  }

  Future<int> SaveCalendarCrop(String cropSeason, String activeMethod,
      String activeType, String vCode, String noOfDays, String name) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."calendarCrop" ("cropSeason", "activeMethod", "activeType", "vCode", "noOfDays", "name") VALUES (?,?,?,?,?,?)',
        [cropSeason, activeMethod, activeType, vCode, noOfDays, name]);
    return res;
  }

  Future<int> SaveFarm(
      String farmCode,
      String farmId,
      String farmName,
      String farmerId,
      String currentCoversionStatus,
      String chemicalAppliedLastDate,
      String fLon,
      String fLat,
      String verifyStatus,
      String farmStatus,
      String pltStatus,
      String geoStatus,
      String insDate,
      String inspName,
      String insType,
      String farmArea,
      String prodLand,
      String inspDetList,
      String dynfield,
      String landStatus,
      String farmCount,
      String country,
      String state,
      String district,
      String city,
      String village,
      String customVillageName,
      int blockCount) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm" ( "farmIDT", "farmId", "farmName", "farmerId", "currentConversion", "chemicalAppLastDate", "longitude", "latitude","verifyStatus","farmStatus","pltStatus","geoStatus","insDate","inspName","insType","farmArea","prodLand","inspDetList","dynfield","landStatus","farmCount","country","state","district","city","village","customVillageName","blockCount") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmCode,
          farmId,
          farmName,
          farmerId,
          currentCoversionStatus,
          chemicalAppliedLastDate,
          fLon,
          fLat,
          verifyStatus,
          farmStatus,
          pltStatus,
          geoStatus,
          insDate,
          inspName,
          insType,
          farmArea,
          prodLand,
          inspDetList,
          dynfield,
          landStatus,
          farmCount,
          country,
          state,
          district,
          city,
          village,
          customVillageName,
          blockCount
        ]);
    return res;
  }

  Future<int> saveProcurementDetails(
      String prodCode,
      String price,
      String procId,
      String subTotal,
      String quality,
      String bags,
      String grossWt,
      String tareWt,
      String netWt,
      String procure_batchNo,
      String procure_UOM,
      String nofrutbgs) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementDetails" ( "prodCode","price","procId","subTotal","quality","bags","grossWt","tareWt","netWt","procure_batchNo","procure_UOM","nofrutbgs") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          prodCode,
          price,
          procId,
          subTotal,
          quality,
          bags,
          grossWt,
          tareWt,
          netWt,
          procure_batchNo,
          procure_UOM,
          nofrutbgs
        ]);
    return res;
  }

  Future<int> saveExistsFarmer(
      String isSynched,
      String recId,
      String farmerId,
      String farmerlatitude,
      String farmerlongitude,
      String farmertimeStamp,
      String farmerphoto,
      String farmlatitude,
      String farmlongitude,
      String farmtimeStamp,
      String farmphoto,
      String farmArea,
      String prodLand,
      String notProdLand,
      String farmId,
      String voice,
      String currentSeason,
      String cropLifeInsurance,
      String crophealthInsurance,
      String cropInsuranceCrop,
      String cropBank,
      String cropMoneyVendor,
      String pltStatus,
      String geoStatus) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."exists_farmer" ("isSynched","recId","farmerId","farmerlatitude","farmerlongitude","farmertimeStamp","farmerphoto","farmlatitude","farmlongitude","farmtimeStamp","farmphoto","farmArea","prodLand","notProdLand","farmId","voice","currentSeason","cropLifeInsurance","cropInsuranceCrop","cropBank","cropMoneyVendor","crophealthInsurance","pltStatus","geoStatus") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          isSynched,
          recId,
          farmerId,
          farmerlatitude,
          farmerlongitude,
          farmertimeStamp,
          farmerphoto,
          farmlatitude,
          farmlongitude,
          farmtimeStamp,
          farmphoto,
          farmArea,
          prodLand,
          notProdLand,
          farmId,
          voice,
          currentSeason,
          cropLifeInsurance,
          cropInsuranceCrop,
          cropBank,
          cropMoneyVendor,
          crophealthInsurance,
          pltStatus,
          geoStatus
        ]);
    return res;
  }

  Future<int> saveFarmGPSLocationExists(
      String latitude,
      String longitude,
      String farmerId,
      String farmId,
      String OrderOFGPS,
      String reciptId,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","reciptId") VALUES (?,?,?,?,?,?)',
        [
          latitude,
          longitude,
          farmerId,
          farmId,
          OrderOFGPS,
          reciptId,
        ]);

    return res;
  }

  Future<int> savefarmCropGPSLocationExists(
      String latitude,
      String longitude,
      String farmerId,
      String farmId,
      String OrderOFGPS,
      String cropId,
      String varietyId,
      String reciptId,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCrop_GPSLocation_Exists" ("latitude","longitude","farmerId","farmId","OrderOFGPS","cropId","varietyId","reciptId") VALUES (?,?,?,?,?,?,?,?)',
        [
          latitude,
          longitude,
          farmerId,
          farmId,
          OrderOFGPS,
          cropId,
          varietyId,
          reciptId,
        ]);

    return res;
  }

  Future<int> saveFarmCropExists(
      String farmerId,
      String farmCodeRef,
      String blockName,
      String blockArea,
      String blockId,
      String cropCode,
      String cropVariety,
      String cropgrade,
      String seedType,
      String dateOfSown,
      String seedLotNo,
      String borderCropType,
      String seedTreatment,
      String seedCheQty,
      String valfieldType,
      String seedQty,
      String plantWeek,
      String fertilizer,
      String fertiType,
      String fertiLotNo,
      String fertiQty,
      String unit,
      String expWeek,
      String mode,
      String production,
      String cropSeason,
      String cropCategory,
      String reciptId,
      String estHarvestDt,
      String farmcrpIDT,
      String cropCount,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCropExists" ("farmerId","farmCodeRef","blockName","blockArea","blockId","cropCode","cropVariety","cropgrade","seedType","dateOfSown","seedLotNo","borderCropType","seedTreatment","seedCheQty","otherSeedTreatment","seedQty","plantWeek","fertilizer","fertiType","fertiLotNo","fertiQty","unit","expWeek","mode","production","cropSeason","cropCategory","reciptId","estHarvestDt","farmcrpIDT","cropCount") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmCodeRef,
          blockName,
          blockArea,
          blockId,
          cropCode,
          cropVariety,
          cropgrade,
          seedType,
          dateOfSown,
          seedLotNo,
          borderCropType,
          seedTreatment,
          seedCheQty,
          valfieldType,
          seedQty,
          plantWeek,
          fertilizer,
          fertiType,
          fertiLotNo,
          fertiQty,
          unit,
          expWeek,
          mode,
          production,
          cropSeason,
          cropCategory,
          reciptId,
          estHarvestDt,
          farmcrpIDT,
          cropCount,
        ]);
    return res;
  }

  Future<List<Map>> GetVariety() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM varietyList');

    return list;
  }

  Future<int> saveUser(User user) async {
    int res = 0;
    var dbClient = await db;

    List<User> agentlist = await getUser();
    if (agentlist.length > 0) {
      print("CHECKDATABASE_A");
      deleteUsers(user);
    } else {
      print("CHECKDATABASE_B");
      res = await dbClient.insert("agentMaster", user.toMap());
    }
    return res;
  }

  Future<int> deleteUsers(User user) async {
    int res;
    var dbClient = await db;
    res = await dbClient
        .rawDelete('DELETE FROM agentMaster WHERE agentId = ?', [user.agentId]);
    res = await dbClient.insert("agentMaster", user.toMap());
    return res;
  }

  Future<int> saveTxnHeader(
      String isPrinted,
      String txnTime,
      String mode,
      String operType,
      String resentCount,
      String agentId,
      String agentToken,
      String msgNo,
      String servPointId,
      String txnRefId) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES (?, ?,?, ?, ?,?,?,?,?,?)',
        [
          isPrinted,
          txnTime,
          mode,
          operType,
          resentCount,
          agentId,
          agentToken,
          msgNo,
          servPointId,
          txnRefId
        ]);
    return res;
  }

  Future<int> saveCustTransaction(String txnDate, String txnConfigId,
      String txnRefId, String entity, String dynTxnid, String txnName) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."custTransactions" ("txnDate", "txnConfigId", "txnRefId", "entity", "dynTxnid", "txnName") VALUES (?, ?,?, ?, ?,?)',
        [txnDate, txnConfigId, txnRefId, entity, dynTxnid, txnName]);
    return res;
  }

  Future<List<Map>> GetTableValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' + tableName);

    return list;
  }

  Future<List<Map>> GetCropdataValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' + tableName);
    return list;
  }

  Future<List<Map>> GetUnSyncTableValues(String tableName) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM ' + tableName + ' Where isSynched = 0');

    return list;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM agentMaster');
    List<User> agents = [];
    for (int i = 0; i < list.length; i++) {
      var user = new User(
        list[i]["clientProjectRev"],
        list[i]["agentDistributionBal"],
        list[i]["agentProcurementBal"],
        list[i]["currentSeasonCode"],
        list[i]["pricePatternRev"],
        list[i]["agentType"],
        list[i]["tareWeight"],
        list[i]["curIdSeqS"],
        list[i]["resIdSeqS"],
        list[i]["curIdLimitS"],
        list[i]["curIdLimitF"],
        list[i]["resIdSeqF"],
        list[i]["curIdSeqF"],
        list[i]["agentAccBal"],
        list[i]["farmerRev"],
        list[i]["shopRev"],
        list[i]["agentId"],
        list[i]["agentName"],
        list[i]["cityCode"],
        list[i]["servPointName"],
        list[i]["agentPassword"],
        list[i]["servicePointId"],
        list[i]["locationRev"],
        list[i]["trainingRev"],
        list[i]["plannerRev"],
        list[i]["farmerOutStandBalRev"],
        list[i]["productDwRev"],
        list[i]["farmCrpDwRev"],
        list[i]["procurementProdDwRev"],
        list[i]["villageWareHouseDwRev"],
        list[i]["gradeDwRev"],
        list[i]["wareHouseStockDwRev"],
        list[i]["coOperativeDwRev"],
        list[i]["trainingCatRev"],
        list[i]["seasonDwRev"],
        list[i]["fieldStaffRev"],
        list[i]["areaCaptureMode"],
        list[i]["interestRateApplicable"],
        list[i]["rateOfInterest"],
        list[i]["effectiveFrom"],
        list[i]["isApplicableForExisting"],
        list[i]["previousInterestRate"],
        list[i]["qrScan"],
        list[i]["geoFenceFlag"],
        list[i]["geoFenceRadius"],
        list[i]["buyerDwRev"],
        list[i]["catalogDwRev"],
        list[i]["parentID"],
        list[i]["branchID"],
        list[i]["isGeneric"],
        list[i]["supplierDwRev"],
        list[i]["researchStationDwRev"],
        list[i]["displayDtFmt"],
        list[i]["batchAvailable"],
        list[i]["isGrampnchayat"],
        list[i]["areaUnitType"],
        list[i]["currency"],
        list[i]["farmerfarmRev"],
        list[i]["farmerfarmcropRev"],
        list[i]["warehouseId"],
        list[i]["farmerStockBalRev"],
        list[i]["latestSeasonRevNo"],
        list[i]["latestCatalogRevNo"],
        list[i]["latestLocationRevNo"],
        list[i]["latestCooperativeRevNo"],
        list[i]["latestProcproductRevNo"],
        list[i]["latestFarmerRevNo"],
        list[i]["latestFarmRevNo"],
        list[i]["latestFarmCropRevNo"],
        list[i]["dynamicDwRev"],
        list[i]["isBuyer"],
        list[i]["distributionPhoto"],
        list[i]["latestwsRevNo"],
        list[i]["digitalSign"],
        list[i]["cropCalandar"],
        list[i]["eventDwRev"],
        list[i]["seasonProdFlag"],
        list[i]["followUpRevNo"],
        list[i]["lotNoPack"],
        list[i]["packHouseId"],
        list[i]["packHouseName"],
        list[i]["exportLic"],
        list[i]["packHouseCode"],
        list[i]["exporterCode"],
        list[i]["exporterName"],
        list[i]["pwDate"],
        list[i]["pwExpDays"],
        list[i]["pwRemainder"],
        list[i]["variety"],
        list[i]["gCode"],
        list[i]["fLogin"],
        list[i]["expDate"],
        list[i]["expStatus"],
        list[i]["effectiveFrom"],
      );

      agents.add(user);
    }
    return agents;
  }

  Future<int> UpdateTableValue(String TableName, String ColumnName,
      String SetValue, String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE ' +
            TableName +
            ' SET ' +
            ColumnName +
            ' = ? Where ' +
            WhereColumn +
            ' = ? ',
        [SetValue, Wherevalue]);
    return count;
  }

  Future<int> UpdateTableRecord(String TableName, String columnsqry,
      String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE ' +
            TableName +
            ' SET ' +
            columnsqry +
            'Where ' +
            WhereColumn +
            ' = ? ',
        [Wherevalue]);
    return count;
  }

  Future<int> DeleteTableRecord(
      String TableName, String WhereColumn, String Wherevalue) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'DELETE FROM ' + TableName + ' Where ' + WhereColumn + ' = ? ',
        [Wherevalue]);
    return count;
  }

  Future<int> RawUpdate(String Query) async {
    var dbClient = await db;
    int count = await dbClient.rawUpdate(Query);
    return count;
  }

  Future<List<Map>> RawQuery(String Query) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(Query);
    return list;
  }

  Future<int> RawInsert(String Query) async {
    var dbClient = await db;
    int count = await dbClient.rawInsert(Query);
    return count;
  }

  Future<int> DeleteTable(String TableName) async {
    var dbClient = await db;
    int count = await dbClient.rawDelete('DELETE FROM ' + TableName);
    return count;
  }

  Future<int> SaveSamitee(String samCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."agentSamiteeList" ("samCode") VALUES (?)',
        [samCode]);
    return res;
  }

  Future<int> SaveCountry(String countryCode, String countryName) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."countryList" ("countryCode", "countryName") VALUES (?, ?)',
        [countryCode, countryName]);
    return res;
  }

  Future<int> SaveState(
      String stateCode, String stateName, String countryCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."stateList" ("stateCode", "stateName", "countryCode") VALUES (?, ?, ?)',
        [stateCode, stateName, countryCode]);
    return res;
  }

  Future<int> SaveDistrict(
      String districtCode, String districtName, String stateCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."districtList" ("districtCode", "districtName", "stateCode") VALUES (?, ?, ?)',
        [districtCode, districtName, stateCode]);
    return res;
  }

  Future<int> SaveCity(
      String cityCode, String cityName, String districtCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."cityList" ("cityCode", "cityName", "districtCode") VALUES (?, ?, ?)',
        [cityCode, cityName, districtCode]);
    return res;
  }

  Future<int> SaveVillage(
      String villCode, String villName, String gpCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."villageList" ("villCode", "villName", "gpCode") VALUES (?, ?, ?)',
        [villCode, villName, gpCode]);
    return res;
  }

  Future<int> SaveSeason(
      String seasonId, String seasonName, String year) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."seasonYear" ("seasonId", "seasonName", "year") VALUES (?, ?, ?)',
        [seasonId, seasonName, year]);
    return res;
  }

  Future<int> SavegramPanchayat(
      String gpCode, String gpName, String cityCode) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."gramPanchayat" ("gpCode", "gpName", "cityCode") VALUES (?, ?, ?)',
        [gpCode, gpName, cityCode]);
    return res;
  }

  Future<int> SaveSamiteeList(
      String samCode, String samName, String utzStatus) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."samitee" ("samCode", "samName", "utzStatus") VALUES (?, ?, ?)',
        [samCode, samName, utzStatus]);
    return res;
  }

  Future<int> SavecoOperatives(
      String coCode, String coName, String copTyp) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."coOperative" ("coCode","coName","coType") VALUES (?,?,?)',
        [coCode, coName, copTyp]);

    return res;
  }

  Future<int> saveVillageWarehouse(
      String batchNo,
      String wCode,
      String wName,
      String pCode,
      String pName,
      String vCode,
      String vName,
      String actWt,
      String sortWt,
      String rejWt,
      String farmerId,
      String farmId,
      String blockId,
      String plantingId,
      String lastHarDate,
      String blockName,
      String stockType,
      String farmerName,
      String farmName,
      String countyCode,
      String countyName,
      String lotNoPack,
      String harvestWt,
      String resBatNo,
      String qrUniqId,
      String txnDate,
      String transferFrom,
      String transferTo,
      String truck,
      String driver,
      String licenseNo,
      String transferToName,
      String transferFromName, String bbDate) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."villageWarehouse" ("batchNo","wCode","wName","pCode","pName","vCode","vName","actWt","sortWt","rejWt","farmerId","farmId","blockId","plantingId","lastHarDate","blockName","stockType","farmerName","farmName","countyCode","countyName","lotNoPack","harvestWt","resBatNo","qrUniqId","txnDate","transferFrom","transferTo","truck","driver","licenseNo","transferToName","transferFromName","bestBeforeDate") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          batchNo,
          wCode,
          wName,
          pCode,
          pName,
          vCode,
          vName,
          actWt,
          sortWt,
          rejWt,
          farmerId,
          farmId,
          blockId,
          plantingId,
          lastHarDate,
          blockName,
          stockType,
          farmerName,
          farmName,
          countyCode,
          countyName,
          lotNoPack,
          harvestWt,
          resBatNo,
          qrUniqId,
          txnDate,
          transferFrom,
          transferTo,
          truck,
          driver,
          licenseNo,
          transferToName,
          transferFromName,
          bbDate
        ]);

    return res;
  }
  Future<int> SaveProducts(
      String unit,
      String productCode,
      String subCategoryName,
      String subCategoryCode,
      String categoryCode,
      String categoryName,
      String productName,
      String price) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."products" ("unit", "productCode", "subCategoryName", "subCategoryCode", "categoryCode", "categoryName", "productName", "price") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          unit,
          productCode,
          subCategoryName,
          subCategoryCode,
          categoryCode,
          categoryName,
          productName,
          price
        ]);
    return res;
  }

  Future<int> SaveProcurementProducts(String code, String name, String type,
      String unit, String msp, String mspPercent) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."procurementProducts" ("code", "name", "type", "unit", "msp", "mspPercent") VALUES (?,?,?,?,?,?)',
        [code, name, type, unit, msp, mspPercent]);
    return res;
  }

  Future<int> SavePayment(
      String recNo,
      String cityCode,
      String villageCode,
      String farmerId,
      String seasonCode,
      String pageNo,
      String payDate,
      String pType,
      String pAmount,
      String remarks,
      String longitude,
      String latitude,
      String isSynched,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."paymentDetails" ("recNo","cityCode","villageCode","farmerId","seasonCode","pageNo","payDate","pType","pAmount","remarks","longitude","latitude","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          cityCode,
          villageCode,
          farmerId,
          seasonCode,
          pageNo,
          payDate,
          pType,
          pAmount,
          remarks,
          longitude,
          latitude,
          isSynched,
        ]);
    return res;
  }

  Future<int> saveCropHarvest(cropHarvestModel cropHarvest) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvest" ("season", "recNo", "harvestDate", "farmerId", "farmId", "total", "isSynched", "packOther", "storOther", "storage", "packed", "latitude", "longitude") VALUES ('
            '\'' +
            cropHarvest.season +
            '\',' +
            '\'' +
            cropHarvest.recNo +
            '\',' +
            '\'' +
            cropHarvest.harvestDate +
            '\',' +
            '\'' +
            cropHarvest.farmerId +
            '\',' +
            '\'' +
            cropHarvest.farmId +
            '\',' +
            '\'' +
            cropHarvest.total +
            '\',' +
            '\'' +
            "0" +
            '\',' +
            '\'' +
            cropHarvest.packOther +
            '\',' +
            '\'' +
            cropHarvest.storOther +
            '\',' +
            '\'' +
            cropHarvest.storage +
            '\',' +
            '\'' +
            cropHarvest.packed +
            '\',' +
            '\'' +
            cropHarvest.latitude +
            '\',' +
            '\'' +
            cropHarvest.longitude +
            '\'' +
            ')');
    return res;
  }

  Future<int> saveCropHardet(cropHarDetModel cropHardet) async {
    int res;
    var dbClient = await db;
    res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvestDetails" ("cropType", "cropId", "cropVariety", "cropGrade", "quantity", "price", "subTotal") VALUES ('
            '\'' +
            cropHardet.cropType +
            '\',' +
            '\'' +
            cropHardet.cropId +
            '\',' +
            '\'' +
            cropHardet.cropVariety +
            '\',' +
            '\'' +
            cropHardet.cropGrade +
            '\',' +
            '\'' +
            cropHardet.quantity +
            '\',' +
            '\'' +
            cropHardet.price +
            '\',' +
            '\'' +
            cropHardet.subTotal +
            '\'' +
            ')');
    return res;
  }

  Future<List<cropHarvestModel>> getcropHarvest() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM cropHarvest');
    print(list.toString());
    List<cropHarvestModel> getCroplist = [];
    for (int i = 0; i < list.length; i++) {
      var getcropval = new cropHarvestModel(
        list[i]["season"],
        list[i]["recNo"],
        list[i]["harvestDate"],
        list[i]["farmerId"],
        list[i]["farmId"],
        list[i]["total"],
        list[i]["packOther"],
        list[i]["storOther"],
        list[i]["storage"],
        list[i]["packed"],
        list[i]["latitude"],
        list[i]["longitude"],
        list[i]["isSynched"],
      );
      getCroplist.add(getcropval);
    }
    return getCroplist;
  }

  Future<List<cropHarDetModel>> getcropHardet() async {
    var dbClient = await db;
    List<Map> list =
    await dbClient.rawQuery('SELECT * FROM cropHarvestDetails');
    print(list.toString());
    List<cropHarDetModel> getcropHardet = [];
    for (int i = 0; i < list.length; i++) {
//print("ID "+ list[i]["ID"]);
      var getcropdet = new cropHarDetModel(
        list[i]["cropType"],
        list[i]["cropId"],
        list[i]["cropVariety"],
        list[i]["cropGrade"],
        list[i]["quantity"],
        list[i]["price"],
        list[i]["subTotal"],
      );
      getcropHardet.add(getcropdet);
    }
    return getcropHardet;
  }

  Future<int> SaveSensitizingImage(
      String image,
      String refId,
      String time,
      String latitude,
      String longitude,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."image_Sensit_List" ("image","refId","time","latitude","longitude") VALUES (?,?,?,?,?)',
        [
          image,
          refId,
          time,
          latitude,
          longitude,
        ]);
    return res;
  }

  Future<int> SaveTrainingImage(
      String image,
      String refId,
      String time,
      String latitude,
      String longitude,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."image_Training_List" ("image","refId","time","latitude","longitude") VALUES (?,?,?,?,?)',
        [
          image,
          refId,
          time,
          latitude,
          longitude,
        ]);
    return res;
  }

  Future<int> saveCostcultivation(
      CostofcultivationModel costofcultivation) async {
    var dbClient = await db;
    int res =
    await dbClient.insert("costOfCultivation", costofcultivation.toMap());
    return res;
  }

  Future<List<CostofcultivationModel>> getcostOfCultivation(String id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM costOfCultivation');
    List<CostofcultivationModel> costoflist = [];
    for (int i = 0; i < list.length; i++) {
      var costOfCultivation = new CostofcultivationModel(
          list[i]["isSynched"],
          list[i]["farmerId"],
          list[i]["farmId"],
          list[i]["recpNo"],
          list[i]["cocDate"],
          list[i]["cocCategory"],
          list[i]["incomeFromAgriCOC"],
          list[i]["incomeFromInterCOC"],
          list[i]["incomeFromOtherCOC"],
          list[i]["landPreTotal"],
          list[i]["sowingTotal"],
          list[i]["gapfillTotal"],
          list[i]["WeedingTotal"],
          list[i]["cultureTotal"],
          list[i]["irrigationTotal"],
          list[i]["fertilizerTotal"],
          list[i]["pesticideTotal"],
          list[i]["harvestTotal"],
          list[i]["tototrExp"],
          list[i]["totalExpenses"],
          list[i]["currentSeason"],
          list[i]["manureTotal"],
          list[i]["longitude"],
          list[i]["latitude"],
          list[i]["cropId"],
          list[i]["soilPrepare"],
          list[i]["labourHire"],
          list[i]["manureUse"],
          list[i]["fertUse"],
          list[i]["soilPrepareLabour"],
          list[i]["seedBuyCostLabour"],
          list[i]["gapFillingLabour"],
          list[i]["WeedingCostsLabour"],
          list[i]["IrrigationCostsLabour"],
          list[i]["InputCostsLabour"],
          list[i]["HarvestCostLabour"],
          list[i]["totManureCostLabour"],
          list[i]["bioFertCostLabour"],
          list[i]["bioPestCostLabour"],
          list[i]["OtherCostsGin"],
          list[i]["OtherCostsFuel"],
          list[i]["pestUse"]);
      costoflist.add(costOfCultivation);
    }
    return costoflist;
  }

  Future<int> saveTrainingTopices(TrainingtopicesInsert trTopic) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerTopic", trTopic.toMap());
    return res;
  }

  Future<int> saveSubTopices(TrainingsubtopicesInsert trSubTopic) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerSubTopic", trSubTopic.toMap());
    return res;
  }

  Future<int> saveplannerTraining(PlannertrainingInsert plannerTraining) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerTraining", plannerTraining.toMap());
    return res;
  }

  Future<int> saveplannerMaterial(PlannermaterialInsert plannerMaterial) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerMaterial", plannerMaterial.toMap());
    return res;
  }

  Future<int> saveplannerMethod(PlannermethodInsert plannerMethod) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerMethod", plannerMethod.toMap());
    return res;
  }

  Future<int> saveplannerObsevation(
      PlannerobservationInsert plannerObservation) async {
    var dbClient = await db;
    int res =
    await dbClient.insert("plannerObservation", plannerObservation.toMap());
    return res;
  }

  Future<int> saveplannerWeek(PlannerweekInsert plannerweek) async {
    var dbClient = await db;
    int res = await dbClient.insert("plannerWeek", plannerweek.toMap());
    return res;
  }

  Future<int> saveTraining(TrainingInsert training) async {
    var dbClient = await db;
    int res = await dbClient.insert("training", training.toMap());
    return res;
  }

  Future<int> stationTraining(opeDayInsert opeDaysInsert) async {
    var dbClient = await db;
    int res = await dbClient.insert("openDay", opeDaysInsert.toMap());
    return res;
  }

  Future<List<TrainingInsert>> getTraining(String custTxnsRefId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM training');
    List<TrainingInsert> TrainingList = [];
    for (int i = 0; i < list.length; i++) {
      var TrainingnModel = new TrainingInsert(
          list[i]["recNo"],
          list[i]["date"],
          list[i]["season"],
          list[i]["village"],
          list[i]["learnGroup"],
          list[i]["FarmersIds"],
          list[i]["remarks"],
          list[i]["isSynched"],
          list[i]["latitude"],
          list[i]["longitude"],
          list[i]["Farmerscount"],
          list[i]["trainingDetail"],
          list[i]["trainingTopic"],
          list[i]["trainingSubTopic"],
          list[i]["trainingMaterial"],
          list[i]["trainingMethod"],
          list[i]["trainingObservation"],
          list[i]["trainingAssistent"],
          list[i]["trainingTime"]);
      TrainingList.add(TrainingnModel);
    }
    return TrainingList;
  }

  Future<int> saveDynamicMenu(
      String menuId,
      String menuName,
      String iconClass,
      String menuOrder,
      String txnTypeIdMenu,
      String entity,
      String menucommonClass,
      String seasonFlag,
      String agentType,
      String txnDate,
      String refId,
      String refName,
      String fluptxnId,
      String isfollowup,
      String villageName,
      String grpName,
      String statusState,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentMenu" ("menuId","menuName","iconClass","menuOrder","txnTypeIdMenu","entity","menucommonClass","seasonFlag","agentType","txnDate","refId","refName","fluptxnId","isfollowup","villageName","grpName","statusState") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          menuId,
          menuName,
          iconClass,
          menuOrder,
          txnTypeIdMenu,
          entity,
          menucommonClass,
          seasonFlag,
          agentType,
          txnDate,
          refId,
          refName,
          fluptxnId,
          isfollowup,
          villageName,
          grpName,
          statusState
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenent(String listId, String listName,
      String blockId, String txnTypeId, String sectionId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentList" ("listId","listName","blockId","txnTypeId","sectionId") VALUES (?,?,?,?,?)',
        [
          listId,
          listName,
          blockId,
          txnTypeId,
          sectionId,
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenentSection(
      String txnTypeId,
      String blockId,
      String sectionId,
      String secName,
      String beinsert,
      String afterins,
      String secOrder,
      String txnTypeIdMaster,
      String fluptxnId,
      String isfollowup) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentSections" ("txnTypeId","blockId","sectionId","secName","beinsert","afterins","secOrder","txnTypeIdMaster","fluptxnId","isfollowup") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          txnTypeId,
          blockId,
          sectionId,
          secName,
          beinsert,
          afterins,
          secOrder,
          txnTypeIdMaster,
          fluptxnId,
          isfollowup
        ]);
    return res;
  }

  Future<int> SaveDynamicCompenentList(String listId, String listName,
      String blockId, String txnTypeId, String sectionId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentList" ("listId","listName","blockId","txnTypeId","sectionId") VALUES (?,?,?,?,?)',
        [
          listId,
          listName,
          blockId,
          txnTypeId,
          sectionId,
        ]);
    return res;
  }

  Future<int> SavemultiTenantParent(
      String recNo,
      String farmerId,
      String farmId,
      String isSynched,
      String season,
      String longitude,
      String latitude,
      String txnType,
      String txnUniqueId,
      String txnDate,
      String txnTypeIdMaster,
      String inspectionStatus,
      String converStatus,
      String corActPln,
      String entity,
      String dynseasonCode,
      String inspectionDate,
      String scopeOpr,
      String inspectionType,
      String nameofInspect,
      String inspectorMblNo,
      String certTotalLnd,
      String certlandOrganic,
      String certTotalsite,
      String activityId,
      String startTime,
      String activityStatus,
      String reason,
      String digitalSign,
      String agentSign,
      String teantId,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."multiTenantParent" ("recNo","farmerId","farmId","isSynched","season","longitude","latitude","txnType","txnUniqueId","txnDate","txnTypeIdMaster","inspectionStatus","converStatus","corActPln","entity","dynseasonCode","inspectionDate","scopeOpr","inspectionType","nameofInspect","inspectorMblNo","certTotalLnd","certlandOrganic","certTotalsite","activityId","startTime","activityStatus","reason","digitalSign","agentSign","teantId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          farmerId,
          farmId,
          isSynched,
          season,
          longitude,
          latitude,
          txnType,
          txnUniqueId,
          txnDate,
          txnTypeIdMaster,
          inspectionStatus,
          converStatus,
          corActPln,
          entity,
          dynseasonCode,
          inspectionDate,
          scopeOpr,
          inspectionType,
          nameofInspect,
          inspectorMblNo,
          certTotalLnd,
          certlandOrganic,
          certTotalsite,
          activityId,
          startTime,
          activityStatus,
          reason,
          digitalSign,
          agentSign,
          teantId
        ]);
    return res;
  }

  Future<int> SavedynamiccomponentFieldValues(String FieldId, String FieldVal,
      String ComponentType, String recNu, String txnTypeId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentFieldValues" ("FieldId","FieldVal","ComponentType","recNu","txnTypeId") VALUES (?,?,?,?,?)',
        [
          FieldId,
          FieldVal,
          ComponentType,
          recNu,
          txnTypeId,
        ]);
    return res;
  }

  Future<int> SavePlanting(
      String recNo,
      String seasonCode,
      String farmerCode,
      String latitude,
      String longitude,
      String isSynched,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."planting" ("recNo","seasonCode","farmerCode","latitude","longitude","isSynched") VALUES (?,?,?,?,?,?)',
        [
          recNo,
          seasonCode,
          farmerCode,
          latitude,
          longitude,
          isSynched,
        ]);
    return res;
  }

  Future<int> SavePlantingDetails(
      String rec,
      String cultivar,
      String vCode,
      String QtyPlntd,
      String PlntdPeriod,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plantingDetails" ("recNo","cultivar","vCode","QtyPlntd","PlntdPeriod") VALUES (?,?,?,?,?)',
        [
          rec,
          cultivar,
          vCode,
          QtyPlntd,
          PlntdPeriod,
        ]);
    return res;
  }

  Future<int> SaveHarvesting(
      String revNo,
      String isSynched,
      String season,
      String latitude,
      String longitude,
      String farmerCode,
      String variety,
      String qtyPlanted,
      String yld,
      String sellingPrice,
      String harvestPeriod,
      String cultivar,
      String totalPrice,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."harvesting" ("recNo","isSynched","season","latitude","longitude","farmerCode","variety","qtyPlanted","yld","sellingPrice", "harvestPeriod", "cultivar","totalPrice") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          revNo,
          isSynched,
          season,
          latitude,
          longitude,
          farmerCode,
          variety,
          qtyPlanted,
          yld,
          sellingPrice,
          harvestPeriod,
          cultivar,
          totalPrice,
        ]);
    return res;
  }

  Future<int> SaveplannerTraining(
      String trainingCode,
      String trainingName,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerTraining" ("trainingCode","trainingName") VALUES (?,?)',
        [
          trainingCode,
          trainingName,
        ]);
    return res;
  }

  Future<int> SavePlannerTopics(
      String criteriaCatName,
      String criteriaCatCode,
      String trainingCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerTopic" ("criteriaCatName","criteriaCatCode","trainingCode") VALUES (?,?,?)',
        [
          criteriaCatName,
          criteriaCatCode,
          trainingCode,
        ]);
    return res;
  }

  Future<int> SavePlannerSubTopics(
      String criteriaCode,
      String criteriaName,
      String criteriaCatCode,
      String trainingCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerSubTopic" ("criteriaCode","criteriaName","criteriaCatCode","trainingCode") VALUES (?,?,?,?)',
        [
          criteriaCode,
          criteriaName,
          criteriaCatCode,
          trainingCode,
        ]);
    return res;
  }

  Future<int> SaveplannerMaterial(
      String materialCode,
      String materialName,
      String trainingCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerMaterial" ("materialCode","materialName","trainingCode") VALUES (?,?,?)',
        [
          materialCode,
          materialName,
          trainingCode,
        ]);
    return res;
  }

  Future<int> SaveplannerMethod(
      String methodCode,
      String methodName,
      String trainingCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerMethod" ("methodCode","methodName","trainingCode") VALUES (?,?,?)',
        [
          methodCode,
          methodName,
          trainingCode,
        ]);
    return res;
  }

  Future<int> SaveplannerObservation(
      String observCode,
      String observName,
      String trainingCode,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerObservation" ("observCode","observName","trainingCode") VALUES (?,?,?)',
        [
          observCode,
          observName,
          trainingCode,
        ]);
    return res;
  }

  Future<int> SaveplannerWeek(
      String TrainingCode,
      String Year,
      String Month,
      String Week,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."plannerWeek" ("TrainingCode","Year","Month","Week") VALUES (?,?,?,?)',
        [
          TrainingCode,
          Year,
          Month,
          Week,
        ]);
    return res;
  }

  Future<int> SaveDipping(
      String recNo,
      String farmerCode,
      String latitude,
      String longitude,
      String isSynched,
      String seasonCode,
      String stationCode,
      String dippDate,
      String totalQty,
      String service,
      String qty,
      String othCost,
      String position,
      String dateOpen,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dipping" ("recNo","farmerCode","latitude","longitude","isSynched","seasonCode","stationCode","dippDate","totalQty","service","qty","othCost","poistion","dateOpen") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          farmerCode,
          latitude,
          longitude,
          isSynched,
          seasonCode,
          stationCode,
          dippDate,
          totalQty,
          service,
          qty,
          othCost,
          position,
          dateOpen
        ]);
    return res;
  }

  Future<int> SaveEndDay(
      String recNo,
      String endDate,
      String stationDate,
      String totalQty,
      String fuel,
      String plunge,
      String spray,
      String lime,
      String photo,
      String cSeasonCode,
      String lat,
      String lon,
      String isSynched,
      String stationCode,
      String dateOpen,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dayEnd" ("recNo","endDate","stationDate","totalQty","fuel","plunge","spray","lime","photo","cSeasonCode","lat","lon","isSynched","stationCode","dateOpen") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          endDate,
          stationDate,
          totalQty,
          fuel,
          plunge,
          spray,
          lime,
          photo,
          cSeasonCode,
          lat,
          lon,
          isSynched,
          stationCode,
          dateOpen
        ]);
    return res;
  }

  Future<int> SaveEndDayDetails(
      String recNo,
      String farmerId,
      String service,
      String qty,
      String othCost,
      String isEdit,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dayEndDetails" ("recNo","farmerId","service","qty","othCost","isEdit") VALUES (?,?,?,?,?,?)',
        [
          recNo,
          farmerId,
          service,
          qty,
          othCost,
          isEdit,
        ]);
    return res;
  }

  Future<int> SaveEndDayImages(
      String recNo,
      String photo,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dayEndImages" ("recNo","photo") VALUES (?,?)', [
      recNo,
      photo,
    ]);
    return res;
  }

  Future<int> SaveDynamicCompenentFields(
      String componentType,
      String componentID,
      String componentLabel,
      String textType,
      String beinsert,
      String aftinsert,
      String dateboxType,
      String isMandatory,
      String validationType,
      String maxLength,
      String minLength,
      String decimalLength,
      String isDependency,
      String dependencyField,
      String catalogValueId,
      String parentDependency,
      String txnTypeId,
      String blockId,
      String fieldOrder,
      String ifListNo,
      String sectionId,
      String listMethodName,
      String formulaDependency,
      String parentField,
      String catDepKey,
      String isOther,
      String referenceId,
      String valueDependency,
      String actionPlan,
      String deadline,
      String answer) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."dynamiccomponentFields" ("componentType","componentID","componentLabel","textType","beinsert","aftinsert","dateboxType","isMandatory","validationType","maxLength","minLength","decimalLength","isDependency","dependencyField","catalogValueId","parentDependency","txnTypeId","blockId","fieldOrder","ifListNo","sectionId","listMethodName","formulaDependency","parentField","catDepKey","isOther","referenceId","valueDependency","actionPlan","deadline","answer") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          componentType,
          componentID,
          componentLabel,
          textType,
          beinsert,
          aftinsert,
          dateboxType,
          isMandatory,
          validationType,
          maxLength,
          minLength,
          decimalLength,
          isDependency,
          dependencyField,
          catalogValueId,
          parentDependency,
          txnTypeId,
          blockId,
          fieldOrder,
          ifListNo,
          sectionId,
          listMethodName,
          formulaDependency,
          parentField,
          catDepKey,
          isOther,
          referenceId,
          valueDependency,
          actionPlan,
          deadline,
          answer
        ]);
    return res;
  }

  Future<int> saveBuyerList(
      String buyrId,
      String buyrName, String buyersCountry, String buyersCountryCode,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."buyerList" ("buyrId","buyrName","buyersCountry","buyerCountryCode") VALUES (?,?,?,?)',
        [buyrId, buyrName,buyersCountry,buyersCountryCode]);
    return res;
  }

  Future<int> SavewareHouseStocks(
      String categoryCode,
      String productCode,
      String stock,
      String batchNo,
      String saeson,
      String wareHouseName,
      String wareHouseCode,
      String subCategoryCode) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."wareHouseStocks" ("wareHouseName", "wareHouseCode", "categoryCode", "subCategoryCode", "productCode", "stock", "bactNo", "season") VALUES ( ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          wareHouseName,
          wareHouseCode,
          categoryCode,
          subCategoryCode,
          productCode,
          stock,
          batchNo,
          saeson
        ]);
    return res;
  }

  Future<int> saveFarmCrop(
      String scoutDate,
      String commonRec,
      String farmerId,
      String farmCodeRef,
      String blockName,
      String blockArea,
      String blockId,
      String cropCode,
      String cropVariety,
      String cropgrade,
      String seedType,
      String dateOfSown,
      String maxPhiDate,
      String borderCropType,
      String seedTreatment,
      String seedCheQty,
      String otherSeedTreatment,
      String seedQty,
      String plantWeek,
      String fertilizer,
      String fertiType,
      String fertiLotNo,
      String fertiQty,
      String unit,
      String expWeek,
      String mode,
      String production,
      String cropSeason,
      String cropCategory,
      String reciptId,
      String estHarvestDt,
      String farmcrpIDT,
      String cropCount) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmCrop" ("scoutDate","commonRec","farmerId","farmCodeRef","blockName","blockArea","blockId","cropCode","cropVariety","cropgrade","seedType","dateOfSown","seedLotNo","borderCropType","seedTreatment","seedCheQty","otherSeedTreatment","seedQty","plantWeek","fertilizer","fertiType","fertiLotNo","fertiQty","unit","expWeek","mode","production","cropSeason","cropCategory","reciptId","estHarvestDt","farmcrpIDT","cropCount") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [ scoutDate,
          commonRec,
          farmerId,
          farmCodeRef,
          blockName,
          blockArea,
          blockId,
          cropCode,
          cropVariety,
          cropgrade,
          seedType,
          dateOfSown,
          maxPhiDate,
          borderCropType,
          seedTreatment,
          seedCheQty,
          otherSeedTreatment,
          seedQty,
          plantWeek,
          fertilizer,
          fertiType,
          fertiLotNo,
          fertiQty,
          unit,
          expWeek,
          mode,
          production,
          cropSeason,
          cropCategory,
          reciptId,
          estHarvestDt,
          farmcrpIDT,
          cropCount
        ]);
    return res;
  }

  Future<int> saveFarmInspection(
      String dateIns,
      String companyId,
      String farmerId,
      String farmId,
      String contactPerson,
      String greenHouse,
      String cropId,
      String variety,
      String observation,
      String previous,
      String statusGreen,
      String traceability,
      String pestStatus,
      String pestParticulars,
      String pestLocation,
      String cropProtection,
      String modeTransportation,
      String noScouters,
      String harvestInspection,
      String specification,
      String hygieneStatus,
      String hygieneDescription,
      String gradingHall,
      String gradingDescription,
      String gradinghallStaff,
      String farmEquipment,
      String evidence,
      String recommendation,
      String supplyStatus,
      String rejectReason,
      String additional,
      String isSynched,
      String recNo,
      String photo,
      String inspectorSign,
      String ownerSign,
      String audio,
      String timeSt,
      String longitude,
      String latitude,
      String evidencePhoto) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmInspection" ("dateIns","companyId","farmerId","farmId","contactPerson","greenHouse","cropId","variety","observation","previous","statusGreen","traceability","pestStatus","pestParticulars","pestLocation","cropProtection","modeTransportation","noScouters","harvestInspection","specification","hygieneStatus","hygieneDescription","gradingHall","gradingDescription","gradingHallStaff","farmEquipment","evidence","recommendation","supplyStatus","rejectReason","additional","isSynched","recNo","photo","inspectorSign","ownerSign","audio","timeSt","longitude","latitude","evidencePhoto") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          dateIns,
          companyId,
          farmerId,
          farmId,
          contactPerson,
          greenHouse,
          cropId,
          variety,
          observation,
          previous,
          statusGreen,
          traceability,
          pestStatus,
          pestParticulars,
          pestLocation,
          cropProtection,
          modeTransportation,
          noScouters,
          harvestInspection,
          specification,
          hygieneStatus,
          hygieneDescription,
          gradingHall,
          gradingDescription,
          gradinghallStaff,
          farmEquipment,
          evidence,
          recommendation,
          supplyStatus,
          rejectReason,
          additional,
          isSynched,
          recNo,
          photo,
          inspectorSign,
          ownerSign,
          audio,
          timeSt,
          longitude,
          latitude,
          evidencePhoto
        ]);
    return res;
  }

  Future<int> saveScouting(
      String cmnRecommendationController,
      String formatDate,
      String valFarmer,
      String valFarm,
      String blockId,
      String valCrop,
      String selectedInsetValue,
      String valInst,
      String numberInsectController,
      String selectedDisValue,
      String valDisc,
      String perInfectionController,
      String selectedWeedValue,
      String valWeed,
      String weedsPreController,
      String recommendationController,
      String slcIrrType,
      String slcIrrMet,
      String areaIrrigationController,
      String msgNo,
      String Lat,
      String Lng,
      String recNo,
      String isSynched,
      String waterSource ,String sprayingNeeded) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."scouting" ("cmnRec","dateSco","farmerId","farmId","blockId","cropId","insects","nameInsect","perInsects","disease","nameDisease","perDisease","weed","nameWeed","perWeed","recommentation","irrType","irrMethod","irrArea","timeSt","longitude","latitude","recNo","isSynched","waterSource","ownerSign") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          cmnRecommendationController,
          formatDate,
          valFarmer,
          valFarm,
          blockId,
          valCrop,
          selectedInsetValue,
          valInst,
          numberInsectController,
          selectedDisValue,
          valDisc,
          perInfectionController,
          selectedWeedValue,
          valWeed,
          weedsPreController,
          recommendationController,
          slcIrrType,
          slcIrrMet,
          areaIrrigationController,
          msgNo,
          Lat,
          Lng,
          recNo,
          isSynched,
          waterSource,
          sprayingNeeded
        ]);
    return res;
  }

  Future<int> saveScoutingDetail(
      String recNo,
      String dateSpray,
      String areaScouted,
      String noPlants,
      String observed,
      String problem,
      String solution,
      String scout,
      ) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."scoutingDetails" ("recNo","dateSpray","areaScouted","noPlants","observed","problem","solution","scout") VALUES (?,?,?,?,?,?,?,?)',
        [
          recNo,
          dateSpray,
          areaScouted,
          noPlants,
          observed,
          problem,
          solution,
          scout,
        ]);

    return res;
  }

  Future<int> saveBeneficiary(
      String group,
      String status,
      String gender,
      String surname,
      String firstname,
      String dateofbirth,
      String beneficiaryPic,
      String documentType,
      String documentNo,
      String documentPic,
      String mobileNo,
      String email,
      String recNo,
      String txntime,
      String lat,
      String lon,
      String isSynched) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."beneficiary" ("group","status","gender","surname","firstname","dateofbirth","beneficiaryPic","documentType","documentNo","documentPic"'
            '"mobileNo","email","recNo","txntime","lat","lon","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          group,
          status,
          gender,
          surname,
          firstname,
          dateofbirth,
          beneficiaryPic,
          documentType,
          documentNo,
          documentPic,
          mobileNo,
          email,
          recNo,
          txntime,
          lat,
          lon,
          isSynched
        ]);

    return res;
  }

  Future<int> saveGroup(
      String group,
      String selectFA,
      String clientRef,
      String recNo,
      String txntime,
      String lat,
      String lon,
      String isSynched) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."group" ("group","selectFA","clientRef","recNo","txntime","lat","lon","isSynched") VALUES (?,?,?,?,?,?,?,?)',
        [group, selectFA, clientRef, recNo, txntime, lat, lon, isSynched]);

    return res;
  }

  Future<int> saveIndividual(
      String selectFA,
      String clientRef,
      String gender,
      String surname,
      String firstname,
      String dateofbirth,
      String beneficiaryPic,
      String documentType,
      String documentNo,
      String documentPic,
      String mobileNo,
      String email,
      String recNo,
      String txntime,
      String lat,
      String lon,
      String isSynched) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."beneficiary" ("selectFA","clientRef","gender","surname","firstname","dateofbirth","beneficiaryPic","documentType","documentNo","documentPic"'
            '"mobileNo","email","recNo","txntime","lat","lon","isSynched") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          selectFA,
          clientRef,
          gender,
          surname,
          firstname,
          dateofbirth,
          beneficiaryPic,
          documentType,
          documentNo,
          documentPic,
          mobileNo,
          email,
          recNo,
          txntime,
          lat,
          lon,
          isSynched
        ]);

    return res;
  }

  Future<int> saveFarmerRegistration(
      String fName,
      String farmerId,
      String gender,
      String Age,
      String phoneNo,
      String cropname,
      String country,
      String state,
      String district,
      String city,
      String village,
      String photo,
      String IdProofphoto,
      String IdProofTimeStamp,
      String email,
      String noOfMembers,
      String adultCntSiteFe,
      String schoolChildFe,
      String childCntSiteFe,
      String education,
      String assemnt,
      String houseType,
      String houseOwnership,
      String isSynched,
      String timeStamp,
      String longitude,
      String latitude,
      String idProofVal,
      String cropCategory, //cropCategory
      String lName,
      String farmerCode,
      String farmerCategory,
      String customVillageName,
      String ctName, // ctName as company Name
      String objective, // objective as Register Certificate
      String trader, // trader as KRN PIN
      String farmerType,
      String dob,
      String otherElectric,//otherElectric as cropVariety
      String police_station) //police_station as farmOwnership
  async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farmer" ("fName","farmerId","gender","Age","phoneNo","cropname","country","state","district","city","village","photo","IdProofphoto","IdProofTimeStamp","email","noOfMembers","adultCntSiteFe","schoolChildFe","childCntSiteFe","education","assemnt","houseType","houseOwnership","isSynched","timeStamp","longitude","latitude","idProofVal","cropCategory","lName","farmerCode","farmerCategory","customVillageName","ctName","objective","trader","farmerType","dob","otherElectric","police_station") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          fName,
          farmerId,
          gender,
          Age,
          phoneNo,
          cropname,
          country,
          state,
          district,
          city,
          village,
          photo,
          IdProofphoto,
          IdProofTimeStamp,
          email,
          noOfMembers,
          adultCntSiteFe,
          schoolChildFe,
          childCntSiteFe,
          education,
          assemnt,
          houseType,
          houseOwnership,
          isSynched,
          timeStamp,
          longitude,
          latitude,
          idProofVal,
          cropCategory,
          lName,
          farmerCode,
          farmerCategory,
          customVillageName,
          ctName,
          objective,
          trader,
          farmerType,
          dob,
          otherElectric,
          police_station
        ]);
    return res;
  }

  Future<int> saveFarmRegistration(
      String farmName,
      String farmIDT,
      String farmerId,
      String farmArea,
      String prodLand,
      String landOwner,
      String landGradient,
      String landTopography,
      String image,
      String isSameFarmerAddress,
      String farmAddress,
      String testPhoto,
      String farmRegNo,
      String isSynched,
      String recptId,
      String longitude,
      String latitude,
      String timeStamp,
      String farmCount,
      String country,
      String state,
      String district,
      String city,
      String village,
      String customVillageName
      //cropCode
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."farm" ("farmName","farmIDT","farmerId","farmArea","prodLand","landOwner","landGradient","landTopography","image","isSameFarmerAddress","farmAddress","testPhoto","farmRegNo","isSynched","recptId","longitude","latitude","timeStamp","farmCount","country","state","district","city","village","customVillageName") VALUES (?,?,?,?,?,?,?,?,'
            '?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?'
            ')',
        [
          farmName,
          farmIDT,
          farmerId,
          farmArea,
          prodLand,
          landOwner,
          landGradient,
          landTopography,
          image,
          isSameFarmerAddress,
          farmAddress,
          testPhoto,
          farmRegNo,
          isSynched,
          recptId,
          longitude,
          latitude,
          timeStamp,
          farmCount,
          country,
          state,
          district,
          city,
          village,
          customVillageName
        ]);
    return res;
  }

  Future<int> saveLandPreparation(
      String txnDate,
      String recNo,
      String isSynched,
      String farmerId,
      String farmId,
      String blockId,
      String doe,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."landPreparation"("txnDate","recNo","isSynched","farmerId","farmId","blockId","doe") VALUES (?,?,?,?,?,?,?)',
        [
          txnDate,
          recNo,
          isSynched,
          farmerId,
          farmId,
          blockId,
          doe,
        ]);
    return res;
  }

  Future<int> landPreparationList(
      String recNo,
      String activity,
      String mode,
      String noOfLab,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main" ."landPreparationDet"("recNo","activity","mode","noOfLab") VALUES(?,?,?,?)',
        [recNo, activity, mode, noOfLab]);

    return res;
  }

  Future<int> sitePreparation(
      String recNo,
      String txnDate,
      String isSynched,
      String farmerId,
      String farmId,
      String prevCrop,
      String envAss,
      String envAssPhoto,
      String riskAss,
      String riskAssPhoto,
      String solAnly,
      String solAnlyPhoto,
      String waterAnly,
      String waterAnlyPhoto,
      String blockId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main" ."sitePreparation"("recNo","txnDate","isSynched","farmerId","farmId","prevCrop","envAss","envAssPhoto","riskAss","riskAssPhoto","solAnly","solAnlyPhoto","waterAnly","waterAnlyPhoto","blockId") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          txnDate,
          isSynched,
          farmerId,
          farmId,
          prevCrop,
          envAss,
          envAssPhoto,
          riskAss,
          riskAssPhoto,
          solAnly,
          solAnlyPhoto,
          waterAnly,
          waterAnlyPhoto,
          blockId
        ]);

    return res;
  }

  Future<int> saveSpray(SprayInsert sprayValues) async {
    var dbClient = await db;
    int res = await dbClient.insert("spray", sprayValues.toMap());
    return res;
  }

  /*Get Spray Values From Spray Table*/
  Future<List<SprayInsert>> getSpray(String custTxnsRefId) async {
    var dbClient = await db;
    List<Map> sprayList = await dbClient.rawQuery('SELECT * FROM spray');
    List<SprayInsert> sprayValues = [];

    if (sprayList.length > 0) {
      for (int i = 0; i < sprayList.length; i++) {
        var sprayModel = new SprayInsert(
          sprayList[i]["recommendation"],
          sprayList[i]["farmerId"],
          sprayList[i]["farmId"],
          sprayList[i]["plantingId"],
          sprayList[i]["blockId"],
          sprayList[i]["sprayDate"],
          sprayList[i]["chemicalName"],
          sprayList[i]["Dosage"],
          sprayList[i]["uom"],
          sprayList[i]["operatorName"],
          sprayList[i]["sprayerNumber"],
          sprayList[i]["equipmentType"],
          sprayList[i]["applicationMethod"],
          sprayList[i]["chemicalPhi"],
          sprayList[i]["TrainingStatus"],
          sprayList[i]["agrovert"],
          sprayList[i]["lastDate"],
          sprayList[i]["isSynched"],
          sprayList[i]["recNo"],
          sprayList[i]["diseaseTargeted"],
          sprayList[i]["activeIng"],
          sprayList[i]["endSprayDate"],
          sprayList[i]["oprMedRpt"],
        );

        sprayValues.add(sprayModel);
      }
    } else {}
    return sprayValues;
  }

  Future<int> saveHarvest(
      String farmerId,
      String farmId,
      String blockId,
      String plantingId,
      String harvestDate,
      String noofStem,
      String quantityharvested,
      String harvestedYields,
      String expectedYield,
      String harvesterName,
      String harvestEquipment,
      String NofUnits,
      String packingUnit,
      String colCenter,
      String produceId,
      String phiObservation,
      String season,
      String recNo,
      String isSynched,
      String cropCode,
      String cropVariety,
      String blockName,
      String weightType,
      String txnDate) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."cropHarvest" ("farmerId","farmId","blockId","plantingId","harvestDate","noofStem","quantityharvested","harvestedYields","expectedYield","harvesterName","harvestEquipment","NofUnits","packingUnit","colCenter","produceId","phiObservation","season","recNo","isSynched","cropCode","cropVariety","blockName","weightType","txnDate") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmId,
          blockId,
          plantingId,
          harvestDate,
          noofStem,
          quantityharvested,
          harvestedYields,
          expectedYield,
          harvesterName,
          harvestEquipment,
          NofUnits,
          packingUnit,
          colCenter,
          produceId,
          phiObservation,
          season,
          recNo,
          isSynched,
          cropCode,
          cropVariety,
          blockName,
          weightType,
          txnDate
        ]);
    return res;
  }

  Future<int> saveProductReception(
      String txnDate,
      String pHouseId,
      String totWeight,
      String truckType,
      String truckNumber,
      String driverName,
      String driverNo,
      String driverNote,
      String isSynched,
      String season,
      String recNo,
      String batchNo,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."productReception" ("txnDate","pHouseId","totWeight","truckType","truckNumber","driverName","driverNo","driverNote","isSynched","season","recNo","batchNo") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          txnDate,
          pHouseId,
          totWeight,
          truckType,
          truckNumber,
          driverName,
          driverNo,
          driverNote,
          isSynched,
          season,
          recNo,
          batchNo
        ]);
    return res;
  }

  Future<int> saveProductReceptionDetail(
      String blockId,
      String pCode,
      String vCode,
      String transWt,
      String recWt,
      String recUnit,
      String noOfUnit,
      String recNo,
      String blockName,
      String pName,
      String vName,
      String farmerId,
      String farmerName,
      String farmId,
      String farmName,
      String batchNo,
      String stateCode,
      String stateName,
      String plantingId,
      String lossWt,
      String qrUniqId,
      String sortingId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."productReceptionDetails" ("blockId","pCode","vCode","transWt","recWt","recUnit","noOfUnit","recNo","blockName","pName","vName","farmerId","farmerName","farmId","farmName","batchNo","stateCode","stateName","plantingId","lossWt","qrUniqId","sortingId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          blockId,
          pCode,
          vCode,
          transWt,
          recWt,
          recUnit,
          noOfUnit,
          recNo,
          blockName,
          pName,
          vName,
          farmerId,
          farmerName,
          farmId,
          farmName,
          batchNo,
          stateCode,
          stateName,
          plantingId,
          lossWt,
          qrUniqId,
          sortingId
        ]);
    return res;
  }

  Future<int> saveQRDetails(
      String qrCode,
      String stkType,
      String qrDate,
      String qrString,
      String detString,
      String farmerName,
      String plantingID,
    ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."qrDetails" ("qrCode","stkType","qrDate","qrString","detString" ,"blockID","plantingID") VALUES (?,?,?,?,?,?,?)',
        [
          qrCode,
          stkType,
          qrDate,
          qrString,
          detString,
          farmerName,
          plantingID,
        ]);
    return res;
  }

  Future<int> saveSorting(
      String sorDate,
      String farmerId,
      String farmId,
      String rejectedqty,
      String sortedqty,
      String recNo,
      String isSynched,
      String season,
      String blockId,
      String plantingId,
      String harvestDate,
      String harvestqty,
      String truckType,
      String truckNumber,
      String driverName,
      String driverNo,
      String stateCode,
      String stateName,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."sorter" ("sorDate","farmerId","farmId","rejectedqty","sortedqty","recNo","isSynched","season","blockId","plantingId","harvestDate","harvestqty","truckType","truckNumber","driverName","driverNo","stateCode","stateName") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          sorDate,
          farmerId,
          farmId,
          rejectedqty,
          sortedqty,
          recNo,
          isSynched,
          season,
          blockId,
          plantingId,
          harvestDate,
          harvestqty,
          truckType,
          truckNumber,
          driverName,
          driverNo,
          stateCode,
          stateName
        ]);
    return res;
  }

  Future<int> shipmentDocDetails(String docName ,String docPath, String recNo) async{
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."shipmentDocDetails" ("docName","docPath","recNo") VALUES (?,?,?)',
        [
          docName,
          docPath,
          recNo
        ]);

    return res;

  }



  Future<int> Shipment(
      String shipDate,
      String packHouseId,
      String expLicNo,
      String buyer,
      String consNo,
      String totQty,
      String recNo,
      String isSynched,
      String kenyaCode,
      String season,
      String traceCode,
      String destination,
      String destinationCode,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."shipment" ("shipDate","packHouseId","expLicNo","buyer","consNo","totQty","recNo","isSynched","kenyaCode","season","traceCode","destination","destinationCode") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          shipDate,
          packHouseId,
          expLicNo,
          buyer,
          consNo,
          totQty,
          recNo,
          isSynched,
          kenyaCode,
          season,
          traceCode,
          destination,
          destinationCode
        ]);

    return res;
  }

  Future<int> ShipmentDetail(
      String lotNo,
      String produce,
      String variety,
      String lotQty,
      String packUnit,
      String packQty,
      String recNo,
      String blockId,
      String plantingId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."shipmentDetails" ("lotNo","produce","variety","lotQty","packUnit","packQty","recNo","blockId","plantingId") VALUES (?,?,?,?,?,?,?,?,?)',
        [
          lotNo,
          produce,
          variety,
          lotQty,
          packUnit,
          packQty,
          recNo,
          blockId,
          plantingId
        ]);

    return res;
  }

  Future<int> savePacking(String packingData, String packingId, String lotNo,
      String recNo, String isSynched, String packerName) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."packHouse" ("packingDate","packingId","lotNo","recNo","isSynched","packerName") VALUES (?,?,?,?,?,?)',
        [
          packingData,
          packingId,
          lotNo,
          recNo,
          isSynched,
          packerName,
        ]);
    return res;
  }

  Future<int> savePackingDetail(
      String farmerId,
      String farmerName,
      String farmId,
      String farmName,
      String recBatchNo,
      String blockId,
      String blockName,
      String pCode,
      String pName,
      String vCode,
      String vName,
      String actQty,
      String packedQty,
      String price,
      String prodVal,
      String bestBeforeDate,
      String county,
      String recNo,
      String lotNo,
      String stateCode,
      String stateName,
      String rejectedQty,
      String plantingId,
      String qrUniqId) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."packHouseDetails" ("farmerId","farmerName","farmId","farmName","recBatchNo","blockId","blockName","pCode","pName","vCode","vName","actQty","packedQty","price","prodVal","bestBeforeDate","county","recNo","lotNo","stateCode","stateName","rejectedQty","plantingId","qrUniqId") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmerName,
          farmId,
          farmName,
          recBatchNo,
          blockId,
          blockName,
          pCode,
          pName,
          vCode,
          vName,
          actQty,
          packedQty,
          price,
          prodVal,
          bestBeforeDate,
          county,
          recNo,
          lotNo,
          stateCode,
          stateName,
          rejectedQty,
          plantingId,
          qrUniqId
        ]);
    return res;
  }

  Future<int> saveBlockRegistration(
      String farmerId,
      String farmId,
      String blockId,
      String season,
      String recNo,
      String isSynched,
      String blockArea,
      String blockName,
      String txnDate) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."blockDetails" ("farmerId","farmId","blockId","season","recNo","isSynched","blockArea","blockName","txnDate") VALUES (?,?,?,?,?,?,?,?,?)',
        [
          farmerId,
          farmId,
          blockId,
          season,
          recNo,
          isSynched,
          blockArea,
          blockName,
          txnDate
        ]);
    return res;
  }

  Future<int> saveBlockAreaPlotting(
      String farmerId,
      String farmId,
      String blockId,
      String longitude,
      String OrderOFGPS,
      String latitude,
      String reciptId,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."block_GPSLocation_Details" ("farmerId","farmId","blockId","longitude","OrderOFGPS","latitude","reciptId")VALUES (?,?,?,?,?,?,?)',
        [
          farmerId,
          farmId,
          blockId,
          longitude,
          OrderOFGPS,
          latitude,
          reciptId,
        ]);
    return res;
  }



  Future<int> saveTransferProduct(
      String transferDate,
      String exporter,
      String transferFrom,
      String transferTo,
      String truck,
      String driver,
      String licenseNo,
      String transferID,
      String isSynched,
      String recNo,
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."transferProduct" ("transferDate","exporter","transferFrom","transferTo","truck","driver","licenseNo","transferID","isSynched","recNo") VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          transferDate,
          exporter,
          transferFrom,
          transferTo,
          truck,
          driver,
          licenseNo,
          transferID,
          isSynched,
          recNo,
        ]);
    return res;
  }

  Future<int> saveTransferProductDetail(
      String recNo,
      String batchNo,
      String blockId,
      String plantingId,
      String pCode,
      String vCode,
      String transWt,
      String blockName,
      String pName,
      String vName,
      String farmerName,
      String farmerId,
      String farmName,
      String farmId,
      String stateCode,
      String stateName,
      String availableWt) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."transferProductDetail" ("recNo","batchNo","blockId","plantingId","pCode","vCode","transWt","blockName","pName","vName","farmerName","farmerId","farmName","farmId","stateCode","stateName","availableWt") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          batchNo,
          blockId,
          plantingId,
          pCode,
          vCode ,
          transWt,
          blockName,
          pName,
          vName,
          farmerName,
          farmerId,
          farmName,
          farmId,
          stateCode,
          stateName,
          availableWt
        ]);
    return res;
  }



  Future<int> saveReceptionProduct(
      String receiptId,
      String transferDate,
      String transferFrom,
      String transferTo,
      String truck,
      String driver,
      String licenseNo,
      String isSynched,
      String recNo,
      String txnDate,
      String recBatchNo
      ) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."receptionProduct" ("receiptId","transferDate","transferFrom","transferTo","truck","driver","licenseNo","isSynched","recNo","txnDate","recBatchNo") VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          receiptId,
          transferDate,
          transferFrom,
          transferTo,
          truck,
          driver,
          licenseNo,
          isSynched,
          recNo,
          txnDate,
          recBatchNo
        ]);
    return res;
  }


  Future<int> saveReceptionProductDetail(
      String recNo,
      String batchID,
      String blockID,
      String plantingID,
      String product,
      String variety,
      String transferWt,
      String receivedWt,
      String  blockName,
      String farmerName,
      String farmerId,
      String farmName,
      String farmId,
      String stateCode,
      String stateName,
      String vName,
      String pName,
      String recordNo) async {
    var dbClient = await db;

    int res = await dbClient.rawInsert(
        'INSERT INTO "main"."receptionProductDetail" ("recNo","batchNo","blockId","plantingId","pCode","vCode","transWt","recWt","blockName","farmerName","farmerId","farmName","farmId","stateCode","stateName","vName","pName","recordNo") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          recNo,
          batchID,
          blockID,
          plantingID,
          product,
          variety,
          transferWt,
          receivedWt,
          blockName,
          farmerName,
          farmerId,
          farmName,
          farmId,
          stateCode,
          stateName,
          vName,
          pName,
          recordNo
        ]);
    return res;
  }
}






