import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Screens/qrcode.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/QRScannerAndroid.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/QrScanner.dart';
import '../Utils/secure_storage.dart';
import '../login.dart';

class PackingScreen extends StatefulWidget {
  const PackingScreen({Key? key}) : super(key: key);

  @override
  _PackingScreenState createState() => _PackingScreenState();
}

class _PackingScreenState extends State<PackingScreen> {
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';
  String selectedDate = "",
      formatDate = "",
      lotDate = "",
      bestBeforeDate = "",
      formatBestBeforeDate = "";
  String slcFarmer = "",
      slcFarm = "",
      valFarm = "",
      slcReception = "",
      slcBlockNumber = "",
      valFarmer = "",
      valReception = "",
      valBlockNumber = "",
      farmer = "",
      product = "",
      productId = "",
      variety = "",
      varietyId = "",
      availableQty = "",
      countyName = "",
      countyCode = "",
      packHouseName = "",
      packHouseID = "",
      packHouseCode = "",
      lotNumber = "",
      agentLotNumber = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String qrExportedID = "", qrPackHouseID = "";

  String Qrvalue = "";
  String slcValue = "";
  String getDateValue = "";
  String slcPlanting = "", valPlanting = "";
  int count = 0;

  var Qr = [];
  String stockID = "";
  String exporterID = "";

  bool farmLoaded = false, blockLoaded = false, receptionLoaded = false;
  bool validDate = false;
  bool plantingLoaded = false;
  bool afterPackingDate = false;
  bool existData=false;
  double packedQtyValue = 0.0;
  double availableQtyValue = 0.0;
  double rejectedQtyValue = 0.0;
  double currentQtyValue = 0.0;
  double priceValue = 0.0;

  List<DropdownModel> blockDropdown = [];
  List<DropdownModelFarmer> farmerDropdown = [];
  List<DropdownModel> farmDropdown = [];
  List<DropdownModel> plantingItems = [];
  List<DropdownMenuItem> receptionDropdown = [];
  List<PackingClass> packingList = [];
  List<PackingClass> packingQRList = [];

  List<UImodel3> farmerUiModel = [];
  List<UImodel> receptionUiModel = [];
  List<UImodel> blockUiModel = [];
  List<UImodel> farmUiModel = [];
  List<UImodel> plantingUIModel = [];

  List<ListAdd> farmIDList = [];
  List<ListAddFarmer> farmerIDList = [];
  List<ListAdd> blockIDList = [];
  List<ListAdd> plantingIDList = [];
//  List<ListWithDate> receptionIDList = [];
  List<ListAdd> receptionIDList = [];

  DropdownModelFarmer? farmerSelect;
  DropdownModel? blockSelect;
  DropdownModel? farmSelect;
  DateTime? selectedPackingDate;
  DateTime? selectedBestBeforeDate;
  DropdownModel? plantingSelect;

  TextEditingController packerNameController = TextEditingController();
  TextEditingController packedQTYController = TextEditingController();
  TextEditingController prodValController = TextEditingController();
  TextEditingController rejectedQTYController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<MultiplePrintModel> multipleprintLists = [];
  String exporterName = "";
  String qrIdGeneration="";
  int countQR=0;
  String idGeneration="";
  String uom="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFarmer();
    getClientData();
    getLocation();

    Random random = Random();
    int revNumber = 100000 + random.nextInt(999999 - 100000);
    qrIdGeneration=revNumber.toString();

    packedQTYController.addListener(() {
      setState(() {
        if (packedQTYController.text.isNotEmpty) {
          var qty = packedQTYController.text;
          double num1 = double.parse((qty));
          packedQtyValue = num1;
          if (availableQty.isNotEmpty) {
            double value = double.parse(availableQty);
            availableQtyValue = value;
          }
          if (priceController.text.isNotEmpty){
            double pckqty = double.parse(packedQTYController.text);
            double priceDbl = double.parse(priceController.text);
            double resultVal = pckqty * priceDbl;
            prodValController.text =  resultVal.toStringAsFixed(2);
          }
        }
      });
    });


    rejectedQTYController.addListener(() {
      setState(() {
        if (rejectedQTYController.text.isNotEmpty) {
          var qty = rejectedQTYController.text;
          double num1 = double.parse((qty));
          rejectedQtyValue = num1;
          if (availableQty.isNotEmpty) {
            double value = double.parse(availableQty);
            availableQtyValue = value;
            currentQtyValue = availableQtyValue - packedQtyValue;
          }
        }
      });
    });

