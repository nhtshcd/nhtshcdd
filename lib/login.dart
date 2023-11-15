import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:progress_hud/progress_hud.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:nhts/Plugins/RestPlugin.dart';
import 'package:nhts/Screens/ChangePassword.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Database/Databasehelper.dart';
import 'Model/LoginResponseModel2.dart';
import 'Model/User.dart';
import 'Screens/navigation.dart';
import 'Screens/qrcode.dart';
import 'Utils/dynamicfields.dart';
import 'Utils/secure_storage.dart';

const CURVE_HEIGHT = 160.0;
const AVATAR_RADIUS = CURVE_HEIGHT * 0.28;
const AVATAR_DIAMETER = AVATAR_RADIUS * 2;
var db = DatabaseHelper();

class LoginStateful extends StatefulWidget {
  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<LoginStateful> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  String passwordtx = 'Password',
      signintx = 'Sign In',
      logintx = 'Login',
      usernametx = 'Username';

  // ProgressHUD? _progressHUD;
  String type = "1";
  String _connectionStatus = 'Unknown';
  bool _internetconnection = false;
  bool synced = false;
  String transactioncount = '0';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool isremembered = false, passwordExpire = false;
  String expireDate = "";
  bool isObscure = true;
  String getUserName = "";
  bool alreadyExist = false;
  String loginValue = '';

  @override
  void initState() {
    super.initState();

    initConnectivity();

    GetDatas();
    checkpendingtransaction();

    // usernamecontroller.text='1289';
    // passwordcontroller.text='123456';
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // _progressHUD = new ProgressHUD(
    //   backgroundColor: Colors.black12,
    //   color: Colors.white,
    //   containerColor: Colors.green,
    //   borderRadius: 5.0,
    //   loading: false,
    //   text: 'Loading...',
    // );
    // SharedPreferences.getInstance().then((prefs) {
    //   setState(() => sharedPrefs = prefs);
    // });

    checkpermission();
    checkremberme();
  }

  Future<void> checkremberme() async {
    String? rememberme = await SecureStorage().readSecureData("rememberme");
    if (rememberme != null && rememberme.length > 0 && rememberme == "true") {
      //print('CHECK_REMEMBERME 1');
      String? Username = await SecureStorage().readSecureData("username");
      String? Password = await SecureStorage().readSecureData("password");
      if (Username != null &&
          Username.length > 0 &&
          Password != null &&
          Password.length > 0) {
        usernamecontroller.text = Username;
        passwordcontroller.text = Password;
      }
      isremembered = true;
    } else {
      isremembered = false;
      //print('CHECK_REMEMBERME 2');
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
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
        setState(() {
          _internetconnection = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _internetconnection = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _internetconnection = false;

          _connectionStatus = 'No internet connection';
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'Failed to get connectivity.';
        });
        break;
    }
  }

