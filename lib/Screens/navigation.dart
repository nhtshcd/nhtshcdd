import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Database/Model/AnimalCatalogModel.dart';
import 'package:nhts/Database/Model/CropListmodel.dart';
import 'package:nhts/Database/Model/FarmerMaster.dart';
import 'package:nhts/Plugins/RestPlugin.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/ResponseModel/Croplistvalues.dart';
import 'package:nhts/ResponseModel/FarmResponseModel.dart';
import 'package:nhts/ResponseModel/SynchDownload.dart';
import 'package:nhts/ResponseModel/farmerlistresponse.dart';
import 'package:nhts/Screens/ChangePassword.dart';
import 'package:nhts/Screens/IncomingShipment.dart';
import 'package:nhts/Screens/LandPreparation.dart';
import 'package:nhts/Screens/PackingScreen.dart';
import 'package:nhts/Screens/PlantingScreen.dart';
import 'package:nhts/Screens/ProductTransfer.dart';
import 'package:nhts/Screens/ScoutingScreen.dart';
import 'package:nhts/Screens/farmRegistration.dart';
import 'package:nhts/Screens/farmerRegistration.dart';
import 'package:nhts/Screens/harvest.dart';
import 'package:nhts/Screens/recentQrs.dart';
import 'package:nhts/Screens/shipment.dart';
import 'package:nhts/Screens/sorting.dart';
import 'package:nhts/Screens/spray.dart';
import 'package:nhts/Screens/transactionsummary.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:nhts/main.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_extend/share_extend.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import 'ProductReception.dart';
import 'SitePreparationScreen.dart';
import 'blockscreen.dart';
import 'farmerlist.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  String name, agentid;

  DashBoard(
    this.name,
    this.agentid,
  );

  @override
  _DashBoardAppState createState() => _DashBoardAppState();
}

class _DashBoardAppState extends State<DashBoard> with WidgetsBindingObserver {
  var db = DatabaseHelper();
  farmerlistresponsemodel? farmers;
  Croplistvalues? croplistvalues;
  bool _internetconnection = false;
  bool isTranslation = false;
  List<String> _events = [];
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  bool datadownload = false;
  String loadingstring = 'Loading';
  bool removedummy = true;
  String appversion = "-";
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  String transactioncount = '0';
  bool synced = false;
  bool updateAvl = false;
  List<String> menus = [];
  String ReceptionatPackhouseLabel = ' Reception at Packhouse';
  String logout = 'Logout';
  String rulogout = 'Are you sure want to Logout?';
  String exit = 'Exit';
  String okLabel = 'Ok';
  String ruexit = 'Are you sure want to Exit the App?';
  String availupd = 'Update Available';
  String appavl = 'An Application update available Please logout';
  String version = 'Version';
  String no = 'No';
  String yes = 'Yes';
  String sync = 'Sync';
  String home = 'Home';
  String setting = 'Settings';
  String chngpswd = 'Change Password';
  String pendtxn = 'Pending transaction';
  String processing = 'Processing';
  String paltion = 'Palletization';
  String shpmntgen = 'Shipment Generation';
  String frmrlst = 'Farmer List';
  String txnsum = 'Transaction Summary';
  String packinglabel = 'Packing';
  bool isLoading = false;
  String agentType = "";
  String passwordCreatedDate = "";
  String remPassword = "";
  String agePassword = "";
  String exportStatus = "";
  String exportedExpireDate = "";
  String todayDate = "";
  String expireDate = "";
  bool passwordExpire = false;
  bool rememberDaysStart = false;
  String expiredDate = "";
  String exporterAndAgentName = "";
  bool nameLoaded = false;
  bool validExporter = false;
  String exportLicenseNo = "";

