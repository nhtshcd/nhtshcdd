import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Plugins/RestPlugin.dart';
import 'package:nhts/Utils/secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../login.dart';
import 'Utils/MandatoryDatas.dart';
//import 'package:app_installer/app_installer.dart';
import 'package:launch_review/launch_review.dart';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const EVENTS_KEY = "fetch_events";
AppDatas appDatas = new AppDatas();

/*void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundFetch] Headless event received: $taskId");
  DateTime timestamp = DateTime.now();

  SharedPreferences prefs = await SharedPreferences.getInstance();

// Read fetch_events from SharedPreferences
  List<String> events = [];
  String json = prefs.getString(EVENTS_KEY);
  if (json != null) {
    events = jsonDecode(json).cast<String>();
  }
// Add new event.
  events.insert(0, "$taskId@$timestamp [Headless]");
// Persist fetch events in SharedPreferences
  prefs.setString(EVENTS_KEY, jsonEncode(events));

  BackgroundFetch.finish(taskId);

  if (taskId == 'flutter_background_fetch') {
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 5000,
        periodic: true,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true));
  }
}*/

void main() {
  runApp(MyApp());
// Register to receive BackgroundFetch events after app is terminated.
// Requires {stopOnTerminate: false, enableHeadless: true}
// BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

/// This "Headless Task" is run when app is terminated.

class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appDatas.tenent,
        theme: ThemeData(
// This is the theme of your application.
//
// Try running your application with "flutter run". You'll see the
// application has a blue toolbar. Then, without quitting the app, try
// changing the primarySwatch below to Colors.green and then invoke
// "hot reload" (press "r" in the console where you ran "flutter run",
// or simply save your changes to "hot reload" in a Flutter IDE).
// Notice that the counter didn't reset back to zero; the application
// is not restarted.
//fontFamily: 'sfui',

          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
        home:
        MyHomePage(title: appDatas.tenent)

    );

// home: Homescreen());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ReceivePort _port = ReceivePort();
  ReceivePort _port1 = ReceivePort();
  double process = 0;
  String databaseversion_server = '';

  bool DBdownload = false;
  bool _enabled = true;
  int _status = 0;
  List<String> _events = [];
  static const platform =
  const MethodChannel('flutter.rortega.com.basicchannelcommunication');

  String _connectionStatus = 'Unknown';
  bool _internetconnection = false;
  final Connectivity _connectivity = Connectivity();


  bool latest = false;
  String timestamp = '';
  String apkVersion = '';

  // ProgressHUD _progressHUD= new ProgressHUD(
  //   backgroundColor: Colors.black12,
  //   color: Colors.white,
  //   containerColor: Colors.green,
  //   borderRadius: 5.0,
  //   loading: false,
  //   text: 'Downloading ',
  // );

  @override
  void initState() {
    super.initState();
    //print('main init');
    WidgetsFlutterBinding.ensureInitialized();/*
    FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );*/


    //checkDeviceSeverity();
    //checkDevice();
    initConnectivity();
    checkPermission();
    initdata();
    configLoading();



    //checkDeviceFunction();
    //StartBackgroundService();
  }

  /*checkDevice()async{
    bool isEmulator = false;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isEmulator = androidInfo.isPhysicalDevice!;
    if(isEmulator){
      initConnectivity();
      checkpermission();
      initdata();
      configLoading();
    }else{
      Alert(

        onWillPopActive: true,
        context: context,
        type: AlertType.error,closeFunction: (){},
        closeIcon: Container(),
        title: "Information",
        desc: "Unable to continue... Due to Device is rooted or Jail broken",
        buttons: [
          DialogButton(
            onPressed: () {
              SystemNavigator.pop();
            },

            width: 120,
            child: const Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    }
  }*/

 /* checkDeviceFunction()async{
    String chkDevice = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chkDevice = prefs.getString("firstTime").toString();
    if(chkDevice == "1"){
      initConnectivity();
      checkpermission();
      initdata();
      configLoading();
    }else{
      checkDeviceSeverity();
    }
  }

  checkDeviceSeverity() async {
    bool isJailBroken = await SafeDevice.isJailBroken;
    bool isRealDevice = await SafeDevice.isRealDevice;
    //bool isDeveloperModeEnabled = await SafeDevice.isDevelopmentModeEnable;

    //print("developer mode enabled:"+isDeveloperModeEnabled.toString()+isRealDevice.toString()+isJailBroken.toString());

    if (isRealDevice && !isJailBroken) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("firstTime", "1");
      initConnectivity();
      checkpermission();
      initdata();
      configLoading();
    } else {
      Alert(

        onWillPopActive: true,
        context: context,
        type: AlertType.error,closeFunction: (){},
        closeIcon: Container(),
        title: "Information",
        desc: "Unable to continue... Due to Device is rooted or Jail broken",
        buttons: [
          DialogButton(
            onPressed: () {
              SystemNavigator.pop();
            },

            width: 120,
            child: const Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    }
  }*/

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.green
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.green
      ..textColor = Colors.grey
      ..maskColor = Colors.black.withOpacity(0.5)
      ..userInteractions = true
      ..fontSize = 16
      ..dismissOnTap = false;
  }

  CheckDBupdate() async {
    // if(appDatas.playstore_release){
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String? olderAPKversion = await SecureStorage().readSecureData("olderAPKversion");
    if (olderAPKversion == null) {
      olderAPKversion = '0';
    }
    List<String> versionlist = version
        .split(
        '.') // split the text into an array/ put the text inside a widget
        .toList();
    String APKversion = versionlist[0];
    //  print('DB UPDATE : ' + APKversion.toString());
    if (APKversion != olderAPKversion) {
      for (int i = int.parse(olderAPKversion);
      i <= int.parse(APKversion);
      i++) {
        if (i == 4) {
          List<String> querys = [];
          querys.add("ALTER TABLE cropHarvest ADD [weightType] VARCHAR(45)");
          querys.add("ALTER TABLE sorter ADD [truckType] VARCHAR(45)");
          querys.add("ALTER TABLE sorter ADD [truckNumber] VARCHAR(45)");
          querys.add("ALTER TABLE sorter ADD [driverName] VARCHAR(45)");
          querys.add("ALTER TABLE sorter ADD [driverNo] VARCHAR(45)");
          querys.add("ALTER TABLE varietyList ADD [hsCode] VARCHAR(45)");
          querys.add("ALTER TABLE spray ADD [oprMedRpt] VARCHAR(45);");
          for (int i = 0; i < querys.length; i++) {
            db.RawInsert(querys[i]);
          }
        } else if (i == 6) {
        } else if (i == 9) {
          // List<String> querys = [];
          // querys.add("update labelNamechange set labelName=\'Remaining ordered stock (to be transferred)\' where className=\'ordStk\' and lang=\'en\'");
          // querys.add("update labelNamechange set labelName=\'অবশিষ্ট অর্ডারকৃত স্টক (স্থানান্তর করতে হবে)\' where className=\'ordStk\' and lang=\'bn\'");
          //
          //
          // for(int i=0;i<querys.length;i++){
          //   db.RawInsert(querys[i]);
          // }
        } else if (i == 10) {
        }
        else if(i==8){
          List<String> querys = [];
          querys.add("CREATE TRIGGER [AFT_INS_PROD_RESP_DETAILS] AFTER INSERT ON [productReceptionDetails] FOR EACH ROW BEGIN INSERT OR IGNORE INTO villageWarehouse(batchNo, wCode,wName,pCode,pName,vCode,vName,sortWt,rejWt,farmerId,farmerName,farmId,farmName,blockId,blockName,plantingId,lastHarDate,stockType,countyCode,countyName,qrUniqId) VALUES(NEW.batchNo,"","",NEW.pCode,NEW.pName,NEW.vCode,NEW.vName,'','',NEW.farmerId,NEW.farmerName,NEW.farmId,NEW.farmName,NEW.blockId,NEW.blockName,new.plantingId,(select txnDate from productReception where recNo = new.recNo),'2',NEW.stateCode,NEW.stateName,New.qrUniqId); UPDATE villageWarehouse SET actWt = (IFNULL(actWt, 0) + new.recWt) WHERE blockId = NEW.blockId and plantingId = new.plantingId and pCode=new.pCode and stockType='2' and batchNo=New.batchNo; UPDATE villageWarehouse SET actWt = (IFNULL(actWt, 0) - new.transWt WHERE blockId = NEW.blockId and plantingId = new.plantingId and pCode=new.pCode and stockType='1' and batchNo=New.sortingId END");
          for (int i = 0; i < querys.length; i++) {
            db.RawInsert(querys[i]);
          }
        }


      }
    }
    //prefs = await SharedPreferences.getInstance();
    await SecureStorage().writeSecureData("olderAPKversion", APKversion);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginStateful()));

    // }
  }

  void GetDatas(bool apk, String dbVersion, String appVersion) async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      //print('custTransactionsgetData ' + custTransactions.toString());
      if (custTransactions.length == 0) {
        if (apk) {
          confirmationPopup(context, appVersion);
        } else {
          setState(() {
            DBdownload = false;
          });
          if (appDatas.playstore) {
            CheckDBupdate();
          } else {
            DownloadDB(dbVersion);
          }
          // db update using queries
        }
      } else {}
    } catch (e) {
      // for first time
      if (!apk) {
        //print('for first time');

        await DownloadDB(dbVersion);
      } else {
        GetLatestVersion();
      }
    }
  }

  /* void GetDatas(bool apk, String Version) async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      print('custTransactions ' + custTransactions.toString());
      if (custTransactions.length == 0) {
        if (apk) {
          confirmationPopup(context, Version);
        } else {
          setState(() {
            DBdownload = false;
          });
          DownloadDB(Version);
        }
      } else {}
    } catch (e) {
      // for first time
      if (!apk) {
        DownloadDB(Version);
      } else {
        GetLatestVersion();
      }
    }
  }*/

  checkPermission() async {
    DeviceInfoPlugin deviceInfoPlugin=DeviceInfoPlugin();
    if(Platform.isIOS){
      Map<Permission, PermissionStatus> statuses =
      await [Permission.storage, Permission.location].request();
      if (statuses[Permission.storage]!.isGranted) {
        //DBdownloadedstatus();
        //print('checkpermission 2 granted');
        GetLatestVersion();
      } else {
        Navigator.pop(context);
        //print('Storage Permssion is denied');
      }
    }
    else{
      var sdk=await deviceInfoPlugin.androidInfo;
      print("SDK Version ==>  ${sdk.version.sdkInt}");
      if(sdk.version.sdkInt! <= 32){
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.storage,
        ].request();
        if (statuses[Permission.storage]!.isGranted) {

          print('checkpermission 2');
          GetLatestVersion();
        }
        else {
          Navigator.pop(context);
          toast('Storage Permssion is denied');
          print('checkpermission 2');
        }
        print(statuses[Permission.location]);
      }
      else{
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.notification,
          Permission.storage,
        ].request();
        GetLatestVersion();
      }
    }

  }

 /* checkpermission() async {
    // if (await Permission.storage.request().isGranted) {
    //   //DBdownloadedstatus();
    //   print('checkpermission 1');
    //   GetLatestVersion();
    // }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage, Permission.location].request();
    if (statuses[Permission.storage]!.isGranted) {
      //DBdownloadedstatus();
      //print('checkpermission 2 granted');
      GetLatestVersion();
    } else {
      Navigator.pop(context);
      //print('Storage Permssion is denied');
    }
    //print(statuses[Permission.location]);
  }*/

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
// Platform messages may fail, so we use a try/catch PlatformException.
    // print('initConnectivity start');
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      //print('initConnectivity ' + e.toString());
    }