    priceController.addListener(() {
      setState(() {
        if (priceController.text.isNotEmpty) {
          var price = priceController.text;
          double num1 = double.parse((price));
          priceValue = num1;
          if(packedQTYController.text.isNotEmpty){
            double pckqty = double.parse(packedQTYController.text);
            double priceDbl = double.parse(priceController.text);
            double resultVal = pckqty * priceDbl;
            prodValController.text =  resultVal.toStringAsFixed(2);
          }
        }
      });
    });
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    agentLotNumber = agents[0]['lotNoPack'];
    packHouseName = agents[0]['packHouseName'];
    packHouseID = agents[0]['packHouseId'];
    packHouseCode = agents[0]['packHouseCode'].toString();
    exporterID = agents[0]["exporterId"].toString();
    exporterName = agents[0]['exporterName'];
    print("agentLotNumber" + agentLotNumber);
  }

  void lotNumberCalculation(String lotDate) async {
    String space = '_';
    var now = DateTime.now();
    var formatter = DateFormat(lotDate + '_HHmmss');
    String formattedDate = formatter.format(now);

    lotNumber = packHouseCode + space + formattedDate;
    print("lotNumber_lotNumber" + lotNumber.toString());

/*
    if (agentLotNumber != "") {
      String lotValue = agentLotNumber;
      final dateList = lotValue.split("-");
      String lotDate = dateList[0];
      String lotCount = dateList[1];
      String getLastLot = "";
      if (lotCount != "") {
        int number = int.parse(lotCount);
        getLastLot = (001 + number).toString();

        while (getLastLot.length < 3) {
          getLastLot = "0" + getLastLot;
        }
      }

      String date1 = lotDate;
      print("date1_date1" + date1);
      String getDate = date1.substring(0, 2);
      print("getDate" + getDate);
      String getMonth = date1.substring(2, 4);
      print("getMonth" + getMonth);
      String getYear = date1.substring(4, 6);
      print("getYear" + getYear);
      String space = "-";

      String convertDateFormat = getDate + space + getMonth + space + getYear;

      print("convertDateFormat" + convertDateFormat);

      DateTime parseDate = new DateFormat("dd-MM-yy").parse(convertDateFormat);
      var inputDate = DateTime.parse(parseDate.toString());
      final now = DateTime.now();
      final diff = now.difference(inputDate).inDays;
      bool isToday = diff == 0 && now.day == inputDate.day;
      if (isToday) {
        String lotNumberFormat = lotDate + space + getLastLot;
        lotNumber = lotNumberFormat;
        print("lotNumberTwo" + lotNumber);
      } else {
        lotNumber = lotNumberFormat;
        print("lotNumberThree" + lotNumber);
      }
    } else {
      lotNumber = lotNumberFormat;
      print("lotNumberThree" + lotNumber);
    }*/
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
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
          title: Text('Packing Operations',
              style: TextStyle(
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

  Future<void> getFarmer() async {
    String qryFarmer =
        'select distinct v.farmerId,v.farmerName,f.idProofVal,f.trader from  villageWarehouse as v inner join farmer_master as f on f.farmerId =v.farmerId  where v.stockType =2 and v.lastHarDate<=\'' +
            formatDate +
            '\'';
    print("qryFarmer_qryFarmer" + qryFarmer);
    List farmerList = await db.RawQuery(qryFarmer);

    farmerUiModel = [];
    farmerDropdown = [];
    farmerDropdown.clear();
    farmerIDList.clear();

    for (int i = 0; i < farmerList.length; i++) {
      String propertyValue = farmerList[i]["farmerName"].toString();
      String dispSEQ = farmerList[i]["farmerId"].toString();
      String idProofVal = farmerList[i]["idProofVal"].toString();
      String kraPin = farmerList[i]["trader"].toString();

      var farmerDetail =
          ListAddFarmer(dispSEQ, propertyValue, idProofVal, kraPin);
      farmerIDList.add(farmerDetail);
    }

    for (int i = 0; i < farmerIDList.length; i++) {
      String farmerName = farmerIDList[i].name;
      String farmerID = farmerIDList[i].value;
      String idProofVal = farmerIDList[i].value2;
      String kraPin = farmerIDList[i].value3;
      var uimodel =
          UImodel3(farmerName + " - " + farmerID, farmerID, idProofVal, kraPin);
      farmerUiModel.add(uimodel);
      setState(() {
        farmerDropdown.add(DropdownModelFarmer(
            farmerName + " - " + farmerID, farmerID, idProofVal, kraPin));
      });
    }
  }

  Future<void> getFarm(String farmerCode) async {
    String qryFarm =
        'select distinct farmId ,farmName from villageWarehouse where stockType =2 and farmerId=\'' +
            farmerCode +
            '\'';
    print("qryFarm_qryFarm" + qryFarm.toString());
    List farmList = await db.RawQuery(qryFarm);

    farmUiModel = [];
    farmDropdown = [];
    farmDropdown.clear();
    farmIDList.clear();

    for (int i = 0; i < farmList.length; i++) {
      String propertyValue = farmList[i]["farmName"].toString();
      String dispSEQ = farmList[i]["farmId"].toString();

      var farmDetail = ListAdd(dispSEQ, propertyValue);
      farmIDList.add(farmDetail);
    }
    String farmName = "", farmId = "";
    for (int i = 0; i < farmIDList.length; i++) {
      farmName = farmIDList[i].name;
      farmId = farmIDList[i].value;
      var uimodel = UImodel(farmName, farmId);
      farmUiModel.add(uimodel);
      setState(() {
        farmDropdown.add(DropdownModel(farmName, farmId));
      });
    }
  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select distinct plantingId from villageWarehouse where stockType=2 and blockId=\'' +
            blockID +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';

    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUIModel = [];
    plantingItems = [];
    plantingItems.clear();
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

  Future<void> blockId(String farmCode) async {
    String qryBlockNumber =
        'select distinct blockId,blockName from villageWarehouse where blockName!="" and stockType =2 and farmId=\'' +
            farmCode +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';
    print("qryBlockNumber" + qryBlockNumber.toString());
    List blockNumberList = await db.RawQuery(qryBlockNumber);

    blockUiModel = [];
    blockDropdown = [];
    blockDropdown.clear();
    blockIDList.clear();

    for (int i = 0; i < blockNumberList.length; i++) {
      String propertyValue = blockNumberList[i]["blockName"].toString();
      String dispSEQ = blockNumberList[i]["blockId"].toString();

      var blockDetail = ListAdd(dispSEQ, propertyValue);
      blockIDList.add(blockDetail);
    }
    bool blockExist = false;
    String blockName = "", blockID = "";
    for (int i = 0; i < blockIDList.length; i++) {
      blockName = blockIDList[i].name;
      blockID = blockIDList[i].value;
      var uimodel = UImodel(blockName, blockID);
      blockUiModel.add(uimodel);
      setState(() {
        blockDropdown.add(DropdownModel(
          blockName,
          blockID,
        ));
      });
    }
  }

  Future<void> receptionNumber(String plantingID) async {
    String qryReception =
        'select distinct batchNo from villageWarehouse where stockType =2 and plantingId=\'' +
            plantingID +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';
    print("qryReception" + qryReception.toString());
    List receptionList = await db.RawQuery(qryReception);
    print("receptionList" + receptionList.toString());

    receptionUiModel = [];
    receptionDropdown = [];
    receptionDropdown.clear();
    receptionIDList.clear();

    for (int i = 0; i < receptionList.length; i++) {
      String propertyValue = receptionList[i]["batchNo"].toString();
      String dispSEQ = receptionList[i]["batchNo"].toString();
     // String lastHarDate = receptionList[i]["lastHarDate"].toString();

     // var receptionDetail = ListWithDate(dispSEQ, propertyValue, lastHarDate);
      var receptionDetail = ListAdd(dispSEQ, propertyValue);
      receptionIDList.add(receptionDetail);

      print("receptionIDList_fooLoop" + receptionList[i]["batchNo"]);
    }
    bool receptionExist = false;
    String batchNumber = "", batchName = "", batchDate = "";
    for (int i = 0; i < receptionIDList.length; i++) {
      batchNumber = receptionIDList[i].value;
      batchName = receptionIDList[i].name;
     // batchDate = receptionIDList[i].dateValue;
      //var uimodel = UImodel(batchName, batchNumber, batchDate);
      var uimodel = UImodel(batchName, batchNumber);
      receptionUiModel.add(uimodel);
      setState(() {

        receptionDropdown.add(DropdownMenuItem(
          child: Text(batchName),
          value: batchName,
        ));
      });
    }
  }

  Future<void> batchDetail(String batchNumber) async {
    String qryBatchDetail =
        'select distinct batchNo,pCode,pName,vCode,vName,countyCode,countyName,actWt from villageWarehouse where stockType =2 and batchNo=\'' +
            batchNumber +
            '\' and plantingId =\'' +
            valPlanting +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';
    print("qryBatchDetail" + qryBatchDetail.toString());
    List batchDetailList = await db.RawQuery(qryBatchDetail);

    print("batchDetailList" + batchDetailList.length.toString());

    for (int i = 0; i < batchDetailList.length; i++) {
      String pName = batchDetailList[i]["pName"].toString();
      String vName = batchDetailList[i]["vName"].toString();
      String stateName = batchDetailList[i]["countyName"].toString();
      String stateCode = batchDetailList[i]["countyCode"].toString();
      String actWt = batchDetailList[i]["actWt"].toString();
      String pCode = batchDetailList[i]["pCode"].toString();
      String vCode = batchDetailList[i]["vCode"].toString();

      String uomCode =
          'select hsCode from varietyList where vName =\'' +
              pName +
              '\'';

      print("uomCode" + uomCode.toString());

      List uomList = await db.RawQuery(uomCode);
      print("uomList" + uomList.toString());

      setState(() {
        product = pName;
        uom = uomList[0]['hsCode'];
        variety = vName;
        countyName = stateName;
        countyCode = stateCode;
        availableQty = actWt;
        productId = pCode;
        varietyId = vCode;
      });
    }
  }

  Future<void> checkStock(
      String batchNumber, String plantingNumber, String qty) async {
    // check incoming stock
    String qryBatchDetail =
        'select  actWt from villageWarehouse where stockType =2 and batchNo=\'' +
            batchNumber +
            '\' and plantingId =\'' +
            plantingNumber +
            '\'';
    print("qryBatchDetailIF" + qryBatchDetail.toString());
    List batchDetailList = await db.RawQuery(qryBatchDetail);
    String weight = "";

    if (batchDetailList.isNotEmpty) {
      for (int i = 0; i < batchDetailList.length; i++) {
        String actWt = batchDetailList[i]["actWt"].toString();
        setState(() {
          weight = actWt;
        });
      }

      setState(() {
        if (weight.isNotEmpty) {
          double value = double.parse(weight);
          availableQty = value.toString();

          double value2 = double.parse(availableQty);
          availableQtyValue = value2;
        }
      });
    } else {
      // check packing stock
      String qryBatchDetail =
          'select actWt ,rejWt from villageWarehouse where stockType =3 and resBatNo=\'' +
              batchNumber +
              '\' and plantingId =\'' +
              plantingNumber +
              '\'';
      print("qryBatchDetailelse" + qryBatchDetail.toString());
      List batchDetailList = await db.RawQuery(qryBatchDetail);
      double pWt = 0.0;
      double value2 = 0.0;
      if (batchDetailList.isNotEmpty) {
        for (int i = 0; i < batchDetailList.length; i++) {
          String actQty = batchDetailList[i]["actWt"].toString();
          String rejWt = batchDetailList[i]["rejWt"].toString();
          setState(() {
            String actualWt = actQty;
            String rejectWt = rejWt;
            double aWt = double.parse(actualWt);
            print("aWt_aWt" + aWt.toString());
            double rWt = double.parse(rejectWt);
            print("rWt_rWt" + rWt.toString());
            pWt = aWt + rWt;
            print("pWt_pWt" + pWt.toString());
          });
        }
        String convertPwt = pWt.toStringAsFixed(3).toString();
        double getValue = double.parse(convertPwt);
        double qrQTy = double.parse(qty);
        double packedQty = qrQTy - getValue;
        availableQty = packedQty.toString();
        print("availableQty_availableQty" + availableQty.toString());
        double value2 = double.parse(availableQty);
        availableQtyValue = value2;
        print("value2" + value2.toString());
        print("getValue" + getValue.toString());
        print("qty_" + qty.toString());
      }
      if (value2 <= 0) {
        print('ddddd');
        alertPopup(context, "Invalid QR");
        clearData();
      }else{
        print('ddddd---00');

      }
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

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];

    listings
        .add(txt_label_mandatory("Packing Date", Colors.black, 14.0, false));
    if (packingList.isEmpty) {
      listings.add(selectDate(
          context1: context,
          slctdate: selectedDate,
          onConfirm: (date) => setState(
                () {
                  selectedDate = DateFormat('dd-MM-yyyy').format(date);
                  formatDate = DateFormat('yyyy-MM-dd').format(date);
                  lotDate = DateFormat('ddMMyy').format(date);
                  packingDate(date);
                  lotNumberCalculation(lotDate);
                  selectedPackingDate = date;
                  packingDateComparsion(formatDate, bestBeforeDate);
                  farmerSelect = null;
                  farmerDropdown = [];
                  slcFarmer = "";
                  valFarmer = "";
                  farmLoaded = false;
                  slcFarm = "";
                  blockLoaded = false;
                  slcBlockNumber = "";
                  blockSelect = null;
                  farmSelect = null;
                  receptionLoaded = false;
                  slcReception = "";
                  product = "";
                  variety = "";
                  availableQty = "";
                  countyName = "";
                  valFarm = "";
                  valBlockNumber = "";
                  valReception = "";
                  receptionDropdown = [];
                  blockDropdown = [];
                  farmDropdown = [];
                  valFarm = "";
                  plantingLoaded = false;
                  plantingItems = [];
                  slcPlanting = "";
                  valPlanting = "";
                  plantingSelect = null;
                  getFarmer();
                },
              )));
    } else {
      listings.add(cardlable_dynamic(selectedDate.toString()));
    }

    listings.add(txt_label_mandatory("Packhouse", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(packHouseName.toString()));

    listings.add(txt_label_mandatory("Packer Name", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Packer Name", packerNameController, true, 50));

    listings.add(txt_label_mandatory("Farmer", Colors.black, 16.0, false));
    listings.add(farmerDropDownWithModel(
      itemlist: farmerDropdown,
      selecteditem: farmerSelect,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          farmerSelect = value!;
          farmLoaded = false;
          slcFarm = "";
          blockLoaded = false;
          slcBlockNumber = "";
          blockSelect = null;
          farmSelect = null;
          receptionLoaded = false;
          slcReception = "";
          product = "";
          variety = "";
          availableQty = "";
          countyName = "";
          valFarm = "";
          valBlockNumber = "";
          valReception = "";
          receptionDropdown = [];
          blockDropdown = [];
          farmDropdown = [];
          valFarm = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          plantingSelect = null;
          slcFarmer = farmerSelect!.name;
          valFarmer = farmerSelect!.value;
          getFarm(valFarmer);
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
            String incomingValue = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScanner()));
            print("incoming shipmentValue" + incomingValue.toString());
            setState(() {
              slcValue = incomingValue;
            });

            getIncomingDetail(incomingValue);
          }else{
            String incomingValue = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScannerAndroid()));
            print("incoming shipmentValue" + incomingValue.toString());
            setState(() {
              slcValue = incomingValue;
            });

            getIncomingDetail(incomingValue);
          }

        }));

    listings.add(txt_label_mandatory("Farm", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: farmDropdown,
      selecteditem: farmSelect,
      hint: "Select Farm",
      onChanged: (value) {
        setState(() {
          farmSelect = value!;
          blockLoaded = false;
          slcBlockNumber = "";
          blockSelect = null;
          receptionLoaded = false;
          slcReception = "";
          product = "";
          valFarm = "";
          variety = "";
          availableQty = "";
          countyName = "";
          valBlockNumber = "";
          valReception = "";
          receptionDropdown = [];
          blockDropdown = [];
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          plantingSelect = null;
          slcFarm = farmSelect!.name;
          valFarm = farmSelect!.value;
          blockId(valFarm);
        });
      },
    ));

    listings.add(valFarm.isNotEmpty
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.isNotEmpty
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(txt_label_mandatory("Block Name", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: blockDropdown,
      selecteditem: blockSelect,
      hint: "Select Block Name",
      onChanged: (value) {
        setState(() {
          blockSelect = value!;
          receptionLoaded = false;
          receptionDropdown = [];
          slcReception = "";
          product = "";
          variety = "";
          availableQty = "";
          countyName = "";
          valReception = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          plantingSelect = null;
          slcBlockNumber = blockSelect!.name;
          valBlockNumber = blockSelect!.value;
          plantingIdSearch(valBlockNumber);
        });
      },
    ));

    listings.add(txt_label_mandatory("Planting ID", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: plantingItems,
      selecteditem: plantingSelect,
      hint: "Select Planting ID",
      onChanged: (value) {
        setState(() {
          plantingSelect = value!;
          receptionLoaded = false;
          receptionDropdown = [];
          slcReception = "";
          product = "";
          variety = "";
          availableQty = "";
          countyName = "";
          valReception = "";
          valPlanting = plantingSelect!.value;
          slcPlanting = plantingSelect!.name;
          receptionNumber(valPlanting);
        });
      },
    ));

    listings.add(
        txt_label_mandatory("Reception Batch No", Colors.black, 16.0, false));
    listings.add(singlesearchDropdown(
      itemlist: receptionDropdown,
      selecteditem: slcReception,
      hint: "Select Reception Batch No",
      onChanged: (value) {
        setState(() {
          slcReception = value!;
          product = "";
          variety = "";
          availableQty = "";
          countyName = "";
          for (int i = 0; i < receptionUiModel.length; i++) {
            if (value == receptionUiModel[i].name) {
              valReception = receptionUiModel[i].value;
             // getDateValue = receptionUiModel[i].value2;
            //  packingDate(selectedPackingDate!);
              batchDetail(valReception);
            }
          }
        });
      },
    ));

    listings.add(txt_label("Crop Name ($uom)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(product.toString()));

    listings.add(txt_label("Variety", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(variety.toString()));

    listings
        .add(txt_label("Available Quantity (Kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(availableQty.toString()));

    listings.add(
        txt_label_mandatory("Packed Quantity (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Packed Quantity (Kg)", packedQTYController, true, 50));

    listings.add(txt_label_mandatory(
        "Rejected Quantity (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Rejected Quantity (Kg)", rejectedQTYController, true, 50));

    listings.add(txt_label_mandatory("Price Per Kg", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal("Price Per Kg", priceController, true, 50));

    listings.add(txt_label_mandatory("Product Value", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal("Product Value", prodValController, false, 50));

    listings.add(
        txt_label_mandatory("Best Before Date", Colors.black, 16.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: bestBeforeDate,
        onConfirm: (date) => setState(
              () {
                bestBeforeDate = DateFormat('dd-MM-yyyy').format(date);
                formatBestBeforeDate = DateFormat('yyyy-MM-dd').format(date);
                packingDateComparsion(formatDate, bestBeforeDate);
              },
            )));

    listings.add(txt_label("County of Origin", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(countyName.toString()));

    listings.add(btn_dynamic(
        label: "Add",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          bool alreadyExist = false;
          bool blockPlantingAdded=false;
          if (packingList.isNotEmpty) {
            for (int i = 0; i < packingList.length; i++) {
              if (packingList[i].blockId == valBlockNumber) {
                if (packingList[i].receptionId == valReception) {
                  if (packingList[i].plantingId == valPlanting) {
                    setState(() {
                      alreadyExist = true;
                    });
                  }
                }
              }

              if (packingList[i].blockId.contains(valBlockNumber) &&
                  packingList[i].plantingId.contains(valPlanting)) {
                idGeneration=packingList[i].qrIdValue;
                setState(() {
                  blockPlantingAdded=true;
                });
              }
            }
          }

          bool validQty = true;
          if (packedQTYController.text.isNotEmpty) {
            if (packedQtyValue <= 0) {
              validQty = false;
            } else if (packedQTYController.text.contains('.')) {
              List<String> value = packedQTYController.text.split(".");
              if (value[1].isNotEmpty) {
                setState(() {
                  validQty = true;
                });
              } else {
                validQty = false;
              }
            } else {
              validQty = true;
            }
          }

          bool validRejectQTy = true;
          if (rejectedQTYController.text.isNotEmpty) {
            if (rejectedQTYController.text.contains('.')) {
              List<String> value = rejectedQTYController.text.split(".");
              if (value[1].isNotEmpty) {
                setState(() {
                  validRejectQTy = true;
                });
              } else {
                validRejectQTy = false;
              }
            } else {
              validRejectQTy = true;
            }
          }

          bool validPrice = true;
          if (priceController.text.isNotEmpty) {
            if (priceValue <= 0) {
              validPrice = false;
            } else if (priceController.text.contains('.')) {
              List<String> value = priceController.text.split(".");
              print("value_value" + value.toString());
              if (value[1].isNotEmpty) {
                setState(() {
                  validPrice = true;
                });
              } else {
                validPrice = false;
              }
            } else {
              validPrice = true;
            }
          }

          print("packedQtyValue_packedQtyValue" + packedQtyValue.toString());
          print("availableQtyValue_availableQtyValue" +
              availableQtyValue.toString());
          print("currentQtyValue_currentQtyValue" + currentQtyValue.toString());

          if (slcFarmer.isEmpty) {
            alertPopup(context, "Farmer should not be empty");
          } else if (slcFarm.isEmpty) {
            alertPopup(context, "Farm should not be empty");
          } else if (slcBlockNumber.isEmpty) {
            alertPopup(context, "Block Name should not be empty");
          } else if (slcPlanting.isEmpty) {
            alertPopup(context, "Planting ID should not be empty");
          } else if (slcReception.isEmpty) {
            alertPopup(context, "Reception Batch Number should not be empty");
          } else if (packedQTYController.text.isEmpty) {
            alertPopup(context, "Packed Quantity (Kg) should not be empty");
          } else if (!validQty) {
            alertPopup(context, "Invalid Packed Quantity (Kg)");
          } else if (packedQtyValue > availableQtyValue) {
            alertPopup(context,
                "Packed Quantity (Kg) should not be greater than Available Quantity (Kg)");
          } else if (rejectedQTYController.text.isEmpty) {
            alertPopup(context, "Rejected Quantity (Kg) should not be empty");
          } else if (!validRejectQTy) {
            alertPopup(context, "Invalid Rejected Quantity (Kg)");
          } else if (rejectedQtyValue > currentQtyValue) {
            alertPopup(context,
                "Rejected Quantity(Kg) value should not exceed the value of (Available_qty - Packed_Quantity)");
          } else if (priceController.text.isEmpty) {
            alertPopup(context, "Price Per Kg should not be empty");
          } else if (prodValController.text.isEmpty) {
            alertPopup(context, "Product Value should not be empty");
          } else if (!validPrice) {
            alertPopup(context, "Invalid Price");
          } else if (bestBeforeDate.isEmpty) {
            alertPopup(context, "Best Before Date should not be empty");
          } else if (afterPackingDate) {
            alertPopup(context,
                "Best Before date should not be less than the Packing Date");
          } else if (alreadyExist) {
            alertPopup(context,
                "Reception batch number already exists for this Planting ID");
          } else {

            if(!blockPlantingAdded){
              int countQR = packingList.length;
              idGeneration = qrIdGeneration+ countQR.toString();
            }
            var packing = PackingClass(
                slcReception,
                valReception,
                slcBlockNumber,
                valBlockNumber,
                packedQTYController.text,
                priceController.text,
                prodValController.text,
                formatBestBeforeDate,
                product,
                productId,
                availableQty,
                variety,
                varietyId,
                countyName,
                slcFarmer,
                valFarmer,
                slcFarm,
                valFarm,
                countyCode,
                rejectedQTYController.text.toString(),
                valPlanting,idGeneration,bestBeforeDate);
            setState(() {
              packingList.add(packing);
            });


            getPackingData();

            setState(() {
              slcFarmer = "";
              slcFarm = "";
              slcReception = "";
              slcBlockNumber = "";
              slcPlanting = "";
              plantingSelect = null;
              blockSelect = null;
              farmSelect = null;
              packedQTYController.text = "";
              rejectedQTYController.text = "";
              priceController.text = "";
              prodValController.text ='';
              bestBeforeDate = "";
              product = "";
              variety = "";
              availableQty = "";
              countyName = "";
              farmerSelect = null;
              farmDropdown = [];
              valFarm = "";
              blockDropdown = [];
              valBlockNumber = "";
              receptionDropdown = [];
              valReception = "";
              plantingItems = [];
              valPlanting = "";
            });
          }
        }));

    if (packingList.isNotEmpty) {
      listings.add(packingScreenDataTable());
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
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
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

    return listings;
  }

  
  void getPackingData(){
    if(packingList.isNotEmpty){
      double getPackedQty=0.0;
      for(int i=0;i<packingList.length;i++){
        if (packingList[i].plantingId.contains(valPlanting)) {
          if (packingList[i].blockId.contains(valBlockNumber)) {
           String receptionName=packingList[i].receptionName;
           String receptionId=packingList[i].receptionId;
           String blockName=packingList[i].blockName;
           String blockId=packingList[i].blockId;
           String packedQty=packingList[i].packedQTy;
           String price=packingList[i].price;
           String productVal=packingList[i].productVal;
           String bestBeforeData=packingList[i].bestDate;
           String productName=packingList[i].product;
           String productId=packingList[i].productId;
           String availableQty=packingList[i].availableQTY;
           String varietyName=packingList[i].variety;
           String varietyId=packingList[i].varietyId;
           String countyName=packingList[i].county;
           String farmerName=packingList[i].farmerName;
           String farmerId=packingList[i].farmerId;
           String farmName=packingList[i].farmName;
           String farmId=packingList[i].farmID;
           String countyCode=packingList[i].countyCode;
           String rejectedQty=packingList[i].rejectedQty;
           String plantingId=packingList[i].plantingId;
           String qrIDValue=packingList[i].qrIdValue;

           getPackedQty=double.parse(packedQty)+getPackedQty;
           setState(() {
             existData=true;
           });

           print("getPackedQty_getPackedQty"+getPackedQty.toString());
           print("availableQty"+availableQty.toString());

           getData(
               receptionName,
               receptionId,
               blockName,
               blockId,
               getPackedQty.toString(),
               price,
               productVal,
               bestBeforeData,
               productName,
               productId,
               availableQty.toString(),
               varietyName,
               varietyId,
               countyName,
               farmerName,
               farmerId,
               farmName,
               farmId,
               countyCode,
               rejectedQty,
               plantingId,
               qrIDValue
           );
            
          }
        }
      }
    }
  }
  void packingDateComparsion(
      String packingDateValue, String bestBeforeDate) async {
    print("packingDate" + packingDate.toString());
    if (formatDate != "" && formatBestBeforeDate != "") {
      String dateValue = formatDate;
      String trimmedDate = dateValue.substring(0, 10);

      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      String dateValue1 = formatBestBeforeDate;
      String trimmedDate1 = dateValue1.substring(0, 10);

      String startDate1 = trimmedDate1;
      List<String> splitStartDate1 = startDate1.split('-');

      String strYearq1 = splitStartDate1[0];
      String strMonthq1 = splitStartDate1[1];
      String strDateq1 = splitStartDate1[2];

      int strYear1 = int.parse(strYearq1);
      int strMonths1 = int.parse(strMonthq1);
      int strDate1 = int.parse(strDateq1);

      DateTime convertPackingDate = new DateTime(strYear, strMonths, strDate);
      DateTime convertBestBeforeDate =
          new DateTime(strYear1, strMonths1, strDate1);

      print("convertPackingDate" + convertPackingDate.toString());

      DateTime valEnd = convertPackingDate;
      bool valDate = convertBestBeforeDate.isBefore(valEnd);
      if (valDate) {
        setState(() {
          afterPackingDate = true;
        });
      } else if (formatDate == formatBestBeforeDate) {
        setState(() {
          afterPackingDate = false;
        });
      } else {
        setState(() {
          afterPackingDate = false;
        });
      }
    }
  }

  void btnSubmit() {
    if (selectedDate.isEmpty) {
      alertPopup(context, "Packing Date should not be empty");
    } else if (packerNameController.text.isEmpty) {
      alertPopup(context, "Packer Name should not be empty");
    } else if (packingList.isEmpty) {
      alertPopup(context, "Add Atleast one packing List");
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
            Navigator.pop(context);
            savePacking();
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

  Future<void> savePacking() async {
    var db = DatabaseHelper();
    final now = DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    print('txnHeader ' + agentid! + "" + agentToken!);
    Random rnd = Random();
    int revNo = 100000 + rnd.nextInt(999999 - 100000);

    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0,\'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\',\'' +
            agentid +
            '\', \'' +
            agentToken +
            '\',\'' +
            msgNo +
            '\', \'' +
            servicePointId +
            '\',\'' +
            revNo.toString() +
            '\')';

    int txnsucc = await db.RawInsert(insqry);
    print(txnsucc);

    AppDatas datas = AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnPacking, revNo.toString(), '', '', '');

    int packing = await db.savePacking(formatDate, packHouseID, lotNumber,
        revNo.toString(), "1", packerNameController.text);

    if (packingList.isNotEmpty) {
      for (int i = 0; i < packingList.length; i++) {
        int position = i + 1;
        String idGeneration = revNo.toString() + position.toString();
        int savePackingList = await db.savePackingDetail(
            packingList[i].farmerId,
            packingList[i].farmerName,
            packingList[i].farmID,
            packingList[i].farmName,
            packingList[i].receptionId,
            packingList[i].blockId,
            packingList[i].blockName,
            packingList[i].productId,
            packingList[i].product,
            packingList[i].varietyId,
            packingList[i].variety,
            packingList[i].availableQTY,
            packingList[i].packedQTy,
            packingList[i].price,
            packingList[i].productVal,
            packingList[i].bestDate,
            packingList[i].county,
            revNo.toString(),
            lotNumber,
            countyCode,
            countyName,
            packingList[i].rejectedQty,
            packingList[i].plantingId,
            packingList[i].qrIdValue);
      }
    }

    await db.UpdateTableValue(
        'packHouse', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();
    for (int i = 0; i < packingQRList.length; i++) {
      int position = i + 1;
      String idGeneration = revNo.toString() + position.toString();
      count = i;

      Qrvalue =
          lotNumber +
          "~" +
          packingQRList[i].countyCode +
          "~" +
          packingQRList[i].county +
          "~" +
          packingQRList[i].blockId +
          "~" +
          packingQRList[i].blockName +
          "~" +
          packingQRList[i].productId +
          "~" +
          packingQRList[i].product +
          "~" +
          packingQRList[i].varietyId +
          "~" +
          packingQRList[i].variety +
          "~" +
          packingQRList[i].packedQTy +
          "~" +
          packingQRList[i].farmerId +
          "~" +
          packingQRList[i].farmerName +
          "~" +
          packingQRList[i].farmID +
          "~" +
          packingQRList[i].farmName +
          "~" +
          "3" +
          "~" +
          exporterID +
          "~" +
          formatDate +
          "~" +
          packHouseID +
          "~" +
          packingQRList[i].plantingId +
          "~" +
          packingQRList[i].qrIdValue+
              "~" +
              packingQRList[i].bDate;

      Qr.add(Qrvalue);
    }

    int QrNum = count + 1;
    print("Count" + QrNum.toString());

    String get = Qr.toString();
    String Array = get.replaceAll("[", " ");
    String QrEdited = Array.replaceAll("]", " ");

    String Multi = "Gokul";
    print("Value Array " + QrEdited);

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Packing Operations done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            for (int k = 0; k < packingQRList.length; k++) {
              var printList=[];
              List<PrintModel> printLists = [];
              printLists.add(PrintModel("Lot Number", lotNumber));
              printLists.add(PrintModel("Block ID", packingQRList[k].blockId));
              printLists
                  .add(PrintModel("Planting ID", packingQRList[k].plantingId));
              printLists.add(PrintModel("Crop Name", packingQRList[k].product));
              printLists.add(PrintModel("Variety", packingQRList[k].variety));
              printLists
                  .add(PrintModel("Packed Qty(Kg)", packingQRList[k].packedQTy));
              printLists.add(PrintModel("Exporter Name", exporterName));
              printLists.add(PrintModel("Date and Time", txntime));
              printLists
                  .add(PrintModel("QR Unique Id", packingQRList[k].qrIdValue.toString()));
              multipleprintLists.add(MultiplePrintModel(printLists, Qr[k]));

              String FarmerNameQ ='';
              for(int i = 0 ;i <printLists.length ; i++){
                FarmerNameQ = printLists[i].value ;
                printList.add(FarmerNameQ);
              }
              String removeBraces= printList.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '/');

              for (int i= 0 ; i< multipleprintLists.length ;i ++){
                int saveQr = await db.saveQRDetails(
                  '$revNo',
                  '3',
                  txntime.split(' ')[0],
                  multipleprintLists[i].qrString.toString(),
                  removeBraces,
                    packingQRList[k].product,
                    packingQRList[k].plantingId
                );
              }
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        QrReader(multipleprintLists, 'Packing','')));
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

  Widget packingScreenDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Reception Batch No')));
    columns.add(DataColumn(label: Text('Block Name')));
    columns.add(DataColumn(label: Text('Planting ID')));
    columns.add(DataColumn(label: Text('Packed Quantity (Kg)')));
    columns.add(DataColumn(label: Text('Rejected Quantity (Kg)')));
    columns.add(DataColumn(label: Text('Price Per Kg')));
    columns.add(DataColumn(label: Text('Product Value')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < packingList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(packingList[i].receptionName)));
      singlecell.add(DataCell(Text(packingList[i].blockName)));
      singlecell.add(DataCell(Text(packingList[i].plantingId)));
      singlecell.add(DataCell(Text(packingList[i].packedQTy)));
      singlecell.add(DataCell(Text(packingList[i].rejectedQty)));
      singlecell.add(DataCell(Text(packingList[i].price)));
      singlecell.add(DataCell(Text(packingList[i].productVal)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            packingList.removeAt(i);
            countQR=countQR-1;
            getPackingData();
          });
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

  Future<void> farmValueCheck() async {
    bool farm = false;
    bool farmExist = false;
    for (int i = 0; i < farmIDList.length; i++) {
      if (farmIDList[i].value == valFarm) {
        farmExist = true;
      }
    }
    if (!farmExist) {
      for (int i = 0; i < farmIDList.length; i++) {
        if (slcFarm != "" && valFarm != "") {
          setState(() {
            farm = true;
          });
        }
      }
    }
    if (farmIDList.isNotEmpty) {
      if (farm) {
        var getValue = ListAdd(valFarm, slcFarm);
        farmIDList.add(getValue);

        var uimodel = UImodel(
          slcFarm,
          valFarm,
        );
        farmUiModel.add(uimodel);
        setState(() {
          farmDropdown.add(DropdownModel(slcFarm, valFarm));
        });
      }
    }
  }

  Future<void> farmerValueCheck() async {
    bool farmer = false;
    bool farmerExist = false;
    for (int i = 0; i < farmerIDList.length; i++) {
      if (farmerIDList[i].value == valFarmer) {
        farmerExist = true;
      }
    }
    if (!farmerExist) {
      for (int i = 0; i < farmerIDList.length; i++) {
        if (slcFarmer != "" && valFarmer != "") {
          setState(() {
            farmer = true;
          });
        }
      }
    }
    if (farmerIDList.isNotEmpty) {
      if (farmer) {
        var getValue = ListAddFarmer(valFarmer, slcFarmer, "", "");
        farmerIDList.add(getValue);

        var uimodel = UImodel3(slcFarmer, valFarmer, "", "");
        farmerUiModel.add(uimodel);
        setState(() {
          farmerDropdown.add(DropdownModelFarmer(slcFarmer, valFarmer, "", ""));
        });
      }
    }
  }

  Future<void> blockValueCheck() async {
    bool block = false;
    bool blockExist = false;
    for (int i = 0; i < blockIDList.length; i++) {
      if (blockIDList[i].value == valBlockNumber) {
        blockExist = true;
      }
    }
    if (!blockExist) {
      for (int i = 0; i < blockIDList.length; i++) {
        if (slcBlockNumber != "" && valBlockNumber != "") {
          setState(() {
            block = true;
          });
        }
      }
    }
    if (blockIDList.isNotEmpty) {
      if (block) {
        var getValue = ListAdd(valBlockNumber, slcBlockNumber);
        blockIDList.add(getValue);

        var uimodel = UImodel(
          slcBlockNumber,
          valBlockNumber,
        );
        blockUiModel.add(uimodel);
        setState(() {
          blockDropdown.add(DropdownModel(slcBlockNumber, valBlockNumber));
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

        var uimodel = UImodel(
          slcPlanting,
          valPlanting,
        );
        plantingUIModel.add(uimodel);
        setState(() {
          plantingItems.add(DropdownModel(slcPlanting, valPlanting));
        });
      }
    }
  }

  Future<void> receptionValueCheck() async {
    bool reception = false;
    bool receptionExist = false;
    for (int i = 0; i < receptionIDList.length; i++) {
      if (receptionIDList[i].value == valReception) {
        receptionExist = true;
      }
    }
    if (!receptionExist) {
      for (int i = 0; i < receptionIDList.length; i++) {
        if (slcReception != "" && valReception != "") {
          setState(() {
            reception = true;
          });
        }
      }
    }
    if (receptionIDList.isNotEmpty) {
      if (reception) {
     // var getValue = ListWithDate(valReception, slcReception, getDateValue);
        var getValue = ListAdd(valReception, slcReception);
        receptionIDList.add(getValue);

        var uimodel = UImodel(
          slcReception,
          valReception,
        );
        receptionUiModel.add(uimodel);
        setState(() {
          receptionDropdown.add(DropdownMenuItem(
            child: Text(slcReception),
            value: slcReception,
          ));
        });
      }
    }
  }

  void packingDate(DateTime packingDate) async {
    print("getDateValue_getDateValue" + getDateValue.toString());
    if (getDateValue != "") {
      String dateValue = getDateValue;
      String trimmedDate = dateValue.substring(0, 10);

      DateTime convertPackingDate = packingDate;
      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertDate = DateTime(strYear, strMonths, strDate);

      print("convertDate" + convertDate.toString());
      print("convertIncomingDate" + convertPackingDate.toString());

      DateTime valEnd = convertPackingDate;
      bool valDate = convertDate.isBefore(valEnd);
      print("valDate_valDate" + valDate.toString());
      bool sameDate = convertPackingDate.isAtSameMomentAs(convertDate);
      print("sameDate_sameDate" + sameDate.toString());
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

  Future<void> getIncomingDetail(String sortingValue) async {
    print("validDateDate" + validDate.toString());
    try {
      List<String> splitList = sortingValue.split('~');
      print("splitList_splitList" + splitList.toString());
      print("splitList_length" + splitList.length.toString());
      if (splitList.length == 20) {
        setState(() {
          slcReception = splitList[0].toString().trim();
          valReception = splitList[0].toString().trim();

          countyCode = splitList[1].toString().trim();
          countyName = splitList[2].toString().trim();
          valBlockNumber = splitList[3].toString().trim();
          slcBlockNumber = splitList[4].toString().trim();
          productId = splitList[5].toString().trim();
          product = splitList[6].toString().trim();
          varietyId = splitList[7].toString().trim();
          variety = splitList[8].toString().trim();
          valFarmer = splitList[10].toString().trim();
          slcFarmer = splitList[11].toString().trim();
          valFarm = splitList[12].toString().trim();
          slcFarm = splitList[13].toString().trim();
          stockID = splitList[14].toString().trim();
          qrExportedID = splitList[15].toString().trim();
          getDateValue = splitList[16].toString().trim();
          qrPackHouseID = splitList[17].toString().trim();
          valPlanting = splitList[18].toString().trim();
          slcPlanting = splitList[18].toString().trim();
          /*       availableQty = splitList[9].toString().trim();*/

          String qty = splitList[9].toString().trim();
          batchDetail(valReception);
          checkStock(valReception, valPlanting, qty);

          /* if (availableQty == splitList[9].toString().trim()) {
            availableQty = splitList[9].toString().trim();
          }
*/
          blockSelect = DropdownModel(slcBlockNumber, valBlockNumber);
          farmerSelect = DropdownModelFarmer(
              slcFarmer + " - " + valFarmer, valFarmer, "", "");
          farmSelect = DropdownModel(slcFarm, valFarm);
          plantingSelect = DropdownModel(slcPlanting, valPlanting);
        });
        if (selectedDate.isNotEmpty) {
          packingDate(selectedPackingDate!);
        }
        if (qrPackHouseID == packHouseID) {
          if (selectedDate.isNotEmpty) {
            if (validDate) {
              if (stockID == "2") {
                farmerValueCheck();
                farmValueCheck();
                blockValueCheck();
                plantingIDValueCheck();
                receptionValueCheck();

                getFarm(valFarmer);
                blockId(valFarm);
                plantingIdSearch(valBlockNumber);
                receptionNumber(valPlanting);
              } else {
                print("stockID_else" + stockID.toString());
                alertPopup(context, "Invalid QR code");
                clearData();
              }
            } else {
              alertPopup(context, "Invalid Packing Date");
              clearData();
            }
          } else {
            alertPopup(context, "Select Packing Date Before Scan");
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
      slcFarm = "";
      farmSelect = null;
      slcFarmer = "";
      farmerSelect = null;
      slcBlockNumber = "";
      blockSelect = null;
      slcReception = "";
      countyName = "";
      product = "";
      variety = "";
      valFarm = "";
      availableQty = "";
      blockDropdown = [];
      receptionDropdown = [];
      farmDropdown = [];
      plantingItems = [];
      slcPlanting = "";
      valPlanting = "";
      plantingSelect = null;
    });
  }

  void getData(
      String receptionName,
      String receptionId,
      String blockName,
      String blockId,
      String packedQty,
      String price,
      String productVal,
      String bestBeforeData,
      String productName,
      String productId,
      String availableQty,
      String varietyName,
      String varietyId,
      String countyName,
      String farmerName,
      String farmerId,
      String farmName,
      String farmId, String countyCode, String rejectedQty, String plantingId,String qrIDValue) {


    if (packingQRList.isNotEmpty) {
      for (int t = 0; t < packingQRList.length; t++) {
        if (packingQRList[t].blockId.contains(blockId) &&
            packingQRList[t].plantingId.contains(plantingId)) {
          packingQRList.removeAt(t);
        }
      }
    }


    if (existData) {
      setState(() {
        var getValue=   PackingClass(
            receptionName,
            receptionId,
            blockName,
            blockId,
            packedQty,
            price,
            productVal,
            bestBeforeData,
            productName, productId, availableQty, varietyName, varietyId, countyName, farmerName, farmerId, farmName, farmerId, countyCode, rejectedQty, plantingId,qrIDValue,bestBeforeData);
        packingQRList.add(getValue);
      });


    }

  }
}

class PackingClass {
  String receptionName,
      receptionId,
      blockName,
      blockId,
      packedQTy,
      price,
      productVal,
      bestDate,
      product,
      productId,
      availableQTY,
      variety,
      varietyId,
      county,
      farmerName,
      farmerId,
      farmName,
      farmID,
      countyCode,
      rejectedQty,
      plantingId,
      qrIdValue,bDate;

  PackingClass(
      this.receptionName,
      this.receptionId,
      this.blockName,
      this.blockId,
      this.packedQTy,
      this.price,
      this.productVal,
      this.bestDate,
      this.product,
      this.productId,
      this.availableQTY,
      this.variety,
      this.varietyId,
      this.county,
      this.farmerName,
      this.farmerId,
      this.farmName,
      this.farmID,
      this.countyCode,
      this.rejectedQty,
      this.plantingId,
      this.qrIdValue,this.bDate);
}

class ListAdd {
  String value;
  String name;

  ListAdd(this.value, this.name);
}

class ListAddFarmer {
  String value;
  String name;
  String value2;
  String value3;

  ListAddFarmer(this.value, this.name, this.value2, this.value3);
}

class ListWithDate {
  String value;
  String name;
  String dateValue;

  ListWithDate(this.value, this.name, this.dateValue);
}