  String? _dir1;
  String _zipPath = 'https://coderzheaven.com/youtube_flutter/images.zip';
  String _localZipFileName = 'images.zip';
  var fileZip;

  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    getAgentPassword();
    getAgentType();
    GetAppversion();
    backgroundfetch();
    GetDatas();

    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.green, // status bar color
    ));

    final now = DateTime.now();
    currentdate = DateFormat('dd MMM, yyyy').format(now);
    todayDate = DateFormat('dd-MM-yyyy').format(now);
    currenttime = DateFormat('hh:mm:a').format(now);
    var CURRENTTIME = currenttime.split(':');
    if (CURRENTTIME[2] == 'AM') {
      timetype = 'Good Morning..';
    } else {
      int hour = int.parse(CURRENTTIME[0]);
      if (hour > 4) {
        timetype = 'Good Evening..';
      } else {
        timetype = 'Good Afternoon..';
      }
    }

    checkpendingtransaction();
    checkLatestVersion();
  }

  void getAgentType() async {
    print("getagenttypecalled");
    String? agentid = await SecureStorage().readSecureData("agentType");
    String? expDate =await SecureStorage().readSecureData("expDate");
    String? expStatus =await SecureStorage().readSecureData("expStatus");
    String? expLic =await SecureStorage().readSecureData("expLic");
    setState(() {
      agentType = agentid!;
      exportStatus = expStatus!;
      exportedExpireDate = expDate!;
      exportLicenseNo = expLic!;
    });
    print("exportLicenseNo_exportLicenseNo" + expStatus!);
    exporterDateComparsion(exportedExpireDate);
  }

  void getAgentPassword() async {
    print("getAgentDetails");
    List<Map> agents = await db.RawQuery(
        'SELECT exportLic,exportStatus,exportLicDate, pwExpDays,pwDate,agentType,pwRemainder,exporterName,agentName FROM agentMaster');
    setState(() {
      if (agents.length > 0) {
        String expiredDate = agents[0]['pwExpDays'];
        String age = agents[0]['pwDate'];
        String remDays = agents[0]['pwRemainder'];
        agentType = agents[0]['agentType'];
        String agentName = agents[0]['agentName'];
        String exporterName = agents[0]['exporterName'];
        exportStatus = agents[0]['exportStatus'];
        exportedExpireDate = agents[0]['exportLicDate'];
        exportLicenseNo = agents[0]['exportLic'];

        exporterAndAgentName = agentName + " " + " - " + " " + exporterName;
        print("exporterAndAgentName" + exporterAndAgentName.toString());
        nameLoaded = true;
        expireDateComparison(expiredDate, age, remDays);
      }
    });
    if (passwordExpire) {
      errordialog(context, "Information", "Password Expired");
    } else if (rememberDaysStart) {
      errordialog(context, "Information",
          "Password Expires on" + " " + expireDate.toString());
    }
  }

  void backgroundfetch() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      try {
        if (_internetconnection) {
          print("CHECKSERVICE " + "CHECKSERVICESS");
          TxnExecutor txnExecutor = TxnExecutor();
          txnExecutor.CheckCustTrasactionTable();
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void translate() async {
    try {
      String? Lang = '';
      try {
        Lang =await SecureStorage().readSecureData("langCode");
        print("CHECK_LANGUAGE 2: " + Lang!);
      } catch (e) {
        Lang = 'en';
      }

      String qry =
          'select * from labelNamechange where tenantID =  \'malishi\' and lang = \'' +
              Lang +
              '\'';
      // print('transList2 ' + qry);
      List transList = await db.RawQuery(qry);
      // print('transList2 ' + transList.toString());
      for (int i = 0; i < transList.length; i++) {
        String classname = transList[i]['className'];
        String labelName = transList[i]['labelName'];
        switch (classname) {
          case "recpph":
            setState(() {
              ReceptionatPackhouseLabel = labelName;
            });
            break;
          case "logout":
            setState(() {
              logout = labelName;
            });
            break;
          case "rulogout":
            setState(() {
              rulogout = labelName;
            });
            break;
          case "exit":
            setState(() {
              exit = labelName;
            });
            break;
          case "exitapp":
            setState(() {
              ruexit = labelName;
            });
            break;
          case "updavl":
            setState(() {
              availupd = labelName;
            });
            break;
          case "appavl":
            setState(() {
              appavl = labelName;
            });
            break;
          case "ok":
            setState(() {
              okLabel = labelName;
            });
            break;
          case "version":
            setState(() {
              version = labelName;
            });
            break;
          case "no":
            setState(() {
              no = labelName;
            });
            break;
          case "yes":
            setState(() {
              yes = labelName;
            });
            break;
          case "syn":
            setState(() {
              sync = labelName;
            });
            break;
          case "home":
            setState(() {
              home = labelName;
            });
            break;
          case "setting":
            setState(() {
              setting = labelName;
            });
            break;
          case "chngpswd":
            setState(() {
              chngpswd = labelName;
            });
            break;
          case "pendtxn":
            setState(() {
              pendtxn = labelName;
            });
            break;
          case "processing":
            setState(() {
              processing = labelName;
            });
            break;
          case "paltion":
            setState(() {
              paltion = labelName;
            });
            break;
          case "shpmntgen":
            setState(() {
              shpmntgen = labelName;
            });
            break;
          case "frmrlst":
            setState(() {
              frmrlst = labelName;
            });
            break;
          case "txnsum":
            setState(() {
              txnsum = labelName;
            });
            break;
          case "packing":
            setState(() {
              packinglabel = labelName;
            });
            break;
        }
      }

      drawerlist = [];
      drawerlist.add(DrawerListModel(name: home, iconData: Icons.home));
      //
      // drawerlist.add(DrawerListModel(name: setting, iconData: Icons.settings));
      drawerlist
          .add(DrawerListModel(name: chngpswd, iconData: Icons.phonelink_lock));
      drawerlist.add(
          DrawerListModel(name: "Export Data", iconData: Icons.import_export));
      drawerlist
          .add(DrawerListModel(name: logout, iconData: Icons.lock_outline));

      if (agentType == "01") {
        setState(() {
          menus = [];
          menus.add('Farmer Registration');
          menus.add('Farm Registration');
          menus.add("Block Registration");
          menus.add("Site Selection");
          menus.add("Land Preparation");
          menus.add("Planting");
          menus.add("Scouting");
          menus.add("Spraying");
          menus.add("Harvest");
          menus.add("Sorting");
          menus.add("QR Images");
          menus.add(frmrlst);
          menus.add(txnsum);
          isTranslation = true;
        });
      } else if (agentType == "02") {
        setState(() {
          menus = [];
          menus.add("Incoming Shipment");
          menus.add("Product Transfer");
          menus.add("Product Reception");
          menus.add("Packing Operations");
          menus.add("Shipment");
          menus.add("QR Images");
          menus.add(txnsum);
          isTranslation = true;
        });
      } else {
        setState(() {
          menus = [];
          menus.add('Farmer Registration');
          menus.add('Farm Registration');
          menus.add("Block Registration");
          menus.add("Site Selection");
          menus.add("Land Preparation");
          menus.add("Planting");
          menus.add("Scouting");
          menus.add("Spraying");
          menus.add("Harvest");
          menus.add("Sorting");
          menus.add("Incoming Shipment");
          menus.add("Product Transfer");
          menus.add("Product Reception");
          menus.add("Packing Operations");
          menus.add("Shipment");
          menus.add("QR Images");

          menus.add(frmrlst);
          menus.add(txnsum);
          isTranslation = true;
        });
      }
    } catch (e) {
      print('translation err' + e.toString());
      //toast(e.toString());
    }
  }

  Future<void> GetAppversion() async {
    print("getAppversion+++++++++");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appversion = packageInfo.version;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state ' + state.toString());
    switch (state) {
      case AppLifecycleState.resumed:
        print('lifecycle resume');
        break;
      case AppLifecycleState.inactive:
        print('lifecycle inactive');
        break;
      case AppLifecycleState.paused:
        print('lifecycle paused');
        break;
      case AppLifecycleState.detached:
        print('lifecycle detached');
        break;
    }
  }

  TabController? tabController;
  static const PrimaryColor = Colors.green;
  String currentdate = "  ";
  String currenttime = "  ";
  String timetype = " ";
  Map<String, double> dataMap = Map();
  List<Color> colorList = [];
  List list = [];
  String pendingTransaction = '0';

  List<String> menuimage = [
    "images/farmerenrollment.svg",
    "images/farmenrollment.svg",
    "images/harvest.svg",
    "images/sitepreparation.svg",
    "images/landpreparation.svg",
    "images/planting.svg",
    "images/scouting.svg",
    "images/spraying.svg",
    "images/harvest.svg",
    "images/sorting.svg",
    "images/sorting.svg",
    "images/farmerslist.svg",
    "images/tranxsummary.svg",
  ];

  List<String> menuimage2 = [
    "images/incomingshipment.svg",
    "images/productTransfer.svg",
    "images/receive.svg",
    "images/packing.svg",
    "images/shipment.svg",
    "images/shipment.svg",
    "images/tranxsummary.svg",
  ];

  List<String> menuimage3 = [
    "images/farmerenrollment.svg",
    "images/farmenrollment.svg",
    "images/harvest.svg",
    "images/sitepreparation.svg",
    "images/landpreparation.svg",
    "images/planting.svg",
    "images/scouting.svg",
    "images/spraying.svg",
    "images/harvest.svg",
    "images/sorting.svg",
    "images/incomingshipment.svg",
    "images/productTransfer.svg",
    "images/receive.svg",
    "images/packing.svg",
    "images/shipment.svg",
    "images/shipment.svg",
    "images/farmerslist.svg",
    "images/tranxsummary.svg",
  ];

  List drawerlist = [];
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  void fetchData() async {
    var db = DatabaseHelper();
    list = await db.getCatelog();
    print('CHECKLISST ' + (list.toString()));
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('InternetException ' + e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      switch (result) {
        case ConnectivityResult.wifi:
          _internetconnection = true;
          print('internetconnection wifi');
          var db = DatabaseHelper();
          List<Map> custTransactions =
              await db.GetTableValues('custTransactions');
          print('custTransactionscount ' + custTransactions.length.toString());
          if (custTransactions.length == 0) {
            Download322Datas();
          } else {
            // _progressHUD.state.show();
            // _progressHUD.state.dismiss();
            // TxnExecutor txnExecutor = new TxnExecutor();
            // txnExecutor.CheckCustTrasactionTable();
          }

          break;
        case ConnectivityResult.mobile:
          print('internetconnection mobile');
          setState(() async {
            _internetconnection = true;
            var db = DatabaseHelper();
            List<Map> custTransactions =
                await db.GetTableValues('custTransactions');
            // _progressHUD.state.dismiss();
            if (custTransactions.length == 0) {
              Download322Datas();
              print('Download322Datas2');
            } else {
              // TxnExecutor txnExecutor = new TxnExecutor();
              // txnExecutor.CheckCustTrasactionTable();
            }
          });
          break;
        case ConnectivityResult.none:
          isLoading = false;
          setState(() {
            print('internetconnection none');
            _internetconnection = false;
            _connectionStatus = 'No internet connection';
          });
          break;
        default:
          isLoading = false;
          setState(() {
            print('internetconnection defualt');
            _internetconnection = false;
            _connectionStatus = 'Failed to get connectivity.';
          });
          break;
      }
    } catch (Exc) {
      print("Internet exception err: " + Exc.toString());
    }
  }

  void GetFarmerdataDB() async {
    var db = DatabaseHelper();
//    List<FarmerMaster> farmermaster = new List();
    List<FarmerMaster> farmermaster = await db.GetFarmerdata();

    for (int i = 0; i < farmermaster.length; i++) {}
  }

  void getVarietyDB() async {
    var db = DatabaseHelper();
//    List<FarmerMaster> farmermaster = new List();
    List<Map> vareity = await db.GetVariety();
    print('VarietyDB ' + vareity.toString());
  }

  Future<void> Download322Datas() async {
   try {
      isLoading = true;
      restplugin rest = restplugin();
      String response = await rest.Download322();
        print("Download322 response value " + response);
      Map<String, dynamic> json = jsonDecode(response);

      SynchDownload clientmodel = SynchDownload.fromJson(json);

      String? agentid =await SecureStorage().readSecureData("agentId");

      //agentLogin
      String farmerrevno =
          clientmodel.response!.body!.agentLogin!.farmerRevNo!.toString();
      String farmRevNo =
          clientmodel.response!.body!.agentLogin!.farmRevNo!.toString();
      String fCropRevNo =
          clientmodel.response!.body!.agentLogin!.fCropRevNo!.toString();
      String currentSeasonCode =
          clientmodel.response!.body!.agentLogin!.currentSeasonCode!;

      /* for (int i = 0;
      i < clientmodel.response.body.agentLogin.samithis.length;
      i++) {
        String samcode =
            clientmodel.response.body.agentLogin.samithis[i].samCode;

        db.DeleteTableRecord('agentSamiteeList', 'samCode', samcode);
        db.SaveSamitee(samcode);
      }
      List<Map> agentSamiteeList = await db.GetTableValues('agentSamiteeList');
      print('agentSamiteeList ' + agentSamiteeList.toString());*/
//    if(farmerrevno=='0'){
//      db.DeleteTableRecord('agentMaster', 'agentId', agentid);
//    }
      db.UpdateTableRecord(
          'agentMaster',
          'latestFarmerRevNo =\'' +
              farmerrevno +
              "\'," +
              'latestFarmRevNo =\'' +
              farmRevNo +
              "\'," +
              'latestFarmCropRevNo =\'' +
              fCropRevNo +
              "\'," +
              'currentSeasonCode =\'' +
              currentSeasonCode +
              "\'",
          'agentId',
          agentid!);

      // key 10 supplierdownload
      //String suprevno = clientmodel.response.body.data10.supRevNo;
      /*db.UpdateTableValue(
          'agentMaster', 'supplierDwRev', suprevno, 'agentId', agentid);
      // key 7 buyer download
      String byrRevNo = clientmodel.response.body.data7.byrRevNo;
      db.RawUpdate('DELETE FROM buyerList');
      // db.UpdateTableValue(
      //     'agentMaster', 'seasonDwRev', seasonRevNo, 'agentId', agentid);
      for (int i = 0; i < clientmodel.response.body.data7.byrList.length; i++) {
        String byrId = clientmodel.response.body.data7.byrList[i].byrId;
        String byrName = clientmodel.response.body.data7.byrList[i].byrName;
        String year = '';


        db.SavebuyerList(byrId, byrName);
      }
      // key 1 seasons
      String seasonRevNo = clientmodel.response.body.data1.seasonRevNo;
      db.UpdateTableValue(
          'agentMaster', 'seasonDwRev', seasonRevNo, 'agentId', agentid);
      for (int i = 0; i < clientmodel.response.body.data1.seasons.length; i++) {
        String sCode = clientmodel.response.body.data1.seasons[i].sCode;
        String sName = clientmodel.response.body.data1.seasons[i].sName;
        String year = '';

        db.RawUpdate('DELETE FROM seasonYear Where seasonId = \'' +
            sCode +
            '\' AND year = \'' +
            year +
            '\'');
        db.SaveSeason(sCode, sName, year);
      }
      // key 0 productdownload
      String prodRevNo = clientmodel.response.body.data0.prodRevNo;
      db.UpdateTableValue(
          'agentMaster', 'productDwRev', prodRevNo, 'agentId', agentid);

      for (int i = 0;
      i < clientmodel.response.body.data0.products.length;
      i++) {
        String productCode =
            clientmodel.response.body.data0.products[i].productCode;
        String productName =
            clientmodel.response.body.data0.products[i].productName;
        String categoryName =
            clientmodel.response.body.data0.products[i].categoryName;

        String categoryCode =
            clientmodel.response.body.data0.products[i].categoryCode;
        String price = clientmodel.response.body.data0.products[i].price;
        String unit = clientmodel.response.body.data0.products[i].unit;
        String subcategoryName = '';
        String subcategoryCode = '';
        db.SaveProducts(unit, productCode, subcategoryName, subcategoryCode,
            categoryCode, categoryName, productName, price);
      }

      for (int i = 0;
      i < clientmodel.response.body.data3.stocks.length;
      i++) {
        String categoryCode =
            clientmodel.response.body.data3.stocks[i].cCode;
        String productCode =
            clientmodel.response.body.data3.stocks[i].pCode;
        String stock =
            clientmodel.response.body.data3.stocks[i].stock;
        String batchNo =
            clientmodel.response.body.data3.stocks[i].batchNo;
        String saeson =
            clientmodel.response.body.data3.stocks[i].season;
        String wareHouseName = "";
        String wareHouseCode = "";
        String subCategoryCode = "";
        db.SavewareHouseStocks(categoryCode, productCode, stock, batchNo,
            saeson, wareHouseName, wareHouseCode, subCategoryCode);
      }*/
      db.DeleteTable('pcbpList');
      for (int i = 0;
          i < clientmodel.response!.body!.data3!.pcbpList!.length;
          i++) {
        String dosage = clientmodel.response!.body!.data3!.pcbpList![i].dosage!;
        String cropVariety =
            clientmodel.response!.body!.data3!.pcbpList![i].cropVariety!;
        String chemicalName =
            clientmodel.response!.body!.data3!.pcbpList![i].chemicalName!;
        String cropCat =
            clientmodel.response!.body!.data3!.pcbpList![i].cropCat!;
        String phiIn = clientmodel.response!.body!.data3!.pcbpList![i].phiIn!;
        String crop = clientmodel.response!.body!.data3!.pcbpList![i].crop!;
        String pid = clientmodel.response!.body!.data3!.pcbpList![i].pid!;
        String uom = clientmodel.response!.body!.data3!.pcbpList![i].uom!;

        db.savePcbP(
            dosage, cropVariety, chemicalName, cropCat, phiIn, crop, pid, uom);
      }
      //key 6 procurementproducts
      db.DeleteTable('procurementProducts');
      db.DeleteTable('varietyList');
      db.DeleteTable('procurementGrade');
      db.DeleteTable('calendarCrop');

      for (int i = 0;
          i < clientmodel.response!.body!.data6!.products!.length;
          i++) {
        String ppCode = clientmodel.response!.body!.data6!.products![i].ppCode!;
        String ppName = clientmodel.response!.body!.data6!.products![i].ppName!;
        String crpType = "";
        String msp = "";
        String pmsp = "";
        String unit = clientmodel.response!.body!.data6!.products![i].ppUnit!;

        db.SaveProcurementProducts(ppCode, ppName, crpType, unit, msp, pmsp);

        for (int j = 0;
            j < clientmodel.response!.body!.data6!.products![i].vrtLst!.length;
            j++) {
          String ppVarName = clientmodel
              .response!.body!.data6!.products![i].vrtLst![j].ppVarName!;
          String ppVarCode = clientmodel
              .response!.body!.data6!.products![i].vrtLst![j].ppVarCode!;
          String uom = clientmodel.response!.body!.data6!.products![i].vrtLst![j].uom!;
        /*  String hsCode = clientmodel
              .response!.body!.data6!.products![i].vrtLst![j].hsCode!;*/

          //String estDays = clientmodel.response.body.data6.products[i].vrtLst[j].estDays.toString();
          String estDays = "";
          int saved = await db.saveVariety(
              ppCode, ppVarCode, ppVarName, estDays, uom);
          //  print("ppCode_ppCode" + ppCode.toString());
          // debugPrint("saveVariety " + saved.toString());
          if (clientmodel
                  .response!.body!.data6!.products![i].vrtLst![j].grdLst !=
              null) {
            for (int k = 0;
                k <
                    clientmodel.response!.body!.data6!.products![i].vrtLst![j]
                        .grdLst!.length;
                k++) {
              String ppGraCode = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].ppGraCode!;
              String ppGraName = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].ppGraName!;
              String ppGraPrice = clientmodel.response!.body!.data6!
                  .products![i].vrtLst![j].grdLst![k].ppGraPrice!;
              String estDays = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].estDays!;
              String cropCycle = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].cropCycle!;
              String hsCode = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].hsCode!;
              double? acre = clientmodel.response!.body!.data6!.products![i]
                  .vrtLst![j].grdLst![k].estAcre;
              String estAcre = acre.toString();
              //ppCode as hsCode
              db.SaveProcurementGrade(hsCode, ppGraCode, ppCode, estAcre, ppGraName,
                  ppGraPrice, ppVarCode, cropCycle, estDays);
            }
          }

          /*if (clientmodel
              .response.body.data6.products[i].vrtLst[j].calandarLst !=
              null) {
            print("Cropnotnull");
            for (int cal = 0;
            cal <
                clientmodel.response.body.data6.products[i].vrtLst[j]
                    .calandarLst.length;
            cal++) {
              print("ForloopCalandar");
              String cropSeason = clientmodel.response.body.data6.products[i].vrtLst[j].calandarLst[cal].cropSeason;
              String calActiveMethod = clientmodel.response.body.data6.products[i].vrtLst[j].calandarLst[cal].calActiveMethod;
              String calActiveType = clientmodel.response.body.data6.products[i].vrtLst[j].calandarLst[cal].calActiveType;
              String noOfDays = clientmodel.response.body.data6.products[i].vrtLst[j].calandarLst[cal].noOfDays;
              String calName = clientmodel.response.body.data6.products[i].vrtLst[j].calandarLst[cal].calName;

              print("cropSeason_111" + cropSeason);
              print("calActiveMethod_111" + calActiveMethod);
              print("calActiveType_111" + calActiveType);
              print("noOfDays_111" + noOfDays);
              print("calName_111" + calName);

              db.SaveCalendarCrop(cropSeason, calActiveMethod, calActiveType,
                  ppVarCode, noOfDays, calName);
            }
          }*/
        }
      }
      List<Map> procurementProducts =
          await db.GetTableValues('procurementProducts');
      debugPrint(
          'procurementProducts :' + procurementProducts.length.toString());
      List<Map> varietyList = await db.GetTableValues('varietyList');
      debugPrint('varietyList :' + varietyList.length.toString());
      List<Map> procurementGrade = await db.GetTableValues('procurementGrade');
      debugPrint('procurementGrade :' + procurementGrade.length.toString());
      // key 8 catalogdownload
      String catRevNo = clientmodel.response!.body!.data8!.catRevNo!;
      db.UpdateTableValue(
          'agentMaster', 'latestCatalogRevNo', catRevNo, 'agentId', agentid);
      db.DeleteTable('animalCatalog');
      for (int i = 0;
          i < clientmodel.response!.body!.data8!.catList!.length;
          i++) {
        String catalogId =
            clientmodel.response!.body!.data8!.catList![i].catId!;
        String catalogName =
            clientmodel.response!.body!.data8!.catList![i].catName!;
        String catalogType =
            clientmodel.response!.body!.data8!.catList![i].catType!.toString();
        String parentcatID = '';
        int id = i + 1;
        print('inserting catalog ' + catalogId);
        var catalog = AnimalCatalog(catalogType, catalogName, catalogId,
            id.toString(), parentcatID, "");
        AddCatalogDB(catalog);
      }

      // key 3 exporterdownload

      /* db.DeleteTable('exporter');
    for (int i = 0; i < clientmodel.response!.body!.data3!.exporterList!.length; i++) {
      String regNo = clientmodel.response!.body!.data3!.exporterList![i].regNo!;
      String frmPackHouse = clientmodel.response!.body!.data3!.exporterList![i].frmPackHouse!;
      String comNam = clientmodel.response!.body!.data3!.exporterList![i].comNam!.toString();
      String regProof = clientmodel.response!.body!.data3!.exporterList![i].regProof!.toString();
      String packHouse = clientmodel.response!.body!.data3!.exporterList![i].packHouse!.toString();
      String mobileNo = clientmodel.response!.body!.data3!.exporterList![i].mobileNo!.toString();
      String scattered = clientmodel.response!.body!.data3!.exporterList![i].scattered!.toString();
      String refLet = clientmodel.response!.body!.data3!.exporterList![i].refLet!.toString();
      String expTinNo = clientmodel.response!.body!.data3!.exporterList![i].expTinNo!.toString();
      String rexNo = clientmodel.response!.body!.data3!.exporterList![i].rexNo!.toString();
      String gpsLoc = clientmodel.response!.body!.data3!.exporterList![i].gpsLoc!.toString();
      String frmHavefrms = clientmodel.response!.body!.data3!.exporterList![i].frmHavefrms!.toString();
      String tin = clientmodel.response!.body!.data3!.exporterList![i].tin!.toString();
      String cmpOrient = clientmodel.response!.body!.data3!.exporterList![i].cmpOrient!.toString();
      String toexitPt = clientmodel.response!.body!.data3!.exporterList![i].toexitPt!.toString();
      String ugendaExp = clientmodel.response!.body!.data3!.exporterList![i].ugendaExp!.toString();
      String email = clientmodel.response!.body!.data3!.exporterList![i].email!.toString();

      print('inserting exporter ' + regNo);
      // var exporterDetails = new ExporterDetails(regNo, frmPackHouse, comNam,regProof,packHouse,mobileNo,scattered,
      //     refLet, expTinNo, rexNo,gpsLoc,frmHavefrms,tin,cmpOrient,toexitPt,ugendaExp,email);
      // AddExporterDB(exporterDetails);*/
      //}

      // key 9 samitee
      String coRevNo = clientmodel.response!.body!.data9!.coRevNo!;
      db.UpdateTableValue(
          'agentMaster', 'latestCooperativeRevNo', coRevNo, 'agentId', agentid);
      db.DeleteTable('coOperative');

      for (int i = 0;
          i < clientmodel.response!.body!.data9!.coOperatives!.length;
          i++) {
        String coCode =
            clientmodel.response!.body!.data9!.coOperatives![i].coCode!;
        String coName =
            clientmodel.response!.body!.data9!.coOperatives![i].coName!;
        String coType = clientmodel
            .response!.body!.data9!.coOperatives![i].copTyp!
            .toString();
        db.SavecoOperatives(coCode, coName, coType);
      }

      String vwsRevNo = clientmodel.response!.body!.data10!.vwsRevNo!;
      db.DeleteTable('villageWarehouse');
      for (int i = 0;
          i < clientmodel.response!.body!.data10!.stocks!.length;
          i++) {
        String batchNo =
            clientmodel.response!.body!.data10!.stocks![i].batchNo!;
        String wCode = clientmodel.response!.body!.data10!.stocks![i].wCode!;
        String productName =
            clientmodel.response!.body!.data10!.stocks![i].productName!;
        String sortedWt =
            clientmodel.response!.body!.data10!.stocks![i].sortedWt!;
        String blockId =
            clientmodel.response!.body!.data10!.stocks![i].blockId!;
        String farmerId =
            clientmodel.response!.body!.data10!.stocks![i].farmerId!;
        String lastHarDate =
            clientmodel.response!.body!.data10!.stocks![i].lastHarDate!;
        String wName = clientmodel.response!.body!.data10!.stocks![i].wName!;
        String blockname =
            clientmodel.response!.body!.data10!.stocks![i].blockname!;
        String variety =
            clientmodel.response!.body!.data10!.stocks![i].variety!;
        String pCode = clientmodel.response!.body!.data10!.stocks![i].pCode!;
        String varietyName =
            clientmodel.response!.body!.data10!.stocks![i].varietyName!;
        String grossWt =
            clientmodel.response!.body!.data10!.stocks![i].grossWt!;
        String lossWt = clientmodel.response!.body!.data10!.stocks![i].lossWt!;
        String farmCode =
            clientmodel.response!.body!.data10!.stocks![i].farmCode!;
        String plantingId =
            clientmodel.response!.body!.data10!.stocks![i].plantingId!;
        String stockType =
            clientmodel.response!.body!.data10!.stocks![i].stType!;
        String farmName =
            clientmodel.response!.body!.data10!.stocks![i].farmName!;
        String farmerName =
            clientmodel.response!.body!.data10!.stocks![i].farmerName!;
        String state_name =
            clientmodel.response!.body!.data10!.stocks![i].state_name!;
        String state = clientmodel.response!.body!.data10!.stocks![i].state!;
        String harvestWt =
            clientmodel.response!.body!.data10!.stocks![i].harvestWt!;
        print("harvestWt_harvestWt" + harvestWt.toString());
        String QRBatchNo =
            clientmodel.response!.body!.data10!.stocks![i].QRBatchNo!;
        print("QRBatchNo_QRBatchNo" + QRBatchNo.toString());
        String pkBatchNo =
            clientmodel.response!.body!.data10!.stocks![i].pkBatchNo!;
        print("pkBatchNo_pkBatchNo" + pkBatchNo.toString());

        String transferDate = clientmodel.response!.body!.data10!.stocks![i].ptDate!;
        String transferFrom = clientmodel.response!.body!.data10!.stocks![i].ptTransferFromCode!;
        String transferTo = clientmodel.response!.body!.data10!.stocks![i].ptTransferToCode!;
        String truck = clientmodel.response!.body!.data10!.stocks![i].ptTruckNo!;
        String driver = clientmodel.response!.body!.data10!.stocks![i].ptDriverName!;
        String licenseNo = clientmodel.response!.body!.data10!.stocks![i].ptDriverLicenseNo!;
        String ptTransferToName = clientmodel.response!.body!.data10!.stocks![i].ptTransferToName!;
        String ptTransferFromName = clientmodel.response!.body!.data10!.stocks![i].ptTransferFromName!;
        String bbDate = clientmodel.response!.body!.data10!.stocks![i].bbDate!;
        String lotNumber = "";

        if (stockType == "1") {
          batchNo = QRBatchNo;
        }

        db.saveVillageWarehouse(
            batchNo,
            wCode,
            wName,
            pCode,
            productName,
            variety,
            varietyName,
            grossWt, //actWt
            sortedWt,
            lossWt, //rejWt
            farmerId,
            farmCode,
            blockId,
            plantingId,
            lastHarDate,
            blockname,
            stockType,
            farmerName,
            farmName,
            state,
            state_name,
            lotNumber,
            harvestWt,
            pkBatchNo,
            QRBatchNo,
            transferDate,
            transferFrom,
            transferTo,
            truck,
            driver,
            licenseNo,
            ptTransferToName,
            ptTransferFromName,
          bbDate
        );
        print("villageWarehouse" + QRBatchNo.toString());

      }

      db.DeleteTable('buyerList');

      for (int i = 0;
          i < clientmodel.response!.body!.data11!.byrList!.length;
          i++) {
        String buyerName =
            clientmodel.response!.body!.data11!.byrList![i].byrName!;
        String buyerId = clientmodel.response!.body!.data11!.byrList![i].byrId!;
        String buyersCountry = clientmodel.response!.body!.data11!.byrList![i].buyersCountry!;
        String buyersCountryCode = clientmodel.response!.body!.data11!.byrList![i].buyersCountryCode!;

        db.saveBuyerList(buyerId, buyerName ,buyersCountry,buyersCountryCode);
        print("buyerId" + buyerId);
      }

