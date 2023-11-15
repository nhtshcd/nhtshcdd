import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Plugins/RestPlugin.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:nhts/main.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/secure_storage.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePassword();
  }
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController CurrentPasswordController = new TextEditingController();
  TextEditingController NewPasswordController = new TextEditingController();
  TextEditingController ConfirmNewPasswordController =
      new TextEditingController();
  List<Map> agents = [];
  String seasoncode = '';
  String servicePointId = '';
  String agentId = "";
  bool currentPassType = true;
  bool newPassType = true;
  bool confirmPassType = true;

  var db = DatabaseHelper();

  String Lat = '';
  String Lng = '';
  String password = "",
      passwordChangedDate = "",
      passwordSetDate = "",
      userNamePassword = "",
      enCodePassword = "",
      updatedPassword = "";
  bool _internetconnection = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  bool boolValuePassword = false;

  @override
  void initState() {
    super.initState();
    getClientData();
    initConnectivity();
    pendingTransactionCheck();
  }

  pendingTransactionCheck() async {
    List<Map> custTransactions = await db.GetTableValues('custTransactions');
    if (custTransactions.length > 0) {
      Alert(
        onWillPopActive: true,
        context: context,
        type: AlertType.warning,
        title: "Information",
        closeFunction: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        desc: "Pending Transaction Available Could not Proceed Change Password",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show();
    } else {}
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');

    seasoncode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    userNamePassword = agents[0]['agentPassword'];
  }

  getCustomTransaction() async {}

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude :" +
        position.latitude.toString() +
        " longitude: " +
        position.longitude.toString());
    setState(() {
      Lat = position.latitude.toString();
      Lng = position.longitude.toString();
    });
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

          errordialogInternet(
              context, "Information", "Please check your Internet Connection");
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          _connectionStatus = 'Failed to get connectivity.';

          errordialogInternet(
              context, "Information", "Please check your Internet Connection");
        });
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /* @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              'Change Password',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Container(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: ChangePasswordUI(
                  context), // <<<<< Note this change for the return type
            ),
          ),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              'Change Password',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: ChangePasswordUI(
                      context), // <<<<< Note this change for the return type
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> ChangePasswordUI(BuildContext context) {
    List<Widget> listings = [];

    listings.add(txt_label_icon("Current Password", Colors.black, 14.0, true));

    listings.add(txtfield_Password(
        "Current Password",
        CurrentPasswordController,
        true,
        60,
        currentPassType,
        currentPassFun,
        "Current Password"));

    listings.add(txt_label_icon("New Password", Colors.black, 14.0, true));
    listings.add(txtfield_Password("New Password", NewPasswordController, true,
        60, newPassType, newPassFun, "New Password"));
    listings
        .add(txt_label_icon("Confirm New Password", Colors.black, 14.0, true));
    listings.add(txtfield_Password(
        "Confirm New Password",
        ConfirmNewPasswordController,
        true,
        60,
        confirmPassType,
        confirmPassFun,
        "Confirm New Password"));

    // listings.add(
    //   Container(
    //       padding: const EdgeInsets.only(bottom: 20, top: 20),
    //       child: Text(
    //           " *  Passwords length must be minimum 6 digits of alphanumeric characters.",
    //           style: TextStyle(
    //             color: Colors.blueAccent,
    //           ),
    //           textAlign: TextAlign.left)),
    // );

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Save',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  initConnectivity();

                  final key = 'STRACE@12345SAKTHIATHISOURCETRACE';
                  restplugin rest = restplugin();
                  String userPassword =
                      agentId + CurrentPasswordController.text;
                  enCodePassword = SecureStorage().encryptAES(userPassword);
                  print("encode password:"+enCodePassword);
                  print("userpassword:"+userNamePassword);

                  if (CurrentPasswordController.text.length == 0) {
                    alertPopup(context, "Please enter current password");
                  }
                  else if (enCodePassword != userNamePassword) {
                    alertPopup(
                        context, "Please Enter Correct Current Password");
                  }
                  else if (NewPasswordController.text.length == 0) {
                    alertPopup(context, "Please enter new password");
                  }
                  // else if (NewPasswordController.text.length < 6) {
                  //   alertPopup(context, "New password should be minimum 6 digits");
                  // }
                  else if (ConfirmNewPasswordController.text.length == 0) {
                    alertPopup(context, "Please confirm new password");
                  } else {
                    if (NewPasswordController.text ==
                        ConfirmNewPasswordController.text) {
                      if (_internetconnection) {
                        changePassword();
                      } else {}
                    } else {
                      alertPopup(context,
                          "New Password and Confirm New Password do not match");
                    }
                  }
                },
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Cancel',
                  style: new TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    ));

/*    listings.add(
      Expanded(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: MaterialButton(
            onPressed: () => {},
            child: Text('REGISTER'),
          ),
        ),
      ),
    );*/

    return listings;
  }

  void currentPassFun() async {
    setState(() {
      currentPassType = !currentPassType;
    });
  }

  void confirmPassFun() async {
    setState(() {
      confirmPassType = !confirmPassType;
    });
  }

  void newPassFun() async {
    setState(() {
      newPassType = !newPassType;
    });
  }

  void changePassword() async {
    final now = new DateTime.now();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    passwordChangedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
    passwordSetDate = DateFormat('dd-MM-yyyy').format(now);
    String? serialnumber =await SecureStorage().readSecureData("serialnumber");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    List<String> versionlist = version
        .split(
            '.') // split the text into an array/ put the text inside a widget
        .toList();
    String? DBVERSION =await SecureStorage().readSecureData("DBVERSION");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    String? agentid =await SecureStorage().readSecureData("agentId");
    final key = 'STRACE@12345SAKTHIATHISOURCETRACE';
    //strace@12345sakthiathisourcetrace
    restplugin rest = restplugin();
    //password = rest.JwtHS256(ConfirmNewPasswordController.text, key);
    password = SecureStorage().encryptAES(ConfirmNewPasswordController.text);


    String changePassword = agentId + ConfirmNewPasswordController.text;
    //updatedPassword = rest.JwtHS256(changePassword, key);
    updatedPassword = SecureStorage().encryptAES(changePassword);


    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String ipAddressValue = '';
    try {
      final ipv4 = await Ipify.ipv4();
      ipAddressValue = ipv4.toString();
    } catch (e) {
      ipAddressValue = '';
    }

    var headdata = jsonEncode({
      "agentId": agentid,
      "agentToken": agentToken,
      "txnType": "358",
      "txnTime": txntime,
      "operType": "01",
      "mode": "01",
      "msgNo": msgNo,
      "resentCount": "0",
      "serialNo": serialnumber,
      "servPointId": servicePointId,
      "branchId": appDatas.tenent,
      "versionNo": versionlist[0] + "|" + DBVERSION!,
      "fsTrackerSts": "2|1",
      "tenantId": appDatas.tenent,
      "ipAddress": ipAddressValue
    });
    var reqdata = jsonEncode({
      "body": {
        "nPwd": password,
        "nPwdCDt": passwordChangedDate,
      },
      "head": jsonDecode(headdata)
    });
    print("changePaswordReq" + reqdata.toString());

    try {
      String decTxnUrl =await SecureStorage().decryptAES(appDatas.TXN_URL);
      var response = await Dio().post(decTxnUrl, data: reqdata);
      final responsebody = json.decode(response.toString());
      final jsonresponse = responsebody['Response'];
      final statusobjectr = jsonresponse['status'];
      final code = statusobjectr['code'];
      final message = statusobjectr['message'];

      print("response_response" + response.toString());

      if (code.toString() == "00") {
        savePasswordData();
      } else if (code.toString() == "SERVER_ERROR") {
        serverAlert();
      } else {
        String errorMessage = message;
        if (errorMessage.length > 0) {
          alertPopup(context, errorMessage);
        } else {
          alertPopup(context, "Invalid Data");
        }
      }

      /*if (code.toString() == "550") {
        alertPopup(context, "Repeated Password");
      } else if (code.toString() == "551") {
        alertPopup(context, "Invalid Password");
      } else if (code.toString() == "552") {
        alertPopup(context, "Password should not contain Name or UserName");
      } else if (code.toString() == "553") {
        alertPopup(
            context, "Change Password and Exist Password Should not same");
      } else if (code.toString() == '00') {
        savePasswordData();
      } else {
        serverAlert();
      }*/
    } on DioError catch (ex) {
      alertPopup(context, "Connection  Timeout Exception");
    }
  }

  void savePasswordData() async {
    var db = DatabaseHelper();
    Random rnd = new Random();
    int recNo = 100000 + rnd.nextInt(999999 - 100000);
    String revNo = recNo.toString();

    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);


    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0, \'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\', \'' +
            agentid! +
            '\',\' ' +
            agentToken! +
            '\',\' ' +
            msgNo +
            '\',\' ' +
            servicePointId +
            '\',\' ' +
            revNo +
            '\')';
    print('txnHeader ' + insqry);
    int succ = await db.RawInsert(insqry);
    print(succ);

    AppDatas datas = new AppDatas();
    int custTransaction = await db.saveCustTransaction(
        txntime, datas.txn_changePassword, revNo, '', '', '');
    print('custTransaction : ' + custTransaction.toString());

    db.DeleteTable("passwordSynch");
    String passwordSynch =
        'INSERT INTO "main"."passwordSynch" ("passwordValue", "passwordDate", "isSynched", "recId") VALUES ('
                ' \'' +
            ConfirmNewPasswordController.text +
            '\', ' +
            '\'' +
            passwordChangedDate +
            '\', ' +
            '\'1\', ' +
            '\'' +
            revNo +
            '\')';
    int passwordsucc = await db.RawInsert(passwordSynch);

    print("agentId_agentId" + agentId.toString());

    db.UpdateTableValue(
        'agentMaster', 'pwExpDays', passwordSetDate, 'agentId', agentId);
    db.UpdateTableValue(
        'agentMaster', 'agentPassword', updatedPassword, 'agentId', agentId);

    await SecureStorage().writeSecureData("agentToken", updatedPassword);

    db.DeleteTableRecord('custTransactions', 'txnRefId', revNo);


   // await pref.setBool('passwordChanged', true);
    String passChanged = "true";
    await SecureStorage().writeSecureData('passwordChanged', passChanged);

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Password Changed Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
      closeFunction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    ).show();
  }

  void serverAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Information",
      desc: "Server Error",
      closeFunction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
    ).show();
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure want to cancel?",
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {

               // String pChanged = await SecureStorage().readSecureData("passwordChanged");

                // if (pChanged.isNotEmpty) {
                //   boolValuePassword =await SecureStorage().readSecureData('passwordChanged')!;
                //   if (boolValuePassword) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  // } else {
                  //   Navigator.pop(context);
                  //   alertPopup(context, "Please Change Password");
                  // }
                // } // password changes mandatory  for first time login
                // else {
                //   Navigator.pop(context);
                //   Navigator.pop(context);
                // }
              },
              width: 120,
            ),
            DialogButton(
              child: Text(
                "No",
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
}

errordialogInternet(dialogContext, String title, String description) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle:
        TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: dialogContext,
      style: alertStyle,
      title: title,
      desc: description,
      closeFunction: () {
        Navigator.pop(dialogContext);
        Navigator.pop(dialogContext);
      },
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
            Navigator.pop(dialogContext);
          },
          color: Colors.green,
        )
      ]).show();
}