  Future<void> checkpermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request();
    print(statuses[Permission.location]);
    print('bluetooth--' + statuses[Permission.bluetooth].toString());
    print('bluetoothScan--' + statuses[Permission.bluetoothScan].toString());
    print('bluetoothConnect--' +
        statuses[Permission.bluetoothConnect].toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              child: Stack(children: <Widget>[
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      transactioncount,
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: synced && _internetconnection
                        ? BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green)
                        : BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  child: new Column(
                    children: <Widget>[
                      Align(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('images/agrobg.jpg'),
                              fit: BoxFit.fitHeight,
                            ),
                            color: Colors.green,
//                        border: Border.all(color: Colors.black, width: 0.0),
                            borderRadius: new BorderRadius.only(
                                bottomRight: Radius.circular(150)),
                          ),
                          child: Text('     '),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 270,
                                padding: EdgeInsets.all(5.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      LogoAsset(),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(5.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      logintx,
                                      style: new TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Card(
                                elevation: 5,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                )),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(5.0),
                                                margin: EdgeInsets.all(5.0),
                                                child: TextFormField(
                                                  style: new TextStyle(
                                                      color: Colors.white),
                                                  controller:
                                                      usernamecontroller,
                                                  decoration:
                                                      const InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          icon: Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white),
                                                          labelText:
                                                              'User Name',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          fillColor: Colors
                                                              .transparent,
                                                          filled: true),
                                                  onSaved: (String? value) {
                                                    // This optional block of code can be used to run
                                                    // code when the user saves the form.
                                                  },
                                                  validator: (String? value) {
                                                    return value!.contains('@')
                                                        ? 'Do not use the @ char.'
                                                        : null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
//                                elevation: 5.0,
//                                color: Colors.red,
//                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        child: Row(
                                          children: <Widget>[
                                            new Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(5.0),
                                                margin: EdgeInsets.all(5.0),
                                                child: TextFormField(
                                                  style: new TextStyle(
                                                      color: Colors.white),
                                                  controller:
                                                      passwordcontroller,
                                                  obscureText: isObscure,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      /* icon: Icon(Icons.lock,
                                                          color: Colors.white),*/
                                                      icon: InkWell(
                                                        child: Icon(
                                                          isObscure
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: Colors.white,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            isObscure =
                                                                !isObscure;
                                                          });
                                                        },
                                                      ),
                                                      labelText: 'Password ',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      fillColor:
                                                          Colors.transparent,
                                                      filled: true),
                                                  onSaved: (String? value) {
                                                    // This optional block of code can be used to run
                                                    // code when the user saves the form.
                                                  },
                                                  validator: (String? value) {
                                                    return value!.contains('@')
                                                        ? 'Do not use the @ char.'
                                                        : null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 15),
                                  child: chkbox_dynamic(
                                    label: "Remember Me",
                                    checked: isremembered,
                                    onChange: (value) => setState(() {
                                      isremembered = value!;
                                    }),
                                  )),
                              Container(
                                  width: 150,
                                  margin: EdgeInsets.only(top: 5),
                                  child: RaisedButton(
                                    child: Text(
                                      signintx,
                                      style: new TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      /*   if (!_internetconnection) {
                                        List<Map> agents = await db.RawQuery(
                                            'SELECT pwExpDays, pwDate FROM agentMaster');
                                        setState(() {
                                          if (agents.length > 0) {
                                            String expireDate =
                                                agents[0]['pwExpDays'];
                                            String age = agents[0]['pwDate'];
                                            expireDateComparison(
                                                expireDate, age);
                                          }
                                        });
                                      }*/
                                      if (usernamecontroller.text == '') {
                                        AlertPopup('Please enter Username');
                                      } else if (passwordcontroller.text ==
                                          '') {
                                        AlertPopup('Please enter Password');
                                      } else if (_internetconnection &&
                                          synced) {
                                        LoginCheck2(
                                            context,
                                            usernamecontroller.text
                                                .toLowerCase(),
                                            passwordcontroller.text);
                                      } else {
                                        if (_internetconnection) {
                                          var alertStyle = AlertStyle(
                                            animationType: AnimationType.shrink,
                                            overlayColor: Colors.black87,
                                            isCloseButton: false,
                                            isOverlayTapDismiss: false,
                                            titleStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            descStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                            animationDuration:
                                                Duration(milliseconds: 400),
                                          );

                                          Alert(
                                              context: context,
                                              style: alertStyle,
                                              title: "Login ",
                                              desc:
                                                  "Pending transaction available do you want to continue ?",
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                  //onPressed:btnok,
                                                  onPressed: () async {
                                                    Navigator.pop(context);

                                                    offlineLogin(
                                                        usernamecontroller.text
                                                            .toLowerCase(),
                                                        passwordcontroller
                                                            .text);
                                                  },
                                                  color: Colors.green,
                                                )
                                              ]).show();
                                        } else {
                                          offlineLogin(
                                              usernamecontroller.text
                                                  .toLowerCase(),
                                              passwordcontroller.text);
                                        }
                                      }
                                    },
                                    color: Colors.green,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  child: new Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text(
                          'Powered by Horticulture Crops Directorate (HCD, Kenya)',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Positioned(
                //   child: _progressHUD!,
                // ),
              ]),
            );
          },
        ),
      ),
    );
  }

  void AlertPopup(String message) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Alert",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  void changePasswordAlert() {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Alert",
      desc: "Change your Password before Login",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            //await prefs.setBool('passwordChanged', false);
            String passChanged = "false";
            await SecureStorage()
                .writeSecureData('passwordChanged', passChanged);
            EasyLoading.dismiss();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ChangePassword()));
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future<void> offlineLogin(String username, String password) async {
    String? Username = await SecureStorage().readSecureData("username");
    String? Password = await SecureStorage().readSecureData("password");
    if (username == Username && password == Password) {
      if (!passwordExpire) {
        List<PrintModel> printLists = [];
        printLists.add(PrintModel("kirubha", "kirubha"));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => QrReader("kirubha", printLists)));
        EasyLoading.dismiss();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoard(
                  '',
                  '',
                )));
      } else {
        AlertPopup("Password Expired");
      }
    } else {
      confirmationPopup(context, "Incorrect Username or Password");
    }
  }

  confirmationPopup(BuildContext dialogContext, String message) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    print("CHECKMESSAGE " + message);
    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "Login Failed",
        desc: message,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  void checkpendingtransaction() {
    try {
      Timer.periodic(Duration(seconds: 2), (timer) async {
        GetDatas();
      });
    } catch (Except) {
      print("CHECK_EXCEPTION: " + Except.toString());
    }
  }

  void GetDatas() async {
    try {
      // checking transaction count before update
      var db = DatabaseHelper();
//    List<FarmerMaster> farmermaster = new List();
      List<Map> headerdata = await db.GetTableValues('txnHeader');
      print('headerdata ' + headerdata.toString());
      List<Map> custTransactions = await db.GetTableValues('custTransactions');
      print('custTransactions ' + custTransactions.toString());
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
    } catch (e) {
      // for first time
      print('pendingtransaction' + e.toString());
    }
  }

  Future<void> LoginCheck2(
      BuildContext context, String username, String Password) async {
    // _progressHUD!.state.show();
    print("login check2 called");
    restplugin rest = restplugin();

    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      print("login check2 called login check2 called");
      final String response = await rest.loginApi(username, Password);
      printWrapped('loginApiResponse ' + response);
      Map<String, dynamic> json = jsonDecode(response);
      print('JSON:' + json.toString());

      Map<String, dynamic> code1 = json['Response']['status'];
      print("Status:" + code1.toString());
      String code = code1['code'];
      print("code:" + code.toString());
      if (code == '00') {
        LoginResponse logindata = LoginResponse.fromJson(json);

        print("logindata:" + logindata.response.toString());

        String? agentToken = await SecureStorage().readSecureData("agentToken");

        /*final snackBar =
        SnackBar(content: Text(logindata.response.status.message));
        Scaffold.of(context).showSnackBar(snackBar);*/
        print(" Codeeee ${logindata.response!.status!.code!.toString()}");
        if (logindata.response!.status!.code! == '00') {
          print("login 00");
          // toast(logindata.response.status.code );
          final clientProjectRev =
              logindata.response!.body!.agentLogin!.clientRevNo!;
          final agentDistributionBal =
              logindata.response!.body!.agentLogin!.bal!;

          final agentProcurementBal =
              logindata.response!.body!.agentLogin!.distImgAvil!;
          final currentSeasonCode =
              logindata.response!.body!.agentLogin!.currentSeasonCode!;
          const pricePatternRev = "0";
          final agentType = logindata.response!.body!.agentLogin!.agentType!;

          final tareWeight = logindata.response!.body!.agentLogin!.tare!;
          //String clientIdSeqS = logindata.response.body.agentLogin.spIdSeq;
          //List<String> clientIdSeqss = clientIdSeqS.split('|');
          //final curIdSeqS = clientIdSeqss[0];
          //final resIdSeqS = clientIdSeqss[1];
          //final curIdLimitS = clientIdSeqss[2];
          String clientIdSeqF =
              logindata.response!.body!.agentLogin!.clientIdSeq!;
          List<String> clientIdSeqFs = clientIdSeqF.split('|');
          print('clientIdSeqF' + clientIdSeqF);
          final curIdSeqF = clientIdSeqFs[0];
          final resIdSeqF = clientIdSeqFs[1];
          final curIdLimitF = clientIdSeqFs[2];
          final agentAccBal = "";
          final farmerRev = logindata.response!.body!.agentLogin!.farmerRevNo!;
          final shopRev = "0";
////int
          final agentId = username;
////int
          final agentName = logindata.response!.body!.agentLogin!.agentName!;
          final cityCode = "";
          final servPointName =
              logindata.response!.body!.agentLogin!.servPointName!;
          final agentPassword = agentToken;
          final servicePointId =
              logindata.response!.body!.agentLogin!.servPointId!;
          final locationRev = "0";
          final trainingRev = "0";
          final plannerRev = 0;
          final farmerOutStandBalRev = 0;
          final productDwRev = 0;
          final farmCrpDwRev = 0;
          final procurementProdDwRev = "";
          final villageWareHouseDwRev = 0;
          final gradeDwRev = 0;
          final wareHouseStockDwRev = 0;
          final coOperativeDwRev = 0;
          final trainingCatRev = 0;
          final seasonDwRev = 0;
          final fieldStaffRev = 0;
          final areaCaptureMode = '0';
          print("CHECKlogintxn " + areaCaptureMode);
          final interestRateApplicable = "";
          final rateOfInterest = "";
          final effectiveFrom = logindata.response!.body!.agentLogin!.eFrom!;
          final isApplicableForExisting = "";
          final previousInterestRate = "";
          final qrScan = "";
          final geoFenceFlag = logindata.response!.body!.agentLogin!.gFReq!;
          final geoFenceRadius = logindata.response!.body!.agentLogin!.gRad!;
          final buyerDwRev = "";
          final catalogDwRev = "0";
          final parentID = logindata.response!.body!.agentLogin!.parentId!;
          final branchID = logindata.response!.body!.agentLogin!.branchId!;
          final isGeneric = logindata.response!.body!.agentLogin!.isGeneric!;
          final supplierDwRev = "0";
          final researchStationDwRev = "0";
          final displayDtFmt =
              logindata.response!.body!.agentLogin!.dispDtFormat!;
          final batchAvailable =
              logindata.response!.body!.agentLogin!.isBatchAvail!;
          final isGrampnchayat =
              logindata.response!.body!.agentLogin!.isGrampnchayat!;
          final areaUnitType = logindata.response!.body!.agentLogin!.areaType!;
          final shipmentUrl =
              logindata.response!.body!.agentLogin!.shipmentUrl!;
          final currency = "";
          final farmerfarmRev = "0";
          final farmerfarmcropRev = "0";
          final warehouseId = "";
          final farmerStockBalRev = "0";
          final latestSeasonRevNo = "";
          final latestCatalogRevNo = "";
          final latestLocationRevNo = "";
          final latestCooperativeRevNo = "";
          final latestProcproductRevNo = "";
          final latestFarmerRevNo = "0";
          final latestFarmRevNo = 'null';
          final latestFarmCropRevNo = 'null';
          final dynamicDwRev = 0;
          final isBuyer = 'null';
          final distributionPhoto = 'null';
          final latestwsRevNo =
              logindata.response!.body!.agentLogin!.dynLatestRevNo!;
          /*      final digitalSign = 'null';*/
          final digitalSign = '';
          final cropCalandar =
              logindata.response!.body!.agentLogin!.cropCalandar!;
          final packHouseId =
              logindata.response!.body!.agentLogin!.packHouseId!;
          final packHouseCode =
              logindata.response!.body!.agentLogin!.packHouseCode!;
          final packHouseName =
              logindata.response!.body!.agentLogin!.packHouseName!.toString();
          final expLic =
              logindata.response!.body!.agentLogin!.expLic!.toString();
          final eventDwRev = "0";
          final seasonProdFlag = 'null';
          final followUpRevNo = "0";
          final lotNoPack = "";

          final exporterName =
              logindata.response!.body!.agentLogin!.expName!.toString();
          final exporterCode =
              logindata.response!.body!.agentLogin!.expCode!.toString();

          final ag_days =
              logindata.response!.body!.agentLogin!.ag_days.toString();
          final p_age = logindata.response!.body!.agentLogin!.p_age.toString();
          final p_rem = logindata.response!.body!.agentLogin!.p_rem.toString();
          final variety =
              logindata.response!.body!.agentLogin!.variety.toString();
          final grade = logindata.response!.body!.agentLogin!.gCode.toString();
          final fLogin =
              logindata.response!.body!.agentLogin!.fLogin.toString();
          final expDate =
              logindata.response!.body!.agentLogin!.expDate.toString();
          final expStatus =
              logindata.response!.body!.agentLogin!.expStatus.toString().isEmpty
                  ? ""
                  : logindata.response!.body!.agentLogin!.expStatus.toString();

          print("AgentTypeaa" + agentType + " " + expStatus);
          loginValue = fLogin.toString();

          await SecureStorage().writeSecureData("agentType", agentType);
          await SecureStorage().writeSecureData("expDate", expDate);
          await SecureStorage().writeSecureData("expStatus", expStatus);
          await SecureStorage().writeSecureData("expLic", expLic);

//
          var db = DatabaseHelper();
          int deltsucc = await db.DeleteTable("agentMaster");
          print(deltsucc);
          db.saveUser(User(
              clientProjectRev.toString(),
              agentDistributionBal.toString(),
              agentProcurementBal.toString(),
              currentSeasonCode.toString(),
              pricePatternRev.toString(),
              agentType.toString(),
              tareWeight.toString(),
              "",
              "",
              "",
              curIdLimitF,
              resIdSeqF,
              curIdSeqF,
              agentAccBal.toString(),
              farmerRev.toString(),
              shopRev.toString(),
              agentId.toString(),
              agentName.toString(),
              cityCode.toString(),
              servPointName.toString(),
              agentPassword.toString(),
              servicePointId.toString(),
              locationRev.toString(),
              trainingRev.toString(),
              plannerRev.toString(),
              farmerOutStandBalRev.toString(),
              productDwRev.toString(),
              farmCrpDwRev.toString(),
              procurementProdDwRev.toString(),
              villageWareHouseDwRev.toString(),
              gradeDwRev.toString(),
              wareHouseStockDwRev.toString(),
              coOperativeDwRev.toString(),
              trainingCatRev.toString(),
              seasonDwRev.toString(),
              fieldStaffRev.toString(),
              areaCaptureMode.toString(),
              interestRateApplicable.toString(),
              rateOfInterest.toString(),
              effectiveFrom.toString(),
              isApplicableForExisting.toString(),
              previousInterestRate.toString(),
              qrScan.toString(),
              geoFenceFlag.toString(),
              geoFenceRadius.toString(),
              buyerDwRev.toString(),
              catalogDwRev.toString(),
              parentID.toString(),
              branchID.toString(),
              isGeneric.toString(),
              supplierDwRev.toString(),
              researchStationDwRev.toString(),
              displayDtFmt.toString(),
              batchAvailable.toString(),
              isGrampnchayat.toString(),
              areaUnitType.toString(),
              currency.toString(),
              farmerfarmRev.toString(),
              farmerfarmcropRev.toString(),
              warehouseId.toString(),
              farmerStockBalRev.toString(),
              latestSeasonRevNo.toString(),
              latestCatalogRevNo.toString(),
              latestLocationRevNo.toString(),
              latestCooperativeRevNo.toString(),
              latestProcproductRevNo.toString(),
              latestFarmerRevNo.toString(),
              latestFarmRevNo.toString(),
              latestFarmCropRevNo.toString(),
              dynamicDwRev.toString(),
              isBuyer.toString(),
              distributionPhoto.toString(),
              latestwsRevNo.toString(),
              digitalSign.toString(),
              cropCalandar.toString(),
              eventDwRev.toString(),
              seasonProdFlag.toString(),
              followUpRevNo.toString(),
              lotNoPack.toString(),
              packHouseId.toString(),
              packHouseName.toString(),
              expLic,
              packHouseCode,
              exporterCode,
              exporterName,
              ag_days,
              p_age,
              p_rem,
              variety,
              grade,
              fLogin,
              expDate,
              expStatus,
              shipmentUrl));
/*
        setState(() {
          expireDate = ag_days;
          expireDateComparison(expireDate, p_age);
        });*/

          // String lastLoginUserName = '';
          // print("HHHHHHJHHH");
          // if (await SecureStorage().readSecureData("username")) {
          //
          //     String getName =await SecureStorage().readSecureData("username")!;
          //     lastLoginUserName = getName.trim();
          //     setState(() {  });
          // } else {
          //   print('initialLogin');
          // }

          await SecureStorage().writeSecureData("username", username);
          await SecureStorage().writeSecureData("password", Password);

          if (isremembered) {
            await SecureStorage().writeSecureData("rememberme", "true");
          } else {
            await SecureStorage().writeSecureData("rememberme", "false");
          }

          String? serialnumber =
              await SecureStorage().readSecureData("serialnumber");
          print('serialnumber' + serialnumber.toString());

          String getDeviceSerialNumber = '';
          restplugin rest = restplugin();
          getDeviceSerialNumber = await rest.getSerialnumber();
          print('getDeviceSerialNumber' + getDeviceSerialNumber.toString());

          if (loginValue == '0') {
            EasyLoading.dismiss();
            changePasswordAlert();
          } else {
            EasyLoading.dismiss();
            // List<PrintModel> printLists = [];
            //   printLists.add(PrintModel("Reception Batch No", "93287492134"));
            // printLists.add(PrintModel("Name", "kirubha"));
            // printLists.add(PrintModel("Farmer Id", "345235"));
            // printLists.add(PrintModel("Product Name", "Apple"));
            // printLists.add(PrintModel("Variety Name", "Fruit"));
            //
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => QrReader("kirubha printer demo print", printLists)));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoard(
                      '',
                      '',
                    )));
          }

          usernamecontroller.text = '';
          passwordcontroller.text = '';
        }
      } else {
        EasyLoading.dismiss();
        String errorMessage = json['Response']['status']['message'];
        confirmationPopup(context, errorMessage);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }

    // _progressHUD!.state.dismiss();
    // print(response);
  }