//      if (locationrevNo == '0') {
      db.DeleteTable('countryList');
      db.DeleteTable('stateList');
      db.DeleteTable('districtList');
      db.DeleteTable('cityList');
      db.DeleteTable('gramPanchayat');
      db.DeleteTable('villageList');

//      }
      if (clientmodel.response!.body!.data2!.countryList != null) {
        for (int i = 0;
            i < clientmodel.response!.body!.data2!.countryList!.length;
            i++) {
          String countryCode =
              clientmodel.response!.body!.data2!.countryList![i].countryCode!;
          String countryName =
              clientmodel.response!.body!.data2!.countryList![i].countryName!;
          // print('countryName ' + countryName);
          int countrysave = await db.SaveCountry(countryCode, countryName);
          // print('countrysave' + countrysave.toString());
          if (clientmodel.response!.body!.data2!.countryList![i].stateList !=
              null) {
            for (int k = 0;
                k <
                    clientmodel.response!.body!.data2!.countryList![i]
                        .stateList!.length;
                k++) {
              String stateCode = clientmodel.response!.body!.data2!
                  .countryList![i].stateList![k].stateCode!;
              String stateName = clientmodel.response!.body!.data2!
                  .countryList![i].stateList![k].stateName!;
              db.SaveState(stateCode, stateName, countryCode);
              if (clientmodel.response!.body!.data2!.countryList![i]
                      .stateList![k].districtList !=
                  null) {
                for (int v = 0;
                    v <
                        clientmodel.response!.body!.data2!.countryList![i]
                            .stateList![k].districtList!.length;
                    v++) {
                  String districtCode = clientmodel
                      .response!
                      .body!
                      .data2!
                      .countryList![i]
                      .stateList![k]
                      .districtList![v]
                      .districtCode!;
                  String districtName = clientmodel
                      .response!
                      .body!
                      .data2!
                      .countryList![i]
                      .stateList![k]
                      .districtList![v]
                      .districtName!;
                  db.SaveDistrict(districtCode, districtName, stateCode);
                  if (clientmodel.response!.body!.data2!.countryList![i]
                          .stateList![k].districtList![v].cityList !=
                      null) {
                    for (int c = 0;
                        c <
                            clientmodel
                                .response!
                                .body!
                                .data2!
                                .countryList![i]
                                .stateList![k]
                                .districtList![v]
                                .cityList!
                                .length;
                        c++) {
                      String cityCode = clientmodel
                          .response!
                          .body!
                          .data2!
                          .countryList![i]
                          .stateList![k]
                          .districtList![v]
                          .cityList![c]
                          .cityCode!;
                      String cityName = clientmodel
                          .response!
                          .body!
                          .data2!
                          .countryList![i]
                          .stateList![k]
                          .districtList![v]
                          .cityList![c]
                          .cityName!;
                      db.SaveCity(cityCode, cityName, districtCode);
                      if (clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList !=
                          null) {
                        for (int n = 0;
                            n <
                                clientmodel
                                    .response!
                                    .body!
                                    .data2!
                                    .countryList![i]
                                    .stateList![k]
                                    .districtList![v]
                                    .cityList![c]
                                    .villageList!
                                    .length;
                            n++) {
                          String villageCode = clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList![n]
                              .villageCode!;
                          String villageName = clientmodel
                              .response!
                              .body!
                              .data2!
                              .countryList![i]
                              .stateList![k]
                              .districtList![v]
                              .cityList![c]
                              .villageList![n]
                              .villageName!;
                          // print('villageCode ' + villageCode);
                          int succc = await db.SaveVillage(
                              villageCode, villageName, cityCode);
                          if (succc != 0) {
                            // print(succc);
                          }
                        }
                      } else {
                        // print('panchayatList null');
                      }
                    }
                  } else {
                    print('city null');
                  }
                }
              } else {
                print('districtList null');
              }
            }
          } else {
            print('countryName null');
          }
        }
      } else {
        print("country fail");
      }
      print('initstart FarmerDownload ' + agentType);
      /* if (agentType == "01") {
        FarmerDownload();
      } else if (agentType == "03") {
        FarmerDownload();
      } else if (agentType == "02") {
        isLoading = false;
      } else {
        isLoading = false;
      }*/

      //if (agentType != "02") {
      FarmerDownload();
      //} else {
      //isLoading = false;
      // }
   }
   catch (e) {
      print("Download322Datas err " + e.toString());
      if (agentType != "02") {
        FarmerDownload();
      } else {
        isLoading = false;
      }
    }
  }

  Future<void> FarmerDownload() async {
    print("FarmerDownload");
    try {
      restplugin rest = restplugin();
      String response = await rest.FarmerDownload();

      Map<String, dynamic> json = jsonDecode(response);

      farmers = farmerlistresponsemodel.fromJson(json);
      //  print("farmers_farmers" + farmers.toString());
      String? revNo = farmers!.response!.body!.revNo;
      db.DeleteTable('farmer_master');
      for (int i = 0; i < farmers!.response!.body!.farmerList!.length; i++) {
        String farmerId = farmers!.response!.body!.farmerList![i].farmerId!;
        String farmerCode = farmers!.response!.body!.farmerList![i].farmerCode!;
        String firstName = farmers!.response!.body!.farmerList![i].firstName!;
        String lastName = farmers!.response!.body!.farmerList![i].lastName!;
        String village = farmers!.response!.body!.farmerList![i].village!;
        String status = farmers!.response!.body!.farmerList![i].status!;
        String address = farmers!.response!.body!.farmerList![i].address!;
        String fMobNo = farmers!.response!.body!.farmerList![i].fMobNo!;
        String exporterCode =
            farmers!.response!.body!.farmerList![i].exporterCode!;
        String exporter = farmers!.response!.body!.farmerList![i].exporterCode!;
        String nationalID = farmers!.response!.body!.farmerList![i].NatId!;
        String state_name = farmers!.response!.body!.farmerList![i].state_name!;
        String state = farmers!.response!.body!.farmerList![i].state!;
        String farmerKRA = farmers!.response!.body!.farmerList![i].farmerKRA!;

        // String qry =
        //     'DELETE FROM farmer_master Where farmerId = \'' + farmerId + '\'';
        // print(qry);

        // db.RawUpdate(qry);
        String villagenameqry =
            'select villName from villageList where villCode= \'' +
                village +
                '\'';
        print('villagename' + villagenameqry);
        List<Map> villagename = await db.RawQuery(villagenameqry);
        String villageName = villagename[0]['villName'];

        var farmermaster = FarmerMaster(
            firstName,
            lastName,
            farmerId,
            farmerCode,
            exporter,
            address,
            village,
            fMobNo,
            exporterCode,
            status,
            villageName,
            nationalID,
            state,
            farmerKRA);

        addFarmerDB(farmermaster);

        //  print("farmerCode_farmerCode" + farmerCode.toString());

        //print("farmermaster_value" + farmermaster.toString());
      }
      //  toast('FarmDownload');
      String updateqry =
          'UPDATE agentMaster SET farmerRev =\'' + revNo.toString() + '\' ';
      db.RawUpdate(updateqry);
      print('initstart FarmDownload');
      /*if (agentType == "01") {
        FarmDownload();
      } else if (agentType == "03") {
        FarmDownload();
      }*/

      if (agentType != "02") {
        FarmDownload();
      } else {
        print("agentType");
        isLoading = false;
      }
    } catch (Exception) {
      if (agentType != "02") {
        FarmDownload();
      } else {
        isLoading = false;
      }
    }
  }

  Future<void> FarmDownload() async {
    try {
      restplugin rest = restplugin();
      String response = await rest.FarmDownload();
      // print("FarmResponse_FarmResponse" + response.toString());
      db.DeleteTable('farm');
      db.DeleteTable('blockDetails');
      Map<String, dynamic> json = jsonDecode(response);
      //print('farm res ' + json.toString());
      FarmResponseModel farms = FarmResponseModel.fromJson(json);
      String fLon = "",
          fLat = "",
          farmerId = "",
          farmCode = "",
          farmName = "",
          verifyStatus = "",
          farmStatus = "";
      String currentCoversionStatus = "", chemicalAppliedLastDate = "";
      String farmId = "",
          pltStatus = "",
          geoStatus = "",
          insDate = "",
          inspName = "",
          insType = "",
          farmArea = "",
          landStatus = "",
          prodLand = "",
          farmCount = "";
      String inspDetList = "", dynfield = "", prPlAra = "";
      String country_code = "",
          state = "",
          city = "",
          district = "",
          village = "",
          villageName = "";
      String blockName = "", blockArea = "", blockId = "";
      String revNo = farms.response!.body!.farmRevNo!;
      for (int i = 0; i < farms.response!.body!.farmList!.length; i++) {
        farmCode = farms.response!.body!.farmList![i].farmCode!;
        farmerId = farms.response!.body!.farmList![i].farmerId!;
        farmCount = farms.response!.body!.farmList![i].farmId!;
        farmId = "";
        prodLand = farms.response!.body!.farmList![i].frmProd!;
        farmArea = farms.response!.body!.farmList![i].totLaAra!;
        currentCoversionStatus = "";
        chemicalAppliedLastDate = "";
        farmName = farms.response!.body!.farmList![i].farmName!;
        fLon = farms.response!.body!.farmList![i].fLon!;
        fLat = farms.response!.body!.farmList![i].fLat!;
        verifyStatus = "";
        farmStatus = farms.response!.body!.farmList![i].farmStatus!.toString();
        pltStatus = "";
        geoStatus = "";
        prPlAra = "";
        landStatus = "";
        String blockCount = "0";
        int blockCountValue = 0;
        country_code =
            farms.response!.body!.farmList![i].country_code!.toString();
        state = farms.response!.body!.farmList![i].state!.toString();
        district = farms.response!.body!.farmList![i].district!.toString();
        city = farms.response!.body!.farmList![i].city!.toString();
        village = farms.response!.body!.farmList![i].village!.toString();
        villageName = "";
        blockCount = farms.response!.body!.farmList![i].blockCount!.toString();

        for (int j = 0;
            j < farms.response!.body!.farmList![i].blockingLst!.length;
            j++) {
          blockId = farms.response!.body!.farmList![i].blockingLst![j].blockId
              .toString();
          blockName = farms
              .response!.body!.farmList![i].blockingLst![j].blockName
              .toString();
          blockArea = farms
              .response!.body!.farmList![i].blockingLst![j].cultArea
              .toString();

          db.saveBlockRegistration(farmerId, farmCode, blockId, "", "", "",
              blockArea, blockName, "");
        }

        if (blockCount.isNotEmpty) {
          blockCountValue = int.parse(blockCount);
        }

        db.SaveFarm(
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
            country_code,
            state,
            district,
            city,
            village,
            villageName,
            blockCountValue);
      }

      String updateqry =
          'UPDATE agentMaster SET farmerfarmRev =\'' + revNo.toString() + '\' ';
      db.RawUpdate(updateqry);

      /* if (agentType == "01") {
        fetchCropdata();
        fetchData();
      } else if (agentType == "03") {
        fetchCropdata();
        fetchData();
      }*/

      if (agentType != "02") {
        fetchCropdata();
        fetchData();
      } else {
        print("agentType");
      }

      // _progressHUD.state.dismiss();
    } catch (Exception) {
      if (agentType != "02") {
        fetchCropdata();
        fetchData();
      } else {
        isLoading = false;
      }
    }
  }

  void checkSYNC() async {
    try {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (custTransactions.length == 0) {
        Download322Datas();
      } else {}
    } catch (e) {}
  }

  void GetDatas() async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();

      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      setState(() {
        pendingTransaction = custTransactions.length.toString();
      });
      if (custTransactions.length == 0) {
        setState(() {
          transactioncount = custTransactions.length.toString();
          synced = true;
        });
      } else {
        setState(() {
          transactioncount = custTransactions.length.toString();
          synced = false;
        });
      }
      translate();
    } catch (e) {
      // for first time
      translate();
      print('pendingtransaction packhouse' + e.toString());
    }
  }

  Future addFarmerDB(FarmerMaster farmerMaster) async {
    var db = DatabaseHelper();
    await db.saveFarmer(farmerMaster);
  }

  Future AddCatalogDB(AnimalCatalog catalog) async {
    var db = DatabaseHelper();
    await db.saveCatalog(catalog);
  }

  @override
  Widget build(BuildContext context) {
    if (isTranslation) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: <Widget>[
                  NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: PrimaryColor,
                          centerTitle: true,
                          title: Text(appDatas.appname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w800)),
                          floating: false,
                          pinned: true,
                          actions: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10.0),
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                transactioncount,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17.0,
                                ),
                              ),
                              decoration: synced && _internetconnection
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white)
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                            )
                          ],
                        ),
                      ];
                    },
                    body: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0),
                                  )),
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  elevation: 5,
                                  color: Colors.green,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(0.5, 0.0),
                                        colors: [Colors.green, Colors.blue],
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'images/morning.png',
                                                      fit: BoxFit.cover,
                                                      width: 20,
                                                      height: 20,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                    Text(
                                                      timetype,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      currentdate,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              currenttime,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          removedummy
                                              ? Container(
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.all(1),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    pendingTransaction +
                                                                        ' ' +
                                                                        pendtxn,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                  Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: const BorderRadius.all(
                                                                      Radius.circular(
                                                                          3.0),
                                                                    )),
                                                                    elevation:
                                                                        2,
                                                                    color: Colors
                                                                        .green,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        checkSYNC();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              child: Text(
                                                                                sync,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.only(left: 10),
                                                                              child: Icon(
                                                                                Icons.sync,
                                                                                size: 16,
                                                                                color: Colors.white,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              flex: 2,
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          nameLoaded
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    exporterAndAgentName,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 5, right: 5, top: 5),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder: (_, index) => InkWell(
                                    onTap: () async {
                                      getUpdatedPasswordDetail();
                                      if (!passwordExpire) {
                                        if (agentType == "01") {
                                          switch (index) {
                                            case 0:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmerRegistration()));
                                              break;

                                            case 1:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmRegistration()));

                                              break;

                                            case 2:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BlockScreen()));

                                              break;

                                            case 3:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SitePreparationScreen()));

                                              break;

                                            case 4:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LandPreparation()));

                                              break;

                                            case 5:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PlantingScreen()));

                                              break;

                                            case 6:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ScoutingScreen()));

                                              break;

                                            case 7:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Spraying()));
                                              break;

                                            case 8:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Harvest()));
                                              break;

                                            case 9:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Sorting()));
                                              break;

                                            case 10:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          RecentQrImages()));
                                              break;

                                            case 11:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmerList()));
                                              break;
                                            case 12:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          TransactionSummary()));
                                              break;

                                          }
                                        } else if (agentType == "02") {
                                          switch (index) {
                                            case 0:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          IncomingShipment()));
                                              break;

                                            case 1:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          ProductTransfer()));
                                              break;


                                            case 2:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          ProductReception()));
                                              break;

                                            case 3:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PackingScreen()));
                                              break;

                                            case 4:
                                              validExporter
                                                  ? Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Shipment()))
                                                  : alertPopup(context,
                                                      "Exporter not a valid license holder");
                                              break;

                                            case 5:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          RecentQrImages()));
                                              break;

                                            case 6:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          TransactionSummary()));
                                          }
                                        } else {
                                          switch (index) {
                                            case 0:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmerRegistration()));
                                              break;

                                            case 1:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmRegistration()));

                                              break;

                                            case 2:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BlockScreen()));

                                              break;

                                            case 3:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SitePreparationScreen()));

                                              break;

                                            case 4:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LandPreparation()));

                                              break;

                                            case 5:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          PlantingScreen()));

                                              break;

                                            case 6:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ScoutingScreen()));

                                              break;

                                            case 7:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Spraying()));
                                              break;

                                            case 8:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Harvest()));
                                              break;

                                            case 9:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Sorting()));
                                              break;

                                            case 10:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          IncomingShipment()));
                                              break;


                                            case 11:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          ProductTransfer()));
                                              break;

                                            case 12:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProductReception()));
                                              break;

                                            case 13:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          PackingScreen()));
                                              break;

                                            case 14:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          Shipment()));
                                              // validExporter
                                              //     ? Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (BuildContext
                                              //         context) =>
                                              //             Shipment()))
                                              //     : alertPopup(context,
                                              //     "Exporter not a valid license holder");
                                              break;

                                            case 15:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          RecentQrImages()));
                                              break;

                                            case 16:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          FarmerList()));
                                              break;



                                            case 17:
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          TransactionSummary()));
                                              break;
                                          }
                                        }
                                      } else if (passwordExpire == true) {
                                        errordialog(context, "Information",
                                            "Password Expired");
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0),
                                      )),
                                      elevation: 3,
                                      color: Colors.white,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              agentType == "01"
                                                  ? menuimage[index]
                                                  : agentType == "02"
                                                      ? menuimage2[index]
                                                      : menuimage3[index],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              matchTextDirection: true,
                                              alignment: Alignment.center,
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                menus[index],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemCount: menus.length,
                                ),
                              ),
                              flex: 15,
                            ),
                          ],
                        ),
                        Positioned(
                          child: ModalProgressHUD(
                              inAsyncCall: isLoading,
                              // demo of some additional parameters
                              opacity: 0.5,
                              color: Colors.white,
                              progressIndicator: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                              child: Container()),
                        ),
                      ],
                    ),
                  ),

