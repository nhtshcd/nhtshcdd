import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Screens/PackingScreen.dart';
import 'package:nhts/Screens/qrcode.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/QrScanner.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zebrautility/ZebraPrinter.dart';
import 'package:zebrautility/zebrautility.dart';

import '../Utils/QRScannerAndroid.dart';
import '../Utils/secure_storage.dart';
import '../login.dart';
import '../main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
class Shipment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Spraying();
}

class _Spraying extends State<Shipment> {
  String farmerTraceCode = "";

  String shipmentDate = '', labelshipmentDate = '';
  bool printerConnected = false;
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';
  String slcValue = "";

  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      exporterId = "",
      packHouseName = "",
      packHouseID = "",
      latitude = "",
      longitude = "";
  String plantingDate = "";
  String qrExporterId = "", qrPackHouseID = "";
  String traceCode = "";
  String Qrvalue = "";
  String shipmentURL = "";
  String UCRValue = "";
  var Qr = [];

  int curIdLim = 0, resId = 0, curIdLimited = 0, farmerId = 0;
  List<ShipmentConsignment> consignmentData = [];

  List<DropdownMenuItem> buyerDropDownLists = [];
  List<DropdownMenuItem> lotNumberDropDownLists = [];
  List<DropdownMenuItem> packingUnitDropDownLists = [];
  List<DropdownModel> blockDropDownList = [];
  List<DropdownModel> plantingItems = [];
  List checkOrderList =[];

  List<UImodel3> buyerUIModel = [];
  List<UImodel> lotNumberUIModel = [];
  List<UImodel> packingUIModel = [];
  // List<UImodel2> plantingUIModel = [];
  List<UImodel> plantingUIModel = [];
  List<UImodel2> blockUIModel = [];

  List<ShipmentDetails> shipmentDetaillist = [];

  DropdownModel? blockSelect;
  DropdownModel? plantingSelect;

  String slctBuyer = "";
  String slctLotNo = "";
  String slctPacking = "", slcBlockName = "";
  String valBuyer = "";
  String valLotNo = "";
  String valPacking = "", valBlock = "";
  String slcPlanting = "", valPlanting = "";

  String product = "",
      productId = "",
      variety = "",
      varietyId = "",
      lotQty = "",
      stockID = "",
      totalShipmentQty = "",
      exportLicenseNo = "",
      shipementDestination = "",
      shipementDestinationCode = "",
      packingQty = "",
      bestBeforeDate = "",
      blockID = "",
      exporterName = "";
  String getDateValue = "";
  double initialQty = 0;
  double initialShipmentQty = 0;
  ZebraPrinter? zebraPrinter;
  TextEditingController PONumber = new TextEditingController();
  DateTime? selectedDateTime;


  bool farmLoaded = false;
  bool blockLoaded = false;
  bool afterPlantingDate = false;
  bool validDate = false;
  bool validOfflineUCR = false;
  bool validUCR = false;

  bool blockAdded = false;
  bool receipt = false;
  bool qrGenerator = false;
  bool home = true;
  bool plantingLoaded = false;
  List<ListWithDate> blockIDList = [];
  List<ListAdd> lotIDList = [];
  List<ListAdd> plantingIDList = [];
  bool _internetconnection = false;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  String uom="";

  FilePickerResult? result;
  List<DocumentsModel> docsModel = [];

  bool _progress = false;
  String _msjprogress = "";
  bool connected = false;

  List<DropdownMenuItem> printerItem = [];
  DropdownModel? printerSelect;
  String slctPrinter="";
  String valPrinter="";
  List<UImodel> printUIModel = [];

  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  List<PrintModel> printLists = [];

  Future<List<int>> testTicket() async {
    List<int> bytes = [];

    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    //bytes += generator.reset();


    /* //Using `ESC *`
    bytes += generator.image(image!);*/



    bytes.clear();

      bytes += generator.text(
          "Ke-HTS",styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          fontType: PosFontType.fontA
      ));