// If the widget was removed from the tree while the asynchronous platform
// message was in flight, we want to discard the reply rather than calling
// setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      //print('initConnectivity wifi');
        setState(() {
          _internetconnection = true;
        });
        break;
      case ConnectivityResult.mobile:
      //print('initConnectivity mobile');
        setState(() {
          _internetconnection = true;
          // TxnExecutor txnExecutor = new TxnExecutor();
          // txnExecutor.CheckCustTrasactionTable();
        });
        break;
      case ConnectivityResult.none:
      //print('initConnectivity none');
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'No internet connection';
        });
        break;
      default:
      //print('initConnectivity default');
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  Future<void> GetLatestVersion() async {
    try {
      //print('checking');
      int count = -1;
      try {
        List<Map> custTransactions =
        await db.GetTableValues('custTransactions');
        //print('custTransactions ' + custTransactions.toString());
        count = custTransactions.length;
      } catch (e) {
        //print('checking 2:' + e.toString());
        count = 0;
      }
      /*print('checking ' +
          count.toString() +
          " " +
          _internetconnection.toString());*/
      if (count == 0 && _internetconnection) {
        restplugin rest = restplugin();
        final String response = await rest.GetLatestVersion();
        // print('latestversion ' + response);
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
        databaseversion_server = serverversionlist[1];

        //SharedPreferences prefs = await SharedPreferences.getInstance();
        String? DBVERSION = await SecureStorage().readSecureData("DBVERSION");

        if (DBVERSION == null) {
          //print('latestversion db: first');
          DBVERSION = '-1';
        }

        /* print(
            'latestversion app: ' + serverappversion + ' <> app:' + appversion);*/

        // if (DBVERSION == databaseversion_server) {
        //   print("DownloadDB matched");
        //   setState(() {
        //     DBdownload = true;
        //   });
        // } else {
        //   print("DownloadDB mismatch");
        //
        //   //  GetDatas(false, databaseversion_server);
        //   //
        // }
        if (appversion == serverappversion) {
          //print('main latest');
          setState(() {
            latest = true;
          });
          /*if (DBdownload) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginStateful()));
          }*/

          if (DBVERSION == databaseversion_server) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginStateful()));
          } else {
            GetDatas(false, databaseversion_server, serverappversion);
          }
        } else {
          //print('main update');
          setState(() {
            latest = false;
          });
          // GetDatas(true, serverappversion);
          GetDatas(true, databaseversion_server, serverappversion);
        }
      } else {
        //print('offline ');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginStateful()));
        setState(() {
          latest = true;
        });
      }
    } catch (Exception) {
      //print('main latest failed ' + Exception.toString());
      setState(() {
        latest = true;
      });
    }
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
  }

  void _onClickStatus() async {
    /*int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');*/
    setState(() {
      //  _status = status;
    });
  }

  // void _onClickClear() async {
  //   //SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(EVENTS_KEY);
  //   setState(() {
  //     _events = [];
  //   });
  // }

  Future<void> initdata() async {
    //await  SecureStorage().deleteAll();
    String _serialNumber = '';
    restplugin rest = restplugin();
    _serialNumber = await rest.getSerialnumber();

    await SecureStorage().writeSecureData("serialnumber", _serialNumber);
    // prefs.setString("serialnumber", "499ee46858391a2caf9e567589d1db8f");
    print("serialnumber->" + _serialNumber);
    //  toast(_serialNumber);

//
  }

  DBdownloadedstatus() async {
    try {
      //print('main DBdownloadedstatus');
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dbstatus = await SecureStorage().readSecureData("AGRODB");
      bool downloaded;
      if (dbstatus == '1') {
        downloaded = true;
      } else {
        downloaded = false;
        // DownloadDB();
      }
      setState(() {
        DBdownload = downloaded;
      });
    } catch (Exception) {
      //print('Exception ' + Exception.toString());
      //  DownloadDB();
    }
  }

  Future DownloadDB(String newVersion) async {
    try {
      // await SecureStorage().deleteAll();
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String savePath =
          documentsDirectory.path + '/bdagro' + newVersion + '.db';
      //print('savePath ' + savePath);
      String deDbdownloadurl = await SecureStorage().decryptAES(appDatas.DBdownloadurl);
      //print("de db download url:"+deDbdownloadurl);
      Response response = await Dio().get(
        deDbdownloadurl,
        onReceiveProgress: showDownloadProgress,
        //         onReceiveProgress: (received, total) => {
        //         if (total != -1) {
        //
        //         if (received / total * 100 == 100){
        //
        //       DBdownload = true;
        //       if (latest) {
        //         SharedPreferences prefs = await SharedPreferences.getInstance();
        //         prefs.setString("DBVERSION", newVersion);
        //         Navigator.of(context).pushReplacement(MaterialPageRoute(
        //             builder: (BuildContext context) => LoginStateful()));
        //       }
        //     }
        //   }
        // },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      // print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      //print(e);
    }
  }

  Future<void> showDownloadProgress(received, total) async {
    if (total != -1) {
      //print('DownloadDB ' + (received / total * 100).toStringAsFixed(0) + "%");
      if ((received / total * 100).toStringAsFixed(0) == "100") {
        DBdownload = true;
        if (latest) {
          //SharedPreferences prefs = await SharedPreferences.getInstance();
          await SecureStorage().writeSecureData("DBVERSION", databaseversion_server);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginStateful()));
        }
      }
    }
  }


  void DownloadAPK(String Version) async {
    //toast('Downloading APK');
    // print('Downloading APK');
    var now = new DateTime.now();
    var Timestamp = new DateFormat('ddMMyyHHmmss');
    timestamp = Timestamp.format(now);
    apkVersion = Version;
    // ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Download, isDismissible: false, showLogs: true);
    double process = 0;
    // _progressHUD.state.show();

    EasyLoading.show(status: 'Downloading APK');
    try {
      Directory? documentsDirectory = await getExternalStorageDirectory();
      String savePath = documentsDirectory!.path +
          "/nhts_" +
          Version +
          "_" +
          timestamp +
          ".apk";
      //print("DownloadPath"+savePath.toString());
      String deapkDownloadUrl = await SecureStorage().decryptAES(appDatas.apkdownloadurl);
      //print("de  apkDownloadUrl url:"+deapkDownloadUrl);
      Response response = await Dio().get(
        deapkDownloadUrl,
        onReceiveProgress: showAPKDownloadProgress,

        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      //print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      //print(e);
    }
  }

  Future<void> showAPKDownloadProgress(received, total) async {
    if (total != -1) {
      //print('APkDownload ' + (received / total * 100).toStringAsFixed(0) + "%");
      if ((received / total * 100).toStringAsFixed(0) == "100") {
        EasyLoading.dismiss();
        onClickInstallApk(apkVersion, timestamp);
      }
    }
  }


  /* void DownloadAPK2(String Version) async {
    toast('Downloading APK');
    print('Downloading APK');
    var now = new DateTime.now();
    var Timestamp = new DateFormat('ddMMyyHHmmss');
    String timestamp = Timestamp.format(now);
    // ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Download, isDismissible: false, showLogs: true);
    double process = 0;
    // _progressHUD.state.show();
    IsolateNameServer.registerPortWithName(
        _port1.sendPort, 'downloader_send_port2');
    try {
      _port1.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        print('downloadstatus' + status.toString());
        int progress = data[2];
        print('progressloading' + progress.toString());
        setState(() async {
          process = progress / 100;

          // pr.style(
          //     message: 'Downloading file...',
          //     borderRadius: 10.0,
          //     backgroundColor: Colors.white,
          //     progressWidget: CircularProgressIndicator(),
          //     elevation: 10.0,
          //     insetAnimCurve: Curves.easeInOut,
          //     progress: process,
          //     maxProgress: 100.0,
          //     progressTextStyle: TextStyle(
          //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          //     messageTextStyle: TextStyle(
          //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
          // );
          // pr.show();
          if (progress == 100) {
            // _progressHUD.state.dismiss();
            *//* Directory? documentsDirectory = await getExternalStorageDirectory();
            String path = documentsDirectory!.path + "/" + appDatas.apkname;
            // toast('path '+path);
            print('path ' + path);*//*
            onClickInstallApk(Version, timestamp);
            print("progress_apk" + progress.toString());
          }
        });
      });
    } catch (e) {
      toast('downloaderror : ' + e.toString());
      print('downloaderror : ' + e.toString());
    }

    FlutterDownloader.registerCallback(downloadCallback2);
    Directory? documentsDirectory = await getExternalStorageDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: appDatas.apkdownloadurl,
      savedDir: documentsDirectory!.path,
      showNotification: true,
      fileName: "nhts_" + Version + "_" + timestamp + ".apk",
// show download progress in status bar (for Android)
      openFileFromNotification:
      true, // click on notification to open downloaded file (for Android)
    );
  }*/

  /* Future DownloadAPK2(String Version) async {
    try {
      var now = new DateTime.now();
      var Timestamp = new DateFormat('ddMMyyHHmmss');
      String timestamp = Timestamp.format(now);
      Directory? documentsDirectory = await getApplicationDocumentsDirectory();
      String savePath = documentsDirectory!.path +
          "/nhts_" +
          Version +
          "_" +
          timestamp +
          ".apk";
      print('savePath ' + savePath);
      bool downloaded = false;
      Response response = await Dio().get(
        appDatas.apkdownloadurl,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('apkdownload ' +
                (received / total * 100).toStringAsFixed(0) +
                "%");
            if ((received / total * 100).toStringAsFixed(0) == "100") {
              if (!downloaded) {
                downloaded = true;
                onClickInstallApk(Version, timestamp);
              }
            }
          }
        },
        //         onReceiveProgress: (received, total) => {
        //         if (total != -1) {
        //
        //         if (received / total * 100 == 100){
        //
        //       DBdownload = true;
        //       if (latest) {
        //         SharedPreferences prefs = await SharedPreferences.getInstance();
        //         prefs.setString("DBVERSION", newVersion);
        //         Navigator.of(context).pushReplacement(MaterialPageRoute(
        //             builder: (BuildContext context) => LoginStateful()));
        //       }
        //     }
        //   }
        // },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }*/

  void onClickInstallApk(String Version, String timestamp) async {
    // String _apkFilePath = appDatas.apkname;
    String _apkFilePath = "nhts_" + Version + "_" + timestamp + ".apk";
    //toast('Installing APK');
    if (_apkFilePath.isEmpty) {
      //print('make sure the apk file is set');
      return;
    }
    var permissions = await Permission.storage.status;
    if (permissions.isGranted) {
      var storageDir = await getExternalStorageDirectory();
      final dirPath = storageDir?.path ?? '/';

      final resultPath = '$dirPath' + '/' + '$_apkFilePath';

      var file = File(resultPath);
      var isExists = await file.exists();
      /* print(''
          ' _apkFilePath $resultPath exists $isExists');

      InstallPlugin.installApk(resultPath, 'com.sts.datagreen.nhts')
          .then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });*/

      //print('onClickInstallApk _apkFilePath $resultPath exists $isExists');
      Directory? documentsDirectory = await getExternalStorageDirectory();
      String savePath = documentsDirectory!.path +
          "/nhts_" +
          Version +
          "_" +
          timestamp +
          ".apk";
      //print("InstallPath"+savePath.toString());
      //AppInstaller.installApk(savePath);
    } else {
      //toast('Permission request fail!');
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port2');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  static void downloadCallback2(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port2');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.transparent,
    ));