//            _buildFab(),
                ],
              ),
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  // Set the transparency here
                  canvasColor: Colors
                      .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
                ),
                child: Drawer(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xffd3f5d4),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: 80,
                                    child: Image.asset(
                                      'images/newlogo.png',
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    version + " : " + appversion,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                                itemCount: drawerlist.length,
                                itemBuilder: (context, postion) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (drawerlist[postion].name == home) {
                                        Navigator.pop(context);
                                      } else if (drawerlist[postion].name ==
                                          logout) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: logout,
                                          desc: rulogout,
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                yes,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                LoginStateful()));
                                              },
                                              width: 120,
                                            ),
                                            DialogButton(
                                              child: Text(
                                                no,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                      } else if (drawerlist[postion].name ==
                                          "Export Data") {
                                        Navigator.pop(context);
                                        Directory documentsDirectory =
                                            await getApplicationDocumentsDirectory();
                                        //SharedPreferences prefs = await SharedPreferences.getInstance();
                                        String? DBVERSION =
                                        await SecureStorage().readSecureData("DBVERSION");
                                        String savePath =
                                            documentsDirectory.path +
                                                '/bdagro' +
                                                DBVERSION! +
                                                '.db';

                                        ShareExtend.share(
                                            savePath, "Export Data");

                                        /*             Directory documentsDirectory =
                                            await getApplicationDocumentsDirectory();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        String? DBVERSION =
                                            prefs.getString("DBVERSION");
                                        String savePath =
                                            documentsDirectory.path +
                                                '/bdagro' +
                                                DBVERSION! +
                                                '.db';

                                         ZipFileEncoder encoder =
                                            ZipFileEncoder();
                                        encoder.create(documentsDirectory.path +
                                            "/" +
                                            'databaseFile.zip');
                                        encoder.addFile(File(savePath));
                                        encoder.close();

                                          String saveZip =
                                            documentsDirectory.path +
                                                '/databaseFile' +
                                                '.zip';*/

                                      } else if (drawerlist[postion].name ==
                                          chngpswd) {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ChangePassword()));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              child: Icon(
                                                drawerlist[postion].iconData,
                                                color: Colors.green,
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                child: Text(
                                                  drawerlist[postion].name,
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            flex: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          flex: 9,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: exit,
          desc: ruexit,
          buttons: [
            DialogButton(
              child: Text(
                yes,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => LoginStateful()));
              },
              width: 120,
            ),
            DialogButton(
              child: Text(
                no,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show()) ??
        false;
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    try {
      WidgetsBinding.instance!.removeObserver(this);
      tabController!.dispose();
    } catch (Excepton) {
      print("CHECK" + Excepton.toString());
    }
  }

  Future<void> fetchCropdata() async {
    try {
      restplugin rest = restplugin();
      String response = await rest.CroplistDownload();
      // print('CroplistDownload ' + response.toString());
      Map<String, dynamic> json = jsonDecode(response);

      Croplistvalues croplistvalues = Croplistvalues.fromJson(json);

      db.DeleteTable('farmCrop');
      for (int i = 0;
          i < croplistvalues.response!.body!.cropList!.length;
          i++) {
        String cropCode = croplistvalues.response!.body!.cropList![i].cropId!;
        String cropArea = croplistvalues.response!.body!.cropList![i].cultArea!;
        String cropVariety =
            croplistvalues.response!.body!.cropList![i].variety!;
        String farmerId =
            croplistvalues.response!.body!.cropList![i].farmerId!.toString();
        String dateOfSown =
            croplistvalues.response!.body!.cropList![i].sowDt!.toString();
        String blockId = croplistvalues.response!.body!.cropList![i].blockId!;
        String blockName =
            croplistvalues.response!.body!.cropList![i].blockName!;
        String farmCode = croplistvalues.response!.body!.cropList![i].farmCode!;
        String status = croplistvalues.response!.body!.cropList![i].status!;
        String gradeCode = croplistvalues.response!.body!.cropList![i].gCode!;
        String plantingId =
        croplistvalues.response!.body!.cropList![i].plantingId!;
        String production =
            croplistvalues.response!.body!.cropList![i].expHarvestQty!;
        String fcropId = croplistvalues.response!.body!.cropList![i].fcropId!;
        String maxPhiDate = croplistvalues.response!.body!.cropList![i].maxPhiDate!;
        String commonRec = croplistvalues.response!.body!.cropList![i].commonRec!;
        String scoutDate = croplistvalues.response!.body!.cropList![i].scoutDate!;
        String dateOfEve = croplistvalues.response!.body!.cropList![i].dateOfEve!;
       // String dateOfEve = '';

        db.saveFarmCrop(

            scoutDate,
            commonRec,
            farmerId,
            farmCode,
            blockName,
            cropArea,
            blockId,
            cropCode,
            cropVariety,
            gradeCode,
            "", //seedType
            dateOfSown,
            maxPhiDate, //seedLotNo
            "", //borderCropType
            "", //seedTreatment
            "", //seedCheQty
            "", //otherSeedTreatment
            "", //seedQty
            "", //plantWeek
            "", //fertilizer
            "", //fertiType
            "", //fertiLotNo
            "", //
            "", //unit
            dateOfEve, //expWeek
            "", //mode
            production, //production
            "", //cropSeason
            "", //cropCategory
            "", //reciptId
            "",
            plantingId,
            fcropId);
        //print("farmerId_farmerId" + farmerId.toString());
      }

      /* Future.delayed(Duration(milliseconds: 2000), () {
        print("++++++++++++++++");
        isLoading = false;
      });*/

      isLoading = false;
    } catch (Exception) {
      print('farmcrop_master_exception' + Exception.toString());
      isLoading = false;
    }
  }

  Future addCroplist(CropListmodel cropList) async {
    var db = DatabaseHelper();
    await db.saveCroplistvalues(cropList);
  }

  void checkpendingtransaction() {
    try {
      Timer.periodic(Duration(seconds: 2), (timer) async {
        setState(() {
          final now = DateTime.now();
          currentdate = DateFormat('dd MMM, yyyy').format(now);
          currenttime = DateFormat('hh:mm:a').format(now);
          var CURRENTTIME = currenttime.split(':');
          if (CURRENTTIME[2] == 'AM') {
            timetype = 'Good Morning..';
          } else {
            int hour = int.parse(CURRENTTIME[0]);
            if (hour > 4) {
              timetype = 'Good Evening..';
            } else {
              timetype = 'Good Afternoon..';
            }
          }
        });

        /*var db = DatabaseHelper();
        List<Map> custTransactions = await db.GetTableValues('custTransactions');
        print('CHECK_PENDING_TRANSACTION 3: ' + custTransactions.toString());
        setState(() {
          pendingTransaction = custTransactions.length.toString();
        });*/
        GetDatas();
      });
    } catch (Except) {
      print("CHECK_EXCEPTION: " + Except.toString());
    }
  }

  void checkLatestVersion() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      if (!updateAvl && custTransactions.length == 0) {
        restplugin rest = restplugin();
        final String response = await rest.GetLatestVersion();
        //  print('latestversion ' + response);
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        List<String> versionlist = version
            .split(
                '.') // split the text into an array/ put the text inside a widget
            .toList();

        List<String> serverversionlist = response
            .split(
                ',') // split the text into an array/ put the text inside a widget
            .toList();
        String appversion = versionlist[0];

        String serverappversion = serverversionlist[0];
        String databaseversion_server = serverversionlist[1];

        //SharedPreferences prefs = await SharedPreferences.getInstance();
        String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");

        print(
            'latestversion app: ' + serverappversion + ' <> app:' + appversion);
        print('latestversion db: ' +
            databaseversion_server +
            ' <> app:' +
            DBVERSION!);
        if (DBVERSION == databaseversion_server) {
          print("DownloadDB matched");
        } else {
          print("DownloadDB mismatch");
          updateAvl = true;
          //
        }
        if (appversion == serverappversion) {
          print('main latest');
        } else {
          print('main update');
          updateAvl = true;
        }

        if (updateAvl) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: availupd,
            desc: appavl,
            buttons: [
              DialogButton(
                child: Text(
                  okLabel,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
                width: 120,
              ),
            ],
          ).show();
        }
      }
    });
  }

  getUpdatedPasswordDetail() async {
    List<Map> agents = await db.RawQuery(
        'SELECT pwExpDays,pwDate,agentType,pwRemainder FROM agentMaster');
    print("pwExpDays" + agents[0]['pwExpDays'].toString());
    setState(() {
      if (agents.length > 0) {
        String createdDate = agents[0]['pwExpDays'];
        String age = agents[0]['pwDate'];
        String remDays = agents[0]['pwRemainder'];
        expireDateComparison(createdDate, age, remDays);
      }
    });
  }

  void exporterDateComparsion(String expireDate) async {
    print("expireDate_expireDateddd" + expireDate.toString());
    if (expireDate != "") {
      String dateValue = expireDate;
      String trimmedDate = dateValue.substring(0, 10);

      String lastDate = trimmedDate;
      List<String> splitLastDate = lastDate.split('-');

      String strYearq = splitLastDate[0];
      String strMonthq = splitLastDate[1];
      String strDateq = splitLastDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);
      DateTime convertedDate = DateTime(strYear, strMonths, strDate);
      final now = DateTime.now();

      print("convertedDateExporter" + convertedDate.toString());
      print("now" + now.toString());

      bool valDate = convertedDate.isBefore(now);
      print("valDate_valDate" + valDate.toString());
      bool isToday = convertedDate.isAtSameMomentAs(now);
      if (valDate) {
        setState(() {
          validExporter = false;
        });
      } else if (exportStatus == "0") {
        setState(() {
          validExporter = false;
        });
      } else if (exportLicenseNo.isEmpty) {
        setState(() {
          validExporter = false;
        });
      } else if (isToday) {
        validExporter = true;
      } else {
        setState(() {
          validExporter = true;
        });
      }
    }

    print("exporterValidData" + validExporter.toString());
  }

  void expireDateComparison(
      String createdDate, String pAge, String days) async {
    int age = 0, passwordAge = 0;
    int reminderDays = 0;
    if (createdDate != "") {
      String dateValue = createdDate;
      List<String> splitStartDate = dateValue.split('-');

      String strDateq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strYearq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      setState(() {
        passwordAge = int.parse(pAge);
        reminderDays = int.parse(days);
      });

      DateTime convertCreatedDate = DateTime(strYear, strMonths, strDate);
      int endDate = (convertCreatedDate.day + passwordAge);
      DateTime convertEndDate = DateTime(strYear, strMonths, endDate);
      String formattedEndDate = DateFormat('dd-MM-yyyy').format(convertEndDate);

      final now = DateTime.now();
      final difference = daysBetween(now, convertEndDate);
      final getDifference = difference;
      print("getDifference" + getDifference.toString());
      print("convertEndDate_dddd" + convertEndDate.toString());
      print("now_ddd" + now.toString());
      final difference1 = daysBetween(convertCreatedDate, now);
      final getDifference1 = difference1 + 1;

      if (getDifference1 > passwordAge) {
        setState(() {
          passwordExpire = true;
        });
      } else {
        setState(() {
          passwordExpire = false;
        });
      }

      print("convertEndDate" + convertEndDate.toString());
      print("now_now" + now.toString());
      print("reminderDays_reminderDays" + reminderDays.toString());
      print("getDifference_getDifference" + getDifference.toString());
      if (reminderDays > getDifference || reminderDays == getDifference) {
        setState(() {
          rememberDaysStart = true;
          expireDate = formattedEndDate;
        });
      } else {
        setState(() {
          rememberDaysStart = false;
        });
      }
    }
  }
}

Logout(BuildContext context) async {

  await SecureStorage().writeSecureData("LOGIN", "0");
  Navigator.of(context)
      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
    return LoginStateful();
  }));
}

class DrawerListModel {
  String? name;
  IconData? iconData;

  DrawerListModel({this.name, this.iconData});
}