      bytes += generator.text(
          "Shipment URL",styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          fontType: PosFontType.fontA
      ));

      bytes += generator.text(
          "------------------------------------------------",styles: PosStyles(
        bold: true,
        align: PosAlign.center,
      ));

    final now = new DateTime.now();
    String txntime =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    printLists.clear();
    printLists.add(PrintModel("RECEIPT", ""));
    printLists.add(PrintModel("Shipment Date", shipmentDate));
    printLists.add(PrintModel("Packhouse", packHouseName));
    printLists.add(
        PrintModel("Export License Number", exportLicenseNo));
    printLists.add(PrintModel("Buyer", slctBuyer));
    printLists.add(PrintModel("UCR Kentrade", PONumber.text));
    printLists
        .add(PrintModel("Trace Code ", traceCode.toString()));
    printLists.add(PrintModel(
        "Total Shipment Qty(kg)", totalShipmentQty));
    printLists.add(PrintModel("Exporter Name", exporterName));
    printLists.add(PrintModel("Date and Time", txntime));

    printLists.add(PrintModel("CROP NAME DETAILS", ""));
    for (int i = 0; i < shipmentDetaillist.length; i++) {
      printLists
          .add(PrintModel("Item Number", (i + 1).toString()));
      printLists.add(PrintModel(
          "Lot Number", shipmentDetaillist[i].lotNo));
      printLists.add(PrintModel(
          "Block Name", shipmentDetaillist[i].blockName));
      printLists.add(PrintModel(
          "Planting ID", shipmentDetaillist[i].plantingID));
      printLists.add(PrintModel(
          "Crop Name", shipmentDetaillist[i].product));
      printLists.add(PrintModel(
          "Variety", shipmentDetaillist[i].variety));
      printLists.add(PrintModel("Packing Quantity (Kg)",
          shipmentDetaillist[i].packingQty));
      printLists.add(PrintModel(
          "Packing Unit", shipmentDetaillist[i].packingUnit));
      printLists
          .add(PrintModel("----------", "***---------"));
    }

    int nocopy = 1;
    int lines = 8;
    int emptylines = lines - printLists.length;

    String printingcontent = '';
    //printingcontent = '        ' + appDatas.appname;
    printingcontent = printingcontent + '\n ';
    printingcontent = printingcontent + '\n ';
    for (int i = 0; i < printLists.length; i++) {
      printingcontent = printingcontent +
          '\n ' +
          printLists[i].name +
          " : " +
          printLists[i].value;
    }

    print("printingcontents:"+printingcontent);

    bytes += generator.text(
        printingcontent,styles: PosStyles(
        bold: true
    ));
    setState(() {
      receipt = true;
      home = false;
    });











    //bytes += generator.feed(2);
    //bytes += generator.cut();
    bytes +=generator.emptyLines(3);
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      /*bool result = await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: int.parse(_selectSize), text: text));*/
      /* final bytes = File('images/qr.png').readAsBytesSync();
      bool result = await PrintBluetoothThermal.writeBytes(bytes);*/
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("status print result: $result");
      setState(() {

      });
    } else {
      //no conectado, reconecte
      setState(() {

      });
      print("no conectado");
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
            Navigator.pop(context);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
    getClientData();
    //zebraprinterinti();
    initConnectivity();
    //New
    //farmerTraceCode = farmerId.toString();

    PONumber.addListener(() {
      final now = new DateTime.now();
      String msgNo = DateFormat('ddMMyyHHmm').format(now);
      setState(() {
        if (PONumber.text.length > 0) {
          String code = exporterName +
              "_" +
              exportLicenseNo +
              "_" +
              PONumber.text.toString() +
              "_" +
              msgNo.toString();
          traceCode = code;
        }
      });
    });

    List printerList = [
      {"property_value": "Zebra Printer", "DISP_SEQ": "0"},
      {"property_value": "Bixolon Printer", "DISP_SEQ": "1"},
    ];
    printerItem = [];
    printUIModel=[];

    for (int i = 0; i < printerList.length; i++) {
      String regStatName = printerList[i]["property_value"].toString();
      String regStatCode = printerList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(regStatName, regStatCode);
      printUIModel.add(uimodel);

      setState(() {
        printerItem.add(DropdownMenuItem(
          child: Text(regStatName),
          value: regStatName,
        ));
      });
    }
  }

  Future<void> connect() async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    try{
      //0000FE79-0000-1000-8000-00805F9B34FB
      final bool result =
      await PrintBluetoothThermal.connect(macPrinterAddress: "40:19:20:5B:A2:BB");
      print("state conected $result");
      if (result) connected = true;
      setState(() {
        _progress = false;
        printerConnected = true;
      });
    }catch(e){
      print("printer connection status:$e");
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

  Future<void> zebraprinterinti() async {
    print('zebraPrinterConnct---' +zebraPrinter.toString());

    //try {
    zebraPrinter = await Zebrautility.getPrinterInstance(
        onPrinterFound: (name, ipAddress, isWifiPrinter) {
          // toast("PrinterFound :" + name +'\n'+ ipAddress+'\n'+isWifiPrinter.toString());
          // print("ipAddress :" + ipAddress);

          print('zebraPrinterConnct' +zebraPrinter.toString());
          connectPrinter(ipAddress);
        },
        onDiscoveryError: onDiscoveryError,
        onPrinterDiscoveryDone: onPrinterDiscoveryDone,
        onChangePrinterStatus: onChangePrinterStatus,
        onPermissionDenied: onPermissionDenied);

    zebraPrinter!.discoveryPrinters();
    // } catch (e) {
    //
    //   // toast(e.toString());
    // }

    //connectPrinter('A4:DA:32:86:33:A6');
  }

  connectPrinter(String ip) {
// String printerstatus =zebraPrinter.isPrinterConnected();
// print("printerstatus "+printerstatus);
    zebraPrinter!.connectToPrinter(ip);

    setState(() {
      printerConnected = true;
    });
  }

  Function onPrinterFound = (name, ipAddress, isWifiPrinter) {
    // toast("PrinterFound :" + name + ipAddress);
    print("ipAddress :" + ipAddress);
  };
  Function onPrinterDiscoveryDone = () {
    // toast("Discovery Done");
  };
  Function(int errorCode, String errorText)? onDiscoveryError =
      (errorCode, errorText) {
    // toast("Discovery Error "+errorCode+ ' '+errorText);
  };
  Function(String status, String color)? onChangePrinterStatus =
      (status, color) {
    print("change printer status: " + status + color);
  };
  Function onPermissionDenied = () {
    // toast("Permission Deny.");
  };
  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    packHouseName = agents[0]['packHouseName'];
    packHouseID = agents[0]['packHouseId'];
    exportLicenseNo = agents[0]['exportLic'];
    exporterName = agents[0]['exporterName'];
    exporterId = agents[0]["exporterId"].toString();
    shipmentURL = agents[0]["effectiveFrom"].toString();
  }

  Future<void> initValue() async {
    String qryBuyer = 'select distinct buyrId,buyrName,buyersCountry,buyerCountryCode from buyerList';
    List buyerList = await db.RawQuery(qryBuyer);

    buyerDropDownLists = [];
    buyerUIModel = [];
    buyerDropDownLists.clear();

    for (int i = 0; i < buyerList.length; i++) {
      String buyrName = buyerList[i]["buyrName"].toString();
      String buyrId = buyerList[i]["buyrId"].toString();
      String buyersCountry = buyerList[i]["buyersCountry"].toString();
      String buyersCountryCode = buyerList[i]["buyerCountryCode"].toString();
      var uimodel = new UImodel3(buyrName, buyrId ,buyersCountry,buyersCountryCode);
      buyerUIModel.add(uimodel);
      setState(() {
        buyerDropDownLists.add(DropdownMenuItem(
          child: Text(buyrName),
          value: buyrName,
        ));
      });
    }

    String qryPackingQty =
        'select distinct  * from animalCatalog where catalog_code = \'82\'';
    List packingList = await db.RawQuery(qryPackingQty);

    packingUnitDropDownLists = [];
    packingUIModel = [];
    packingUnitDropDownLists.clear();

    for (int i = 0; i < packingList.length; i++) {
      String propertyValue = packingList[i]["property_value"].toString();
      String dispSEQ = packingList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);
      packingUIModel.add(uimodel);
      setState(() {
        packingUnitDropDownLists.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
    // check already number Exist
    List consignMentList =
    await db.RawQuery('select distinct consNo from shipment');
    consignmentData.clear();
    for (int i = 0; i < consignMentList.length; i++) {
      String consNo = consignMentList[i]["consNo"].toString();
      var number = new ShipmentConsignment(consNo);
      consignmentData.add(number);
    }
  }

  void ucrAPICall(String ucrNumber) async {
    if (_internetconnection) {
      setState(() {
        validOfflineUCR = false;
      });
      if (ucrNumber.isNotEmpty) {
        try {
          print("URL_URL---" + ucrNumber.toString());
          String deapkshipmentUCRUrl = await SecureStorage().decryptAES(appDatas.shipmentUCRUrl);

          String URL = deapkshipmentUCRUrl + ucrNumber;
          print("URL_URL" + URL.toString());
          Response response = await Dio().get(URL);
          print("response" + response.toString());
          Map<String, dynamic> json = jsonDecode(response.toString());
          printWrapped("CHECKRESPONSE " + response.toString());

          final code = json['code'];
          final status = json['status'];
          final message = json['msg'];

          alertPopup(context, message.toString());

          if (code.toString() == '300') {
            setState(() {
              validUCR = true;
            });
          } else {
            setState(() {
              validUCR = false;
              PONumber.text = "";
            });
          }
        } catch (e) {
          offlineUCRValidation();
        }
      }
    } else {
      alertPopup(context, "Please Check Your Internet Connection");
      // isLoading = false;
      // offlineUCRValidation();
    }
  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select distinct plantingId from villageWarehouse where stockType=3 and blockId=\'' +
            blockID +
            '\' and lastHarDate<=\'' +
            labelshipmentDate +
            '\'';

    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    print("plantingListvalue" + plantingIDList.toString());
    plantingUIModel = [];
    plantingItems = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["plantingId"].toString();
      var uiModel = UImodel(plantingID, plantingID);
      plantingUIModel.add(uiModel);
      setState(() {
        plantingItems.add(DropdownModel(
          plantingID,
          plantingID,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (plantingIDList.isNotEmpty) {
          plantingLoaded = true;
        }
      });
    });
  }

  Future<void> lotNumber() async {
    String qryLotNo =
        'select distinct batchNo from villageWarehouse where stockType =3 AND batchNo != "" and  lastHarDate<=\'' +
            labelshipmentDate +
            '\'';
    List lotList = await db.RawQuery(qryLotNo);
    print("lotList_lotList" + lotList.toString());
    print("qryLotNo_qryLotNo" + qryLotNo.toString());

    lotNumberDropDownLists = [];
    lotNumberUIModel = [];
    lotNumberDropDownLists.clear();
    lotIDList.clear();
    for (int i = 0; i < lotList.length; i++) {
      String propertyValue = lotList[i]["batchNo"].toString();
      String dispSEQ = lotList[i]["batchNo"].toString();

      var lotDetail = new ListAdd(dispSEQ, propertyValue);
      lotIDList.add(lotDetail);
    }
    for (int i = 0; i < lotIDList.length; i++) {
      String propertyValue = lotIDList[i].name;
      String dispSEQ = lotIDList[i].value;
      var uimodel = new UImodel(propertyValue, dispSEQ);
      lotNumberUIModel.add(uimodel);
      setState(() {
        lotNumberDropDownLists.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  Future<void> blockName(String batchNumber) async {
    String qryBlock =
        'select distinct blockId,blockName,batchNo, lastHarDate from villageWarehouse where blockName!="" and stockType =3 and batchNo=\'' +
            batchNumber +
            '\' and lastHarDate<=\'' +
            labelshipmentDate +
            '\'';
    print("qryBlock" + qryBlock);
    List blockList = await db.RawQuery(qryBlock);
    print("blockList" + blockList.toString());

    blockDropDownList = [];
    blockUIModel = [];
    blockDropDownList.clear();
    blockIDList.clear();

    for (int i = 0; i < blockList.length; i++) {
      String blockId = blockList[i]["blockId"].toString();
      String blockName = blockList[i]["blockName"].toString();
      String lastHarDate = blockList[i]["lastHarDate"].toString();

      var blockDetail = new ListWithDate(blockId, blockName, lastHarDate);
      blockIDList.add(blockDetail);
    }
    bool blockExist = false;
    String blockName = "", blockID = "", blockDte = "";
    for (int i = 0; i < blockIDList.length; i++) {
      blockName = blockIDList[i].name;
      blockID = blockIDList[i].value;
      var uimodel = new UImodel2(blockName, blockID, blockDte);
      blockUIModel.add(uimodel);
      setState(() {
        blockDropDownList.add(DropdownModel(
          blockName,
          blockID,
        ));
      });
    }
  }

  Future<void> blockDetail(String plantingId) async {
    String qryBlockDetail =
        'select distinct actWt,pCode,pName,vCode,vName,bestBeforeDate from villageWarehouse where stockType =3 and plantingId=\'' +
            plantingId +
            '\' and batchNo =\'' +
            valLotNo +
            '\' and lastHarDate<=\'' +
            labelshipmentDate +
            '\'';
    print("qryBlockDetail" + qryBlockDetail.toString());
    List blockDetailList = await db.RawQuery(qryBlockDetail);
    print("batchDetailList" + blockDetailList.toString());
    String productName = "", varietyName = "";
    List<DateTime> dates =[];
    for (int i = 0; i < blockDetailList.length; i++) {
      String pName = blockDetailList[i]["pName"].toString();
      String vName = blockDetailList[i]["vName"].toString();
      String actWt = blockDetailList[i]["actWt"].toString();
      String pCode = blockDetailList[i]["pCode"].toString();
      String vCode = blockDetailList[i]["vCode"].toString();
      List<String> bestBforeDate = blockDetailList[i]["bestBeforeDate"].split(',');
      print("actWt_actWt" + actWt.toString());
      print("bestBforeDate" + bestBforeDate.toString());

      String uomCode =
          'select hsCode from varietyList where vName =\'' +
              pName +
              '\'';

      print("uomCode" + uomCode.toString());

      List uomList = await db.RawQuery(uomCode);
      print("uomList" + uomList.toString());

      if(bestBforeDate.isNotEmpty){
        for(int i= 0 ; i < bestBforeDate.length ;i ++){
          dates.add(DateTime.parse(bestBforeDate[i].trim()));
        }
      }

      setState(() {
        product = pName;
        uom = uomList[0]['hsCode'];
        productId = pCode;
        variety = vName;
        varietyId = vCode;
        lotQty = actWt;
        packingQty = lotQty;
      });
    }
    if(dates.isNotEmpty){
      bestBeforeDate = calcMaxDate(dates).toString().split(' ')[0];
    }else{
      bestBeforeDate ='';
    }
    print('bestBeforeDate $bestBeforeDate');


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                },
              ),
              title: Text('Shipment',
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700)),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.green,
              brightness: Brightness.light,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(10.0),
                      children: getListings(context),
                    ),
                    flex: 8,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];

    if (home) {
      listings
          .add(txt_label_mandatory("Shipment Date", Colors.black, 14.0, false));
      if (shipmentDetaillist.length == 0) {
        listings.add(selectDate(
            context1: context,
            slctdate: shipmentDate,
            onConfirm: (date) => setState(
                  () {
                shipmentDate = DateFormat('dd-MM-yyyy').format(date);
                labelshipmentDate = DateFormat('yyyy-MM-dd').format(date);
                shipmentDateDetail(date);
                selectedDateTime = date;
                blockLoaded = false;
                slcBlockName = "";
                blockSelect = null;
                product = "";
                variety = "";
                lotQty = "";
                bestBeforeDate ='';
                packingQty = "";
                blockID = "";
                blockDropDownList = [];
                valBlock = "";
                valLotNo = "";
                lotNumberDropDownLists = [];
                slctLotNo = "";
                valLotNo = "";
                lotNumber();
                blockNumber();

              },
            )));
      } else {
        listings.add(cardlable_dynamic(shipmentDate.toString()));
      }

      listings.add(txt_label_mandatory("Packhouse", Colors.black, 15.0, false));
      listings.add(cardlable_dynamic(packHouseName.toString()));

      listings.add(txt_label_mandatory(
          "Export License Number", Colors.black, 15.0, false));
      listings.add(cardlable_dynamic(exportLicenseNo.toString()));

      listings.add(txt_label_mandatory("Buyer", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: buyerDropDownLists,
        selecteditem: slctBuyer,
        hint: "Select Buyer",
        onChanged: (value) {
          setState(() {
            slctBuyer = value!;
            for (int i = 0; i < buyerUIModel.length; i++) {
              if (value == buyerUIModel[i].name) {
                valBuyer = buyerUIModel[i].value;
                shipementDestination = buyerUIModel[i].value2;
                shipementDestinationCode = buyerUIModel[i].value3;
              }
            }
          });
        },
      ));
      listings.add(txt_label(
          "Shipment Destination", Colors.black, 15.0, false));
      listings.add(cardlable_dynamic(shipementDestination.toString()));

      listings.add(txt_label_mandatory("UCR Kentrade", Colors.black, 14.0, false));
      if (_internetconnection) {
        listings.add(validUCR
            ? txtfield_dynamic("UCR Kentrade", PONumber, false, 50)
            : Container());
        listings.add(!validUCR
            ? txtfield_dynamic("UCR Kentrade", PONumber, true, 50)
            : Container());
      } else {
        listings.add(validOfflineUCR
            ? txtfield_dynamic("UCR Kentrade", PONumber, true, 50)
            : Container());
        listings.add(!validOfflineUCR
            ? txtfield_dynamic("UCR Kentrade", PONumber, true, 50)
            : Container());
      }

      if (PONumber.text.isNotEmpty) {
        listings.add(btn_dynamic(
            label: "Verify",
            bgcolor: Colors.green,
            txtcolor: Colors.white,
            fontsize: 18.0,
            centerRight: Alignment.centerRight,
            margin: 10.0,
            btnSubmit: () async {
              initConnectivity();
              ucrAPICall(PONumber.text.toString());
            }));
      }

      listings
          .add(txt_label_mandatory("Trace Code", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(traceCode.toString()));

      listings
          .add(txt_label_mandatory("Lot Number", Colors.black, 14.0, false));

      listings.add(singlesearchDropdown(
        itemlist: lotNumberDropDownLists,
        selecteditem: slctLotNo,
        hint: "Select Lot Number",
        onChanged: (value) {
          setState(() {
            slctLotNo = value!;
            blockLoaded = false;
            slcBlockName = "";
            blockSelect = null;
            product = "";
            variety = "";
            lotQty = "";
            bestBeforeDate ='';
            packingQty = "";
            blockID = "";
            blockDropDownList = [];
            valBlock = "";
            valLotNo = "";
            plantingLoaded = false;
            plantingItems = [];
            slcPlanting = "";
            valPlanting = "";
            plantingSelect = null;
            for (int i = 0; i < lotNumberUIModel.length; i++) {
              if (value == lotNumberUIModel[i].name) {
                valLotNo = lotNumberUIModel[i].value;
                blockName(valLotNo);
              }
            }
          });
        },
      ));

      listings.add(btn_dynamic(
          label: "Scan",
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            if(Platform.isIOS){
              String packingValue = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => QrScanner()));
              print("packingValue " + packingValue.toString());
              getPackingDetail(packingValue);

              setState(() {
                slcValue = packingValue;
              });
            }else{
              String packingValue = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => QrScannerAndroid()));
              print("packingValue " + packingValue.toString());
              getPackingDetail(packingValue);

              setState(() {
                slcValue = packingValue;
              });
            }

          }));

      listings
          .add(txt_label_mandatory("Block Name", Colors.black, 14.0, false));

      listings.add(DropDownWithModel(
        itemlist: blockDropDownList,
        selecteditem: blockSelect,
        hint: "Select block name",
        onChanged: (value) {
          setState(() {
            blockSelect = value!;
            product = "";
            variety = "";
            lotQty = "";
            bestBeforeDate ='';
            packingQty = "";
            slcBlockName = blockSelect!.name;
            valBlock = blockSelect!.value;
            blockID = valBlock;
            plantingLoaded = false;
            plantingItems = [];
            slcPlanting = "";
            valPlanting = "";
            plantingSelect = null;
            plantingIdSearch(valBlock);
          });
        },
      ));

      listings.add(txt_label_mandatory("Block Id", Colors.black, 15.0, false));
      listings.add(cardlable_dynamic(blockID.toString()));

      listings
          .add(txt_label_mandatory("Planting ID", Colors.black, 14.0, false));
      listings.add(DropDownWithModel(
        itemlist: plantingItems,
        selecteditem: plantingSelect,
        hint: "Select Planting ID",
        onChanged: (value) {
          setState(() {
            plantingSelect = value!;
            product = "";
            variety = "";
            lotQty = "";
            bestBeforeDate ='';
            packingQty = "";
            valPlanting = plantingSelect!.value;
            slcPlanting = plantingSelect!.name;
            blockDetail(valPlanting);
            // shipmentDateDetail(selectedDateTime!);
            /*  for (int i = 0; i < plantingUIModel.length; i++) {
              if (valPlanting == plantingUIModel[i].value) {
                getDateValue = plantingUIModel[i].value2;
              }
            }*/
          });
        },
      ));

      listings.add(txt_label_mandatory("Crop Name ($uom)", Colors.black, 15.0, false));
      listings.add(cardlable_dynamic(product.toString()));

      listings.add(txt_label_mandatory("Variety", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(variety.toString()));

      listings.add(
          txt_label_mandatory("Lot Quantity (Kg)", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(lotQty.toString()));

      listings.add(
          txt_label("Best before date", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(bestBeforeDate.toString()));

      listings
          .add(txt_label_mandatory("Packing Unit", Colors.black, 14.0, false));

      listings.add(singlesearchDropdown(
        itemlist: packingUnitDropDownLists,
        selecteditem: slctPacking,
        hint: "Select Packing Unit",
        onChanged: (value) {
          setState(() {
            slctPacking = value!;
            for (int i = 0; i < packingUIModel.length; i++) {
              if (value == packingUIModel[i].name) {
                valPacking = packingUIModel[i].value;
              }
            }
          });
        },
      ));

      listings.add(txt_label_mandatory(
          "Packing Quantity (Kg)", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(packingQty.toString()));

      listings.add(btn_dynamic(
          label: "Add",
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () {
            bool blockAdded = false;

            if (shipmentDetaillist.length > 0) {
              for (int i = 0; i < shipmentDetaillist.length; i++) {
                if (valBlock == shipmentDetaillist[i].blockID) {
                  if (valLotNo == shipmentDetaillist[i].lotNo) {
                    if (valPlanting == shipmentDetaillist[i].plantingID) {
                      setState(() {
                        blockAdded = true;
                      });
                    }
                  }
                }
              }
            }

            if (slctLotNo.length == 0) {
              alertPopup(context, "Lot number should not be empty");
            } else if (slcBlockName.length == 0) {
              alertPopup(context, "Block Name  should not be empty");
            } else if (slcPlanting.length == 0) {
              alertPopup(context, "Planting ID should not be empty");
            } else if (slctPacking.length == 0) {
              alertPopup(context, "Packing Unit should not be empty");
            } else if (blockAdded) {
              alertPopup(
                  context, "Planting ID already exists for this Lot Number");
            } else {
              if(bestBeforeDate!.isNotEmpty){
                var difference = DateTime.parse(labelshipmentDate).difference(DateTime.parse(bestBeforeDate)).inDays ;
                print('difference $difference');
                if(difference <= 0){
                  setState(() {
                    var shipmentDetail = new ShipmentDetails(
                        valLotNo,
                        product,
                        productId,
                        variety,
                        varietyId,
                        lotQty,
                        slctPacking,
                        valPacking,
                        packingQty,
                        slcBlockName,
                        valBlock,
                        valPlanting);
                    shipmentDetaillist.add(shipmentDetail);

                    for (int i = 0; i < shipmentDetaillist.length; i++) {
                      double getTotalShipment =
                      double.parse(shipmentDetaillist[i].packingQty);
                      initialShipmentQty = getTotalShipment + initialShipmentQty;
                      String totalVal = initialShipmentQty.toString();
                      setState(() {
                        totalShipmentQty = totalVal;
                      });
                    }

                    slctLotNo = "";
                    slcBlockName = "";
                    blockSelect = null;
                    slctPacking = "";
                    product = "";
                    variety = "";
                    lotQty = "";
                    packingQty = "";
                    bestBeforeDate ='';
                    initialShipmentQty = 0.0;
                    blockID = "";
                    blockDropDownList = [];
                    plantingLoaded = false;
                    plantingItems = [];
                    slcPlanting = "";
                    valPlanting = "";
                    plantingSelect = null;
                  });
                }else{
                  alertPopup(
                      context, "Shipment date should not exceed Best before date");
                }
              }else{
                setState(() {
                  var shipmentDetail = new ShipmentDetails(
                      valLotNo,
                      product,
                      productId,
                      variety,
                      varietyId,
                      lotQty,
                      slctPacking,
                      valPacking,
                      packingQty,
                      slcBlockName,
                      valBlock,
                      valPlanting);
                  shipmentDetaillist.add(shipmentDetail);

                  for (int i = 0; i < shipmentDetaillist.length; i++) {
                    double getTotalShipment =
                    double.parse(shipmentDetaillist[i].packingQty);
                    initialShipmentQty = getTotalShipment + initialShipmentQty;
                    String totalVal = initialShipmentQty.toString();
                    setState(() {
                      totalShipmentQty = totalVal;
                    });
                  }

                  slctLotNo = "";
                  slcBlockName = "";
                  blockSelect = null;
                  slctPacking = "";
                  product = "";
                  variety = "";
                  lotQty = "";
                  packingQty = "";
                  bestBeforeDate ='';
                  initialShipmentQty = 0.0;
                  blockID = "";
                  blockDropDownList = [];
                  plantingLoaded = false;
                  plantingItems = [];
                  slcPlanting = "";
                  valPlanting = "";
                  plantingSelect = null;
                });
              }

            }

          }));

      if (shipmentDetaillist.length > 0) {
        listings.add(DatatableProductDetails());
      }

      listings.add(txt_label_mandatory(
          "Total Shipment Quantity (Kg)", Colors.black, 14.0, false));
      listings.add(cardlable_dynamic(totalShipmentQty.toString()));

      listings.add(txt_label(
          "Shipment Supporting Files", Colors.black, 14.0, false));
      listings.add(
          file_pickerDemo(
              label: "Shipment Supporting Files \*",
              onPressed: getDocument,
              result: docsModel

          )
      );

      listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    'Cancel',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    _onBackPressed();
                  },
                  color: Colors.redAccent,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    'Submit',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    btnSubmit();
                  },
                  color: Colors.green,
                ),
              ),
            ),
            //
          ],
        ),
      ));
    }
    /* else if (receipt) {
      listings.add(
        Text(
          "                                             Receipt                       ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      */ /* listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: txt_label("\nShipment Date                                "+"\n\nPackhouse"+"\n\nExport License Number"+"\n\nBuyer"+"\n\nProduce Consignment Number"+"\n\nTotal Shipment Quantity(Kg)" ,
                    Colors.black,
                    16.0,
                    false),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                //alignment: Alignment,
                padding: EdgeInsets.all(6),

                  child: txt_label(": " +shipmentDate+"\n\n: " +"packHouseName.toString()"+"\n\n: " +"exportLicenseNo.toString()"+"\n\n: " +slctBuyer+"\n\n: " +"PONumber.text"+"\n\n: " +totalShipmentQty.toString(),
                      Colors.black,
                      16.0,
                      false),

            ),
            )
            //
          ],
        ),
      )); */ /*

      listings.add(txt_label(
          "\nShipment Date                     : " + shipmentDate,
          Colors.black,
          16.0,
          false));

      listings.add(txt_label(
          "Packhouse                           : " + packHouseName.toString(),
          Colors.black,
          16.0,
          false));

      listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(2),
                child: txt_label("Export License No              : ",
                    Colors.black, 16.0, false),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                //alignment: Alignment,
                padding: EdgeInsets.all(2),

                child: txt_label(
                    exportLicenseNo.toString(), Colors.black, 16.0, false),
              ),
            )
            //
          ],
        ),
      ));

      */ /*listings.add(txt_label(
          "Export License No              : " +
              exportLicenseNo.toString(),
          Colors.black,
          16.0,
          false)); */ /*

      listings.add(txt_label(
          "Buyer                                     : " + slctBuyer,
          Colors.black,
          16.0,
          false));

      listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(2),
                child: txt_label("UCR Kentrade : ", Colors.black, 16.0, false),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                //alignment: Alignment,
                padding: EdgeInsets.all(2),

                child: txt_label(PONumber.text, Colors.black, 16.0, false),
              ),
            )
            //
          ],
        ),
      ));

      */ /*listings.add(txt_label("Produce Consignment No : " + "eatswesdgsdgtgfsPONumber.text",
          Colors.black, 16.0, false)); */ /*

      listings.add(txt_label(
          "Total shipment Qty(Kg)      : " + totalShipmentQty.toString(),
          Colors.black,
          16.0,
          false));

      listings.add(
        Text(
          " \n                                     Product Details                       ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      for (int i = 0; i < shipmentDetaillist.length; i++) {
        int number = i + 1;

        listings.add(
          Text(
            "\n\nItem Number  " + number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );

        */ /*  listings.add(txt_label("\nItem Number  " + number.toString(),
            Colors.blueGrey, 16.0, false)); */ /*

        listings.add(Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(1),
                  child: txt_label("\nLot Number                       -",
                      Colors.black, 16.0, false),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  //alignment: Alignment,
                  padding: EdgeInsets.all(2),

                  child: txt_label("\n" + shipmentDetaillist[i].lotNo,
                      Colors.black, 16.0, false),
                ),
              )
              //
            ],
          ),
        ));

        */ /* listings.add(txt_label(
            "\nLot Number                   - " + shipmentDetaillist[i].lotNo,
            Colors.black,
            16.0,
            false)); */ /*

        listings.add(txt_label(
            "Block Name                       - " +
                shipmentDetaillist[i].blockName,
            Colors.black,
            16.0,
            false));

        listings.add(txt_label(
            "Product                               - " +
                shipmentDetaillist[i].product,
            Colors.black,
            16.0,
            false));

        listings.add(txt_label(
            "Variety                                 - " +
                shipmentDetaillist[i].variety,
            Colors.black,
            16.0,
            false));

        //listings.add(txt_label("Packing Unit            - "+ shipmentDetaillist[i].packingUnit, Colors.black, 16.0, false));

        listings.add(txt_label(
            "Packing Quantity (Kg)       - " + shipmentDetaillist[i].packingQty,
            Colors.black,
            16.0,
            false));
        listings.add(txt_label(
            "Packing Unit                       - " +
                shipmentDetaillist[i].packingUnit,
            Colors.black,
            16.0,
            false));
      }

      listings.add(Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    'Print',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    // Uint8List img = await toQrImageData(qrtext);
                    // var bs64 = base64Encode(img);
                    //
                    // zebraPrinter!.printImage(bs64.toString(), "");
                    List<PrintModel> printLists = [];
                    for (int i = 0; i < shipmentDetaillist.length; i++) {
                      printLists.add(PrintModel("S.No", i.toString()));
                      printLists.add(PrintModel(
                          "Block Name", shipmentDetaillist[i].blockName));
                      printLists.add(
                          PrintModel("Product", shipmentDetaillist[i].product));
                      printLists.add(
                          PrintModel("Variety", shipmentDetaillist[i].variety));
                      printLists.add(PrintModel("Packing Quantity (Kg)",
                          shipmentDetaillist[i].packingQty));
                      printLists.add(PrintModel(
                          "Packing Unit", shipmentDetaillist[i].packingUnit));
                      printLists.add(PrintModel("----------", "***---------"));
                    }

                    int nocopy = 1;
                    int lines = 8;
                    int emptylines = lines - printLists.length;

                    String printingcontent = '';
                    printingcontent = '        ' + appDatas.appname;
                    printingcontent = printingcontent + '\r ';
                    printingcontent = printingcontent + '\r ';
                    for (int i = 0; i < printLists.length; i++) {
                      printingcontent = printingcontent +
                          '\r ' +
                          printLists[i].name +
                          " : " +
                          printLists[i].value;
                    }

                    zebraPrinter!.print(printingcontent);
                    setState(() {
                      receipt = true;
                      home = false;
                    });
                    Navigator.pop(context);
                  },
                  color: Colors.redAccent,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    'Close',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    _onBackPressed();
                    */ /*  await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoard("", "")));*/ /*
                  },
                  color: Colors.green,
                ),
              ),
            ),
            //
          ],
        ),
      ));
    }*/
    else if (receipt) {
      listings.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Receipt",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ));

      listings.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "Shipment Date :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          shipmentDate.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "PackHouse:",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          packHouseName.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "Export License Number :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          exportLicenseNo.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "Buyer :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          slctBuyer.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "Shipment Destination :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          shipementDestination.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "UCR Kentrade :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          PONumber.text.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          "Trace Code :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        child: Text(
                          traceCode.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Total Shipment Qty(kg) :",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        totalShipmentQty.toString(),
                        style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
      listings.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Crop Name Details",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ));

      for (int i = 0; i < shipmentDetaillist.length; i++) {
        int number = i + 1;
        listings.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 18),
          child: Text(
            "Item Number" + "" + number.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ));

        listings.add(Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Lot Number :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].lotNo.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Block Name :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].blockName.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Planting ID :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].plantingID.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Crop Name :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].product.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Variety :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].variety.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Packing Quantity (Kg) :",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text(
                            shipmentDetaillist[i].packingQty.toString(),
                            style: TextStyle(fontSize: 16.0, color: Colors.black87),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Packing Unit :",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          shipmentDetaillist[i].packingUnit.toString(),
                          style:
                          TextStyle(fontSize: 16.0, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

        listings.add( Expanded(
          child:
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                    child: txt_label_mandatory("Select a printer", Colors.black, 14.0, false)),
                Expanded(
                  flex: 2,
                    child:singlesearchDropdown(
                  itemlist: printerItem,
                  selecteditem: slctPrinter,
                  hint: "Select Printer",
                  onChanged: (value) {
                    setState(() {
                      slctPrinter = value!;
                      for (int i = 0; i < printUIModel.length; i++) {
                        if (value == printUIModel[i].name) {
                          valPrinter = printUIModel[i].value;
                        }
                      }
                    });
                  },
                ) /*DropDownWithModel(
                            itemlist: printerItem,
                            selecteditem: printerSelect,
                            hint: "Select a printer",
                            onChanged: (value) {
                              setState(() {
                                valPrinter = printerSelect!.value;
                                slctPrinter = printerSelect!.name;
                                print("valprintervalue:"+valPrinter);
                              });
                            },
                          )*/)
              ],
            ),
          ),
        ),);
      }
      listings.add(Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            /*zebra printer */
            valPrinter == "0"?Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    printerConnected ? 'Print' : 'Connect',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    // Uint8List img = await toQrImageData(qrtext);
                    // var bs64 = base64Encode(img);
                    //
                    // zebraPrinter!.printImage(bs64.toString(), "");
                    if (printerConnected) {
                      EasyLoading.show(
                        status: 'Printing...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      final now = new DateTime.now();
                      String txntime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(now);


                      printLists.add(PrintModel("RECEIPT", ""));
                      printLists.add(PrintModel("Shipment Date", shipmentDate));
                      printLists.add(PrintModel("Packhouse", packHouseName));
                      printLists.add(
                          PrintModel("Export License Number", exportLicenseNo));
                      printLists.add(PrintModel("Buyer", slctBuyer));
                      printLists.add(PrintModel("UCR Kentrade", PONumber.text));
                      printLists
                          .add(PrintModel("Trace Code ", traceCode.toString()));
                      printLists.add(PrintModel(
                          "Total Shipment Qty(kg)", totalShipmentQty));
                      printLists.add(PrintModel("Exporter Name", exporterName));
                      printLists.add(PrintModel("Date and Time", txntime));

                      printLists.add(PrintModel("CROP NAME DETAILS", ""));
                      for (int i = 0; i < shipmentDetaillist.length; i++) {
                        printLists
                            .add(PrintModel("Item Number", (i + 1).toString()));
                        printLists.add(PrintModel(
                            "Lot Number", shipmentDetaillist[i].lotNo));
                        printLists.add(PrintModel(
                            "Block Name", shipmentDetaillist[i].blockName));
                        printLists.add(PrintModel(
                            "Planting ID", shipmentDetaillist[i].plantingID));
                        printLists.add(PrintModel(
                            "Crop Name", shipmentDetaillist[i].product));
                        printLists.add(PrintModel(
                            "Variety", shipmentDetaillist[i].variety));
                        printLists.add(PrintModel("Packing Quantity (Kg)",
                            shipmentDetaillist[i].packingQty));
                        printLists.add(PrintModel(
                            "Packing Unit", shipmentDetaillist[i].packingUnit));
                        printLists
                            .add(PrintModel("----------", "***---------"));
                      }

                      int nocopy = 1;
                      int lines = 8;
                      int emptylines = lines - printLists.length;

                      String printingcontent = '';
                      printingcontent = '        ' + appDatas.appname;
                      printingcontent = printingcontent + '\r ';
                      printingcontent = printingcontent + '\r ';
                      for (int i = 0; i < printLists.length; i++) {
                        printingcontent = printingcontent +
                            '\r ' +
                            printLists[i].name +
                            " : " +
                            printLists[i].value;
                      }

                      zebraPrinter!.print(printingcontent);
                      setState(() {
                        receipt = true;
                        home = false;
                      });

                      Future.delayed(Duration(milliseconds: 10000), () {
                        EasyLoading.dismiss();
                        zebraPrinter!.disconnect();
                        Navigator.pop(context);
                      });
                    } else {
                      zebraprinterinti();
                    }
                  },
                  color: printerConnected ? Colors.redAccent : Colors.orange,
                ),
              ),
            ):Container(),
            /*bixolon printer*/
            valPrinter == "1"?Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        width: 50,
                        child: RaisedButton(
                          child: Text(
                            printerConnected ? 'Print' : 'Connect',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async {

                            if (printerConnected) {

                              await printWithoutPackage();

                            } else {
                              connect();
                            }


                          },
                          color: printerConnected
                              ? Colors.redAccent
                              : Colors.orange,
                        ),
                      ),
                    ),

                    //
                  ],
                ),
              ),
            ):Container(),

            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3),
                child: RaisedButton(
                  child: Text(
                    'Show QR',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    if (Qrvalue.isNotEmpty) {
                      List<PrintModel> printLists = [];
                      String url = Qrvalue;
                      printLists.add(PrintModel("Shipment URL", url));
                      List<MultiplePrintModel> multipleprintLists = [];
                      multipleprintLists
                          .add(MultiplePrintModel(printLists, Qrvalue));
                      qrGenerator = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrReader(
                                  multipleprintLists, 'Shipment URL','')));
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
                    'Close',
                    style: new TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    _onBackPressed();
                  },
                  color: Colors.green,
                ),
              ),
            ),
            //
          ],
        ),
      ));
    }

    return listings;
  }

  void btnSubmit() {
    initConnectivity();
    if (shipmentDate.length == 0) {
      alertPopup(context, "Shipment date should not be empty");
    } else if (exportLicenseNo.length == 0) {
      alertPopup(context, "Export License Number should not be empty");
    }
    else if (slctBuyer.length == 0) {
      alertPopup(context, "Buyer should not be empty");
    }
    else if (PONumber.value.text.length == 0) {
      alertPopup(context, "UCR Kentrade should not be empty");
    } else {
      validationNumber();
    }
  }

  void offlineUCRValidation() {
    setState(() {
      validUCR = false;
    });
    if (consignmentData.isNotEmpty) {
      for (int a = 0; a < consignmentData.length; a++) {
        print("forrloop");
        if (consignmentData[a].consNo == PONumber.text) {
          setState(() {
            validOfflineUCR = false;
          });
          print("consignmentData[a].consNohhhhhsdds" +
              consignmentData[a].consNo.toString());
          print("PONumber.textddddd" + PONumber.text.toString());
        } else if (consignmentData[a].consNo != PONumber.text) {
          setState(() {
            validOfflineUCR = true;
          });

          print("consignmentDatajjjjj" + consignmentData[a].consNo.toString());
          print("PONumberkkkk" + PONumber.text.toString());
        }
      }
    } else {
      setState(() {
        validOfflineUCR = true;
      });
    }
  }

  void validationNumber() {
    if (!_internetconnection) {
      offlineUCRValidation();
    }

    print("_internetconnection" + _internetconnection.toString());

    if (!validUCR && _internetconnection) {
      alertPopup(context, "Please Verify UCR Kentrade");
    } else if (!validOfflineUCR && !_internetconnection) {
      alertPopup(context, "UCR Kentrade already Exist");
    } else if (shipmentDetaillist.isEmpty) {
      alertPopup(context, "Add Atleast one shipment");
    } else {
      confirmation();
    }
  }

  void confirmation() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Confirmation",
      desc: "Are you sure you want to proceed ?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            saveShipmentData();
            Navigator.pop(context);
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
    ).show();
  }

  Future<void> saveShipmentData() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    //print('txnHeader ' + agentid + "" + agentToken);
    Random rnd = new Random();
    int revNo = 100000 + rnd.nextInt(999999 - 100000);

    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
            '0,\'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\',\'' +
            agentid! +
            '\', \'' +
            agentToken! +
            '\',\'' +
            msgNo +
            '\', \'' +
            servicePointId +
            '\',\'' +
            revNo.toString() +
            '\')';

    int txnsucc = await db.RawInsert(insqry);
    print(txnsucc);

    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(
        txntime, appDatas.txnShipment, revNo.toString(), '', '', '');

    String shipDate = labelshipmentDate;
    String buyer = valBuyer;
    String consNo = PONumber.text;
    String totQty = totalShipmentQty;
    String recNo = revNo.toString();
    String isSynched = "1";
    String season = seasonCode;
    String traceCodeValue = traceCode;
    String destinationCode = shipementDestinationCode;
    String destination = shipementDestination;

    if(docsModel.isNotEmpty){
      for(int i =0 ; i<docsModel.length ; i++){
        String? docName =  docsModel[i].name;
        String? docPath =  docsModel[i].path;
        String recNo = revNo.toString();
        int shipmentDocs = await db.shipmentDocDetails(docName!, docPath ,recNo);

      }
    }

    int shipment = await db.Shipment(shipDate, packHouseID, exportLicenseNo,
        buyer, consNo, totQty, recNo, isSynched, "", season, traceCodeValue ,destination,destinationCode);

    print("shipment:" + shipment.toString());

    for (int i = 0; i < shipmentDetaillist.length; i++) {
      String lotNo = shipmentDetaillist[i].lotNo;
      String produce = shipmentDetaillist[i].productId;
      String variety = shipmentDetaillist[i].varietyId;
      String lotQty = shipmentDetaillist[i].lotQty;
      String packUnit = shipmentDetaillist[i].packingUnitValue;
      String packQty = shipmentDetaillist[i].packingQty;
      String blockId = shipmentDetaillist[i].blockID;
      String plantingId = shipmentDetaillist[i].plantingID;
      String recNo = revNo.toString();

      int shipmentDetails = await db.ShipmentDetail(lotNo, produce, variety,
          lotQty, packUnit, packQty, recNo, blockId, plantingId);

      print("shipmentdetails:" + shipmentDetails.toString());
    }

    db.UpdateTableValue(
        'shipment', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    if (PONumber.text.isNotEmpty && shipmentURL.isNotEmpty) {
      UCRValue = PONumber.text.toString();
      String getShipmentURL = shipmentURL + UCRValue;
      Qrvalue = getShipmentURL;
    }

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Shipment done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            setState(() {
              receipt = true;
              home = false;
            });

            Navigator.pop(context);
            /*     if (Qrvalue.isNotEmpty) {
              List<PrintModel> printLists = [];
              String url = Qrvalue;
              printLists.add(PrintModel("Shipment URL", url));
              List<MultiplePrintModel> multipleprintLists = [];
              multipleprintLists.add(MultiplePrintModel(printLists, Qrvalue));
              qrGenerator = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QrReader(multipleprintLists, 'Shipment URL')));
            }*/
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

  Future<void> blockValueCheck() async {
    bool block = false;
    bool blockExist = false;
    for (int i = 0; i < blockIDList.length; i++) {
      if (blockIDList[i].value == valBlock) {
        blockExist = true;
      }
    }
    if (!blockExist) {
      for (int i = 0; i < blockIDList.length; i++) {
        if (slcBlockName != "" && valBlock != "") {
          setState(() {
            block = true;
          });
        }
      }
    }
    if (blockIDList.length > 0) {
      if (block) {
        var getValue = new ListWithDate(valBlock, slcBlockName, getDateValue);
        blockIDList.add(getValue);

        var uimodel = new UImodel2(slcBlockName, valBlock, getDateValue);
        blockUIModel.add(uimodel);
        setState(() {
          blockDropDownList.add(DropdownModel(slcBlockName, valBlock));
        });
      }
    }
  }

  Future<void> plantingIDValueCheck() async {
    bool plantingId = false;
    bool plantingIdExist = false;
    for (int i = 0; i < plantingIDList.length; i++) {
      if (plantingIDList[i].value == valPlanting) {
        plantingIdExist = true;
      }
    }
    if (!plantingIdExist) {
      for (int i = 0; i < plantingIDList.length; i++) {
        if (slcPlanting != "" && valPlanting != "") {
          setState(() {
            plantingId = true;
          });
        }
      }
    }
    if (plantingIDList.isNotEmpty) {
      if (plantingId) {
        var getValue = ListAdd(valPlanting, slcPlanting);
        plantingIDList.add(getValue);

        // var uimodel = UImodel2(slcPlanting, valPlanting, getDateValue);
        var uimodel = UImodel(slcPlanting, valPlanting);
        plantingUIModel.add(uimodel);
        setState(() {
          plantingItems.add(DropdownModel(slcPlanting, valPlanting));
        });
      }
    }
  }

  Future<void> lotValueCheck() async {
    bool lotNumber = false;
    bool lotNumberExist = false;
    for (int i = 0; i < lotIDList.length; i++) {
      if (lotIDList[i].value == valLotNo) {
        lotNumberExist = true;
      }
    }
    if (!lotNumberExist) {
      for (int i = 0; i < lotIDList.length; i++) {
        if (slctLotNo != "" && valLotNo != "") {
          setState(() {
            lotNumber = true;
          });
        }
      }
    }
    if (lotIDList.length > 0) {
      if (lotNumber) {
        var getValue = new ListAdd(valLotNo, slctLotNo);
        lotIDList.add(getValue);

        var uimodel = new UImodel(
          slctLotNo,
          valLotNo,
        );
        lotNumberUIModel.add(uimodel);
        setState(() {
          lotNumberDropDownLists.add(DropdownMenuItem(
            child: Text(slctLotNo),
            value: slctLotNo,
          ));
        });
      }
    }
  }

  void shipmentDateDetail(DateTime shipmentDate) async {
    print("getDateValue_getDateValue" + getDateValue.toString());
    if (getDateValue != "") {
      String dateValue = getDateValue;
      String trimmedDate = dateValue.substring(0, 10);

      DateTime convertShipmentDate = shipmentDate;
      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertDate = new DateTime(strYear, strMonths, strDate);

      print("convertDate" + convertDate.toString());
      print("convertShipmentDate" + convertShipmentDate.toString());

      DateTime valEnd = convertShipmentDate;
      bool valDate = convertDate.isBefore(valEnd);
      bool sameDate = convertShipmentDate.isAtSameMomentAs(convertDate);
      if (valDate) {
        setState(() {
          validDate = true;
        });
      } else if (sameDate) {
        setState(() {
          validDate = true;
        });
      } else {
        setState(() {
          validDate = false;
        });
      }

      print("vvalidDate" + validDate.toString());
    }
  }

  Future<void> getPackingDetail(String sortingValue) async {
    try {
      List<String> splitList = sortingValue.split('~');
      print("splitList_splitList" + splitList.toString());
      print("splitList_length" + splitList.length.toString());
      String pCode = splitList[6].toString().trim();
      String uomCode =
          'select hsCode from varietyList where vName =\'' +
              pCode +
              '\'';

      print("uomCode" + uomCode.toString());

      List uomList = await db.RawQuery(uomCode);
      print("uomList" + uomList.toString());

      if (splitList.length == 21) {
        setState(() {
          slctLotNo = splitList[0].toString().trim();
          valLotNo = splitList[0].toString().trim();
          valBlock = splitList[3].toString().trim();
          uom = uomList[0]['hsCode'].toString();
          blockID = splitList[3].toString().trim();
          slcBlockName = splitList[4].toString().trim();
          productId = splitList[5].toString().trim();
          product = splitList[6].toString().trim();
          varietyId = splitList[7].toString().trim();
          variety = splitList[8].toString().trim();
          lotQty = splitList[9].toString().trim();
          packingQty = splitList[9].toString().trim();
          stockID = splitList[14].toString().trim();
          qrExporterId = splitList[15].toString().trim();
          getDateValue = splitList[16].toString().trim();
          qrPackHouseID = splitList[17].toString().trim();
          valPlanting = splitList[18].toString().trim();
          slcPlanting = splitList[18].toString().trim();
          bestBeforeDate = splitList[20].toString().trim();

          blockSelect = DropdownModel(slcBlockName, valBlock);
          plantingSelect = DropdownModel(slcPlanting, valPlanting);
        });
        if (shipmentDate.length > 0) {
          shipmentDateDetail(selectedDateTime!);
        }
        if (qrPackHouseID == packHouseID) {
          if (shipmentDate.length > 0) {
            if (validDate) {
              if (stockID == "3" && checkOrderList.contains(valLotNo)) {
                blockValueCheck();
                lotValueCheck();
                plantingIDValueCheck();
                blockName(valLotNo);
                plantingIdSearch(valBlock);
              } else {
                print("stockID_else" + stockID.toString());
                alertPopup(context, "Invalid QR code");
                clearData();
              }
            } else {
              alertPopup(context, "Invalid Shipment Date");
              clearData();
            }
          } else {
            alertPopup(context, "Select Shipment Date Before Scan");
            clearData();
          }
        } else {
          alertPopup(context,
              "The Crop Name belongs to another PackHouse so you are not allowed to scan");
          clearData();
        }
      } else {
        alertPopup(context, "Invalid QR code");
        clearData();
      }
    } catch (e) {
      alertPopup(context, "Invalid QR code");
      clearData();
      print("catchException" + e.toString());
    }
  }

  void clearData() {
    setState(() {
      product = "";
      variety = "";
      lotQty = "";
      slctLotNo = "";
      slcBlockName = "";
      blockSelect = null;
      blockID = "";
      packingQty = "";
      blockDropDownList = [];
      plantingItems = [];
      slcPlanting = "";
      valPlanting = "";
      plantingSelect = null;
    });
  }
  Widget file_pickerDemo({String? label, Function()? onPressed,List<DocumentsModel>? result, ondelete}) {
    Widget objWidget =
    Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.green,
                onPressed: onPressed,
                tooltip: 'Pick File',
                child: Icon(
                  Icons.attach_file,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10,),

            Center(
              child: result == null
                  ? Text('')
                  : ListView.builder(
                  shrinkWrap: true,
                  itemCount: result.length ,
                  itemBuilder: (BuildContext context ,int index){
                    return
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      decoration:BoxDecoration(
                                        color:Colors.blueGrey[200],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(result[index].name ?? '', style: const TextStyle(fontSize: 14)),
                                      ))),
                              VerticalDivider(width: 10.0),
                              Container(
                                child: result == null
                                    ? Text('')
                                    : Column(children: <Widget>[
                                  MaterialButton(
                                    color: Colors.red,
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if(result.isNotEmpty){
                                          result.removeAt(index);
                                        }
                                      });
                                    },
                                  ),
                                ]),
                              ),

                            ],
                          ),
                          SizedBox(height: 10,)
                        ],
                      );

                  }),
            ),

          ],
        ));
    return objWidget;
  }


  Widget DatatableProductDetails() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Lot Number')));
    columns.add(DataColumn(label: Text('Block Name')));
    columns.add(DataColumn(label: Text('Planting ID')));
    columns.add(DataColumn(label: Text('Crop Name Detail')));
    columns.add(DataColumn(label: Text('Packing Quantity (Kg)')));
    columns.add(DataColumn(label: Text('Packing Unit')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < shipmentDetaillist.length; i++) {
      String productDetail = shipmentDetaillist[i].product +
          "" +
          "/" +
          shipmentDetaillist[i].variety;

      String packingUnit = shipmentDetaillist[i].packingQty +
          "" +
          "(" +
          shipmentDetaillist[i].packingUnit +
          ")";
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(shipmentDetaillist[i].lotNo)));
      singlecell.add(DataCell(Text(shipmentDetaillist[i].blockName)));
      singlecell.add(DataCell(Text(shipmentDetaillist[i].plantingID)));
      singlecell.add(DataCell(Text(productDetail)));
      singlecell.add(DataCell(Text(shipmentDetaillist[i].packingQty)));
      singlecell.add(DataCell(Text(shipmentDetaillist[i].packingUnit)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            shipmentDetaillist.removeAt(i);
          });
          double initialShipmentQty = 0.0;
          if (shipmentDetaillist.length > 0) {
            for (int i = 0; i < shipmentDetaillist.length; i++) {
              double getTotalShipment = double.parse(shipmentDetaillist[i].packingQty);
              initialShipmentQty = getTotalShipment + initialShipmentQty;
              String totalVal = initialShipmentQty.toString();
              setState(() {
                totalShipmentQty = totalVal;
              });
              print("initialShipmentQty" + initialShipmentQty.toString());
              print("shipmentDetaillistpackingQty" +
                  shipmentDetaillist[i].packingQty.toString());
            }
          } else {
            totalShipmentQty = "0.0";
            initialShipmentQty = 0.0;
          }
        },
        child: Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
      )));
      rows.add(DataRow(
        cells: singlecell,
      ));
    }
    Widget objWidget = datatable_dynamic(columns: columns, rows: rows);
    return objWidget;
  }

  Future getDocument() async {
    print('docsModellength-' +docsModel.length.toString());

    if(docsModel.length >=3){
      alertPopup(context,"Shipment Supporting Files should not exceed more than three");
    }else{
      result = await FilePicker.platform.pickFiles(allowMultiple: true );
      if (result == null) {
        print("No file selected");
      } else {
        setState(() {
        });
        result?.files.forEach((element) {
          print(element.name);
        });
        int resultantVar = result!.files.length + docsModel.length;
        if(result!.files.length >3 || resultantVar>3){
          alertPopup(context,"Shipment Supporting Files should not exceed more than three");
        }else{
          for(int i =0 ;i<result!.files.length;i++){
            print(result!.files);
            docsModel.add(
                DocumentsModel(result!.files[i].name, result!.files[i].bytes.toString(),result!.files[i].path!)
            );

          }
        }
      }
    }


  }

  Future<void> blockNumber() async {
    checkOrderList.clear();
    String qryBlockNumber =
        'select distinct batchNo from villageWarehouse where  blockName!="" and  stockType=3 and lastHarDate<=\'' +
            labelshipmentDate +
            '\'';

    print("qryBlockNumber" + qryBlockNumber.toString());
    List blockNumberList = await db.RawQuery(qryBlockNumber);

    if(blockNumberList.isNotEmpty){
      for (int i = 0; i < blockNumberList.length; i++) {
        String propertyValue = blockNumberList[i]["batchNo"].toString();

        checkOrderList.add(propertyValue);
      }
    }
    print("checkOrderList" + checkOrderList.toString());


  }

  DateTime calcMaxDate(List<DateTime> bestBforeDate) {
    DateTime maxDate = bestBforeDate[0];
    bestBforeDate.forEach((date){
      if(date.isAfter(maxDate)){
        maxDate=date;
      }
    });
    return maxDate;
  }

}

class ShipmentDetails {
  String lotNo;
  String product;
  String productId;
  String variety;
  String varietyId;
  String lotQty;
  String packingUnit;
  String packingUnitValue;
  String packingQty;
  String blockName;
  String blockID;
  String plantingID;

  ShipmentDetails(
      this.lotNo,
      this.product,
      this.productId,
      this.variety,
      this.varietyId,
      this.lotQty,
      this.packingUnit,
      this.packingUnitValue,
      this.packingQty,
      this.blockName,
      this.blockID,
      this.plantingID);
}

class ShipmentConsignment {
  String? consNo;
  ShipmentConsignment(this.consNo);
}
class DocumentsModel {
  String? name;
  String? bytes;
  String path;

  DocumentsModel( this.name, this.bytes, this.path);
}