// TODO: implement build
    return Scaffold(
      body: Builder(
// Create an inner BuildContext so that the onPressed methods
// can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return Stack(
            children: [
              Center(
                child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black, Colors.transparent],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'images/agrobg.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextLiquidFill(
                                      text: appDatas.appname,
                                      waveColor: Colors.green,
                                      boxBackgroundColor: Colors.white,
                                      textStyle: TextStyle(
                                        fontSize: 60.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      boxHeight: 200.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                        width: 250.0,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              'Powered by Horticulture Crops Directorate (HCD, Kenya)',
                                              textStyle: const TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              speed: const Duration(
                                                  milliseconds: 500),
                                            ),
                                          ],
                                          totalRepeatCount: 4,
                                          pause: const Duration(
                                              milliseconds: 1000),
                                          displayFullTextOnTap: true,
                                          stopPauseOnTap: true,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: DBdownload
                                  ? Container() //true
                                  : Container(
                                //false
                                child: LiquidLinearProgressIndicator(
                                  value: process,
// Defaults to 0.5.
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.green),
// Defaults to the current Theme's accentColor.
                                  backgroundColor: Colors.white,
// Defaults to the current Theme's backgroundColor.
                                  borderColor: Colors.green,
                                  borderWidth: 5.0,
                                  direction: Axis.horizontal,
// The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                  center: Text("Downloading Database..."),
                                ),
                              ))
                        ])),
              ),
              // Positioned(
              //   child: _progressHUD,
              // ),
            ],
          );
        },
      ),
    );
  }

  /* confirmationPopup(dialogContext, String apkVersion) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      overlayColor: Colors.black87,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Update ",
        desc: "New update is available ! Please update the application",
        buttons: [
          DialogButton(
            child: Text(
              "UPDATE NOW",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () async {
              Navigator.pop(dialogContext);

              // DownloadAPK2(apkVersion);
              DownloadAPK(apkVersion);
            },
            color: Colors.green,
          )
        ]).show();
  }
}*/

  confirmationPopup(dialogContext,String apkVersion) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      overlayColor: Colors.black87,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Update ",
        desc: "New update is available ! Please update the application",
        buttons: [
          DialogButton(
            child: Text(
              "UPDATE NOW",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:btnok,
            onPressed: () async {
              Navigator.pop(dialogContext);

              if(appDatas.playstore){
                LaunchReview.launch(androidAppId: "com.sts.datagreen.nhts");
              }else{
                DownloadAPK(apkVersion);
              }
            },
            color: Colors.green,
          )
        ]).show();
  }
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12.0);
}

String ChangeDecimalTwo(String value) {
  final formatter = new NumberFormat("0.00");
  String values = formatter.format(double.parse(value));
  return values;
}

String ChangeDecimalThree(String value) {
  final formatter = new NumberFormat("0.000");
  String values = formatter.format(double.parse(value));
  return values;
}