/*  void expireDateComparison(String createdDate, String pAge) async {
    print("expireDate_expireDate" + expireDate.toString());
    print("pAge" + pAge.toString());
    if (createdDate != "") {
      DateTime dateToday = new DateTime.now();

      print("dateToday_dateToday" + dateToday.toString());
      print("expireDate_expireDate" + createdDate.toString());

      List<String> splitStartDate = createdDate.split('-');

      String strYearq = splitStartDate[2];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[0];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertCreatedDate = new DateTime(strYear, strMonths, strDate);

      final difference = daysBetween(convertCreatedDate, dateToday);
      int passwordAge = int.parse(pAge);

      if (difference > passwordAge) {
        setState(() {
          passwordExpire = true;
        });
      } else {
        passwordExpire = false;
      }
    }
  }*/

/*
  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');

        print('address' + addr.address.toString());
        print('isLoopback' + addr.isLoopback.toString());
        print('rawAddress' + addr.rawAddress.toString());
        print('address' + addr.type.name.toString());
      }
    }
  }
*/

  String JwtHS256(String subdata, String hmacKey) {
    final hmac = Hmac(sha256, hmacKey.codeUnits);

//    json.decode({"numberPhone":"+22565786589", "country":"CI"});
    // Use SplayTreeMap to ensure ordering in JSON: i.e. alg before typ.
    // Ordering is not required for JWT: it is deterministic and neater.
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
}

ChangeLoginStatus(bool login) async {
  if (login) {
    await SecureStorage().writeSecureData("LOGIN", "1");
  } else {
    await SecureStorage().writeSecureData("LOGIN", "0");
  }
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: CustomPaint(
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LogoAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetimage = AssetImage('images/newlogo.png');
    Image image = Image(
      image: assetimage,
      width: 250.0,
      height: 100.0,
    );
    return Container(
      child: image,
    );
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
