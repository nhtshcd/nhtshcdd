
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Screens/PackingScreen.dart';
import 'package:nhts/Screens/qrcode.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/QRScannerAndroid.dart';
import 'package:nhts/Utils/QrScanner.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


import '../Utils/secure_storage.dart';
import '../login.dart';

class IncomingShipment extends StatefulWidget {
  const IncomingShipment({Key? key}) : super(key: key);

  @override
  _IncomingShipmentState createState() => _IncomingShipmentState();
}

class _IncomingShipmentState extends State<IncomingShipment> {
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';
  String selectedDate = "", formatDate = "";
  String slcPackHouse = "",
      slcReceivedUnit = "",
      slcBlock = "",
      product = "",
      productID = "",
      variety = "",
      varietyID = "",
      totalTransferredWeight = "",
      totalWeight = "",
      deliveryNote = "",
      receptionBatchNo = "",
      farmerName = "",
      farmName = "",
      farmerId = "",
      farmId = "",
      batchNumber = "",
      packHouseName = "",
      packHouseID = "",
      stateCode = "",
      stateName = "";
  String slcValue = "";
  String getDateValue = "";
  String valPackHouse = "", valBlock = "", valReceivedUnit = "";
  String slcSortingID = "", valSortingID = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  double receivedWeight = 0.0;
  double transferWeight = 0.0;
  double currentWeightValue = 0.0;
  double lossValue = 0.0;
  int numberOfUnits = 0;
  double totalWtValue = 0.0;
  double initialTotalWeight = 0.0;
  String slcPlanting = "", valPlanting = "";
  String lossWeight = "";

  List<UImodel> truckListUIModel = [];
  final List<DropdownMenuItem> truckDropdownItem = [];
  String slctTruckTyp = "", valTruckTyp = "" ,truckTypeName ='';

  bool dataLoaded = false;
  bool existData=false;
  DateTime? selectedDateTime;
  List<MultiplePrintModel> multipleprintLists = [];
  String getBlockId = "", getBlockName = "", stockID = "";
  String exportedID = "";
  String exporterName = "";
  String qrExportedID = "";
  List<DropdownMenuItem> packHouseDropdown = [];
  List<DropdownModel> blockDropdown = [];
  List<DropdownMenuItem> receivedUnitDropdown = [];
  List<UImodel> packHouseUiModel = [];
  List<UImodel> blockUiModel = [];
  List<UImodel> receivedUnitUiModel = [];
  List<UImodel> plantingUIModel = [];
  List<UImodel> sortingIDUIModel = [];
  List<IncomingShipmentList> incomingShipmentList = [];
  List<IncomingShipmentList> incomingQRList = [];
  List<ListAdd> blockIDSortingList = [];
  List<ListAdd> plantingIDList = [];
  List<ListAdd> sortingIDList = [];
  DropdownModel? blockSelect;
  List<DropdownModel> plantingItems = [];
  DropdownModel? slctPlanting;
  List<DropdownModel> sortingIDItems = [];
  DropdownModel? selectSortingID;

  bool blockLoaded = false, receivedUnitLoaded = false;
  bool validDate = false;
  bool plantingLoaded = false;
  bool weightCalculated = false;

  List checkOrderList =[];
  TextEditingController receivedWeightController = TextEditingController();
  TextEditingController transferWeightController = TextEditingController();
  TextEditingController numberOfUnitController = TextEditingController();
  TextEditingController truckTypeController = TextEditingController();
  TextEditingController truckNumberController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController driverContactController = TextEditingController();

  var Qr = [];
  String pCode = "",
      actWt = "",
      sortWt = "",
      pName = "",
      vCode = "",
      vName = "",
      slcblock = "",
      farmerVal = "",
      farmer = "",
      farmVal = "",
      farm = "",
      countyCode = "",
      countyName = "",

      blockID = "";
    bool stockType = false;
  String Qrvalue = "";
  int count = 0;
  String qrIdGeneration="";
  int countQR=0;
  String idGeneration="";

  String uom="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //blockNumber();
    // packHouse();
    receivedUnits();
    getClientData();
    getLocation();
    loadtruck();


    Random random = Random();
    int revNumber = 100000 + random.nextInt(999999 - 100000);
    qrIdGeneration=revNumber.toString();



    final now = DateTime.now();
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    receptionBatchNo = msgNo;

    receivedWeightController.addListener(() {
      lossWeight == "";
      weightCalculation();
    });
    /*  transferWeightController.addListener(() {
      receivedWeightController.text = "";
      lossWeight = "";
      weightCalculation();
    })*/


    numberOfUnitController.addListener(() {
      setState(() {
        numberOfUnits = int.parse(numberOfUnitController.text);
      });
    });

    driverContactController.addListener(() {
      driverNote();
    });
    truckNumberController.addListener(() {
      driverNote();
    });
    driverNameController.addListener(() {
      driverNote();
    });
    // truckTypeController.addListener(() {
    //   driverNote();
    // });
  }

  void weightCalculation() {
    setState(() {
      if (receivedWeightController.text.isNotEmpty) {
        var weight = receivedWeightController.text;
        double num1 = double.parse((weight));
        receivedWeight = num1;
        print("aaaaa" + receivedWeight.toString());
        if (totalTransferredWeight.isNotEmpty) {
          print("bbbbb" + totalTransferredWeight.toString());
          double weight = double.parse(totalTransferredWeight);
          totalWtValue = weight;
        }

        setState(() {
          lossValue = totalWtValue - receivedWeight;
          String total = lossValue.toStringAsFixed(3).toString();
          lossWeight = total.toString();
        });
      }
    });
  }

  void driverNote() {
    String truckNumber = truckNumberController.text;
    String truckType = truckTypeName;
    String driverName = driverNameController.text;
    String driverContact = driverContactController.text;
    if (truckNumber.isNotEmpty &&
        driverName.isNotEmpty &&
        driverContact.isNotEmpty &&
        truckType.isNotEmpty) {
      String space = '/';
      setState(() {
        deliveryNote = "Truck Type  :" +
            " " +
            truckType +
            "\n" +
            "Number Plate :" +
            " " +
            truckNumber +
            " " +
            "\n" +
            "Driver Name  :" +
            " " +
            driverName +
            "\n" +
            "Driver Contact  :" +
            " " +
            driverContact +
            "\n" +
            "Total Weight  :" +
            " " +
            totalWeight;
      });
    }
  }

/*  void driverNote() {
    String truckNumber = truckNumberController.text;
    String truckType = truckTypeController.text;
    String driverName = driverNameController.text;
    String driverContact = driverContactController.text;
    if (truckNumber.length > 0 &&
        driverName.length > 0 &&
        driverContact.length > 0 &&
        truckType.length > 0) {
      String space = '/';
      setState(() {
        deliveryNote = truckType +
            space +
            truckNumber +
            space +
            driverName +
            space +
            driverContact +
            space +
            totalWeight;
      });
    }
  }*/

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    packHouseID = agents[0]['packHouseId'];
    packHouseName = agents[0]['packHouseName'];
    exportedID = agents[0]["exporterId"].toString();
    exporterName = agents[0]['exporterName'];
  }
  loadtruck() async {
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "91" + '\'';
    List insList = await db.RawQuery(qryInslist);

    truckListUIModel = [];
    truckDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      truckListUIModel.add(uimodel);
      setState(() {
        truckDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
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
          title: Text('Incoming Shipment',
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

  Future<void> loadQrIds() async {
    checkOrderList.clear();
    String qryBlockNumber =
        'select distinct qrUniqId from villageWarehouse where  blockName!="" and  stockType=1 and lastHarDate<=\'' +
            formatDate +
            '\'';

    print("qryBlockNumber" + qryBlockNumber.toString());
    List blockNumberList = await db.RawQuery(qryBlockNumber);

    print("blockNumberList" + blockNumberList.toString());


    for (int i = 0; i < blockNumberList.length; i++) {
      String qrID = blockNumberList[i]["qrUniqId"].toString();
      checkOrderList.add(qrID);
    }
    print("checkOrderList" + checkOrderList.toString());

  }


  Future<void> blockNumber() async {
    String qryBlockNumber =
        'select distinct blockId,blockName from villageWarehouse where  blockName!="" and  stockType=1 and lastHarDate<=\'' +
            formatDate +
            '\'';

    print("qryBlockNumber" + qryBlockNumber.toString());
    List blockNumberList = await db.RawQuery(qryBlockNumber);

    print("blockNumberList" + blockNumberList.toString());

    blockUiModel = [];
    blockDropdown = [];
    blockDropdown.clear();
    blockIDSortingList.clear();

    for (int i = 0; i < blockNumberList.length; i++) {
      String propertyValue = blockNumberList[i]["blockName"].toString();
      String dispSEQ = blockNumberList[i]["blockId"].toString();

      /*  setState(() {
        var getBlockNameID = ListWithDate(dispSEQ, propertyValue, lastHarDate);
        blockIDSortingList.add(getBlockNameID);
      });*/
      setState(() {
        var getBlockNameID = ListAdd(dispSEQ, propertyValue);
        blockIDSortingList.add(getBlockNameID);
      });
    }


    for (int i = 0; i < blockIDSortingList.length; i++) {
      String blockName = blockIDSortingList[i].name;
      String blockId = blockIDSortingList[i].value;
      var uimodel = UImodel(blockName, blockId);
      blockUiModel.add(uimodel);
      setState(() {
        blockDropdown.add(DropdownModel(
          blockName,
          blockId,
        ));
      });
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        blockLoaded = true;
      });
    });
  }

  Future<void> blockNumberCheck() async {
    bool block = false;
    bool blockExit = false;
    for (int i = 0; i < blockIDSortingList.length; i++) {
      if (blockIDSortingList[i].value == getBlockId) {
        blockExit = true;
      }
    }
    if (!blockExit) {
      for (int i = 0; i < blockIDSortingList.length; i++) {
        if (getBlockId != "" && getBlockName != "") {
          setState(() {
            block = true;
          });
        }
      }
    }
    if (blockIDSortingList.isNotEmpty) {
      if (block) {
        var getBlock = ListAdd(getBlockId, getBlockName);
        blockIDSortingList.add(getBlock);

        var uimodel = UImodel(
          getBlockName,
          getBlockId,
        );
        blockUiModel.add(uimodel);
        setState(() {
          blockDropdown.add(DropdownModel(getBlockName, getBlockId));
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

        var uimodel = UImodel(slcPlanting, valPlanting);
        plantingUIModel.add(uimodel);
        setState(() {
          plantingItems.add(DropdownModel(slcPlanting, valPlanting));
        });
      }
    }
  }

  Future<void> sortingIdIDValueCheck() async {
    bool sortingID = false;
    bool sortingIdExist = false;
    for (int i = 0; i < sortingIDList.length; i++) {
      if (sortingIDList[i].value == valSortingID) {
        sortingIdExist = true;
      }
    }
    if (!sortingIdExist) {
      for (int i = 0; i < sortingIDList.length; i++) {
        if (slcSortingID != "" && valSortingID != "") {
          setState(() {
            sortingID = true;
          });
        }
      }
    }
    if (sortingIDList.isNotEmpty) {
      if (sortingID) {
        var getValue = ListAdd(valSortingID, slcSortingID);
        sortingIDList.add(getValue);

        var uimodel = UImodel(slcSortingID, valSortingID);
        sortingIDUIModel.add(uimodel);
        setState(() {
          sortingIDItems.add(DropdownModel(slcSortingID, valSortingID));
        });
      }
    }
  }

  Future<void> batchDetail(String sortingId) async {
    String qryBlockDetail =
        'select countyCode,countyName,stockType,batchNo,farmerId,farmId,farmerName,farmName,batchNo,actWt,pCode,pName,vCode,vName,blockId from villageWarehouse where actWt>0 and stockType=1 and plantingId=\'' +
            valPlanting +
            '\' and batchNo=\'' +
            sortingId +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';

    print("qryBlockDetail" + qryBlockDetail.toString());

    List blockDetail = await db.RawQuery(qryBlockDetail);
    print("blockDetail_blockDetail" + blockDetail.toString());

    for (int i = 0; i < blockDetail.length; i++) {
      String actWt = blockDetail[i]["actWt"].toString();
      String pCode = blockDetail[i]["pCode"].toString();
      String pName = blockDetail[i]["pName"].toString();
      String vCode = blockDetail[i]["vCode"].toString();
      String vName = blockDetail[i]["vName"].toString();
      String farmer = blockDetail[i]["farmerName"].toString();
      String farm = blockDetail[i]["farmName"].toString();
      String farmerVal = blockDetail[i]["farmerId"].toString();
      String farmVal = blockDetail[i]["farmId"].toString();
      String countyCode = blockDetail[i]["countyCode"].toString();
      String countyName = blockDetail[i]["countyName"].toString();

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
        productID = pCode;
        varietyID = vCode;
        totalTransferredWeight = actWt;
        farmName = farm;
        farmerName = farmer;
        farmerId = farmerVal;
        farmId = farmVal;
        stateCode = countyCode;
        stateName = countyName;
      });
    }
  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select distinct plantingId from villageWarehouse where stockType=1 and  blockId=\'' +
            blockID +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';
    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
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

  void sortingIdSearch(String plantingId) async {
    String sortingIdQRy =
        'select distinct batchNo from villageWarehouse where stockType=1 and  plantingId=\'' +
            plantingId +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\'';

    List sortingIDList = await db.RawQuery(sortingIdQRy);
    sortingIDUIModel = [];
    sortingIDItems = [];
    sortingIDItems.clear();
    for (int i = 0; i < sortingIDList.length; i++) {
      String sortingId = sortingIDList[i]["batchNo"].toString();

      var uiModel = UImodel(sortingId, sortingId);
      sortingIDUIModel.add(uiModel);
      setState(() {
        sortingIDItems.add(DropdownModel(
          sortingId,
          sortingId,
        ));
      });
    }
  }

  Future<void> receivedUnits() async {
    String qryReceivedUnit =
        'select distinct * from animalCatalog where catalog_code =\'' +
            "82" +
            '\'';
    List receivedUnitList = await db.RawQuery(qryReceivedUnit);

    receivedUnitUiModel = [];
    receivedUnitDropdown = [];
    receivedUnitDropdown.clear();

    for (int i = 0; i < receivedUnitList.length; i++) {
      String propertyValue = receivedUnitList[i]["property_value"].toString();
      String dispSEQ = receivedUnitList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(propertyValue, dispSEQ);
      receivedUnitUiModel.add(uimodel);
      setState(() {
        receivedUnitDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        receivedUnitLoaded = true;
        slcReceivedUnit = "";
      });
    });
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
        .add(txt_label_mandatory("Offloading Date", Colors.black, 14.0, false));
    if (incomingShipmentList.isEmpty) {
      listings.add(selectDate(
          context1: context,
          slctdate: selectedDate,
          onConfirm: (date) => setState(
                () {
                  selectedDate = DateFormat('dd-MM-yyyy').format(date);
                  formatDate = DateFormat('yyyy-MM-dd').format(date);
                  blockSelect = null;
                  blockDropdown = [];
                  valBlock = '';
                  slcBlock = '';
                  product = "";
                  variety = "";
                  totalTransferredWeight = "";
                  blockID = "";
                  plantingLoaded = false;
                  plantingItems = [];
                  slcPlanting = "";
                  valPlanting = "";
                  slctPlanting = null;
                  selectSortingID = null;
                  slcSortingID = "";
                  valSortingID = "";
                  sortingIDItems = [];
                  weightCalculated = false;
                  receivedWeightController.text = "";
                  lossWeight = "";
                  blockNumber();
                  loadQrIds();
                  incomingDateComparison(date);
                  selectedDateTime = date;
                },
              )));
    } else {
      listings.add(cardlable_dynamic(selectedDate.toString()));
    }

    listings.add(txt_label_mandatory("Packhouse", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(packHouseName.toString()));

/*    listings.add(singlesearchDropdown(
      itemlist: packHouseDropdown,
      selecteditem: slcPackHouse,
      hint: "Select packhouse",
      onChanged: (value) {
        setState(() {
          slcPackHouse = value!;
          for (int i = 0; i < packHouseUiModel.length; i++) {
            if (value == packHouseUiModel[i].name) {
              valPackHouse = packHouseUiModel[i].value;
            }
          }
        });
      },
    ));*/

    listings.add(
        txt_label_mandatory("Reception Batch No ", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(receptionBatchNo.toString()));

    listings.add(blockLoaded
        ? txt_label_mandatory("Block Name", Colors.black, 16.0, false)
        : Container());

    listings.add(DropDownWithModel(
      itemlist: blockDropdown,
      selecteditem: blockSelect,
      hint: "Select Block Name",
      onChanged: (value) {
        setState(() {
          blockSelect = value!;
          product = "";
          variety = "";
          totalTransferredWeight = "";
          blockID = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          receivedWeightController.text = "";
          lossWeight = "";
          slctPlanting = null;
          selectSortingID = null;
          slcSortingID = "";
          valSortingID = "";
          weightCalculated = false;
          sortingIDItems = [];
          print("blockSelect_blockSelect" + blockSelect!.name.toString());

          valBlock = blockSelect!.value;
          slcBlock = blockSelect!.name;
          blockID = valBlock;
          plantingIdSearch(valBlock);
          /*  for (int i = 0; i < blockUiModel.length; i++) {
            if (valBlock == blockUiModel[i].value) {
              getDateValue = blockUiModel[i].value2;
             incomingDateComparison(selectedDateTime!);
            }
          }*/
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
            String sortingValue = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScanner()));
            print("sortingValue" + sortingValue.toString());

            getSortingDetail(sortingValue);
            setState(() {
              slcValue = sortingValue;
            });
          }else{
            String sortingValue = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScannerAndroid()));
            print("sortingValue" + sortingValue.toString());

            getSortingDetail(sortingValue);
            setState(() {
              slcValue = sortingValue;
            });
          }

        }));

    listings.add(blockLoaded
        ? txt_label_mandatory("Block Id", Colors.black, 16.0, false)
        : Container());
    listings
        .add(blockLoaded ? cardlable_dynamic(blockID.toString()) : Container());

    listings.add(txt_label_mandatory("Planting ID", Colors.black, 14.0, false));
    listings.add(DropDownWithModel(
      itemlist: plantingItems,
      selecteditem: slctPlanting,
      hint: "Select Planting ID",
      onChanged: (value) {
        setState(() {
          slctPlanting = value!;
          product = "";
          variety = "";
          selectSortingID = null;
          slcSortingID = "";
          valSortingID = "";
          weightCalculated = false;
          sortingIDItems = [];
          receivedWeightController.text = "";
          lossWeight = "";
          totalTransferredWeight = "";
          valPlanting = slctPlanting!.value;
          slcPlanting = slctPlanting!.name;
          sortingIdSearch(valPlanting);
          //   batchDetail(valPlanting);
        });
      },
    ));

    listings.add(txt_label_mandatory("Sorting Id", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: sortingIDItems,
      selecteditem: selectSortingID,
      hint: "Select Sorting ID",
      onChanged: (value) {
        setState(() {
          selectSortingID = value!;
          product = "";
          variety = "";
          weightCalculated = false;
          totalTransferredWeight = "";
          receivedWeightController.text = "";
          lossWeight = "";
          valSortingID = selectSortingID!.value;
          slcSortingID = selectSortingID!.name;
          batchDetail(valSortingID);
        });
      },
    ));

    listings.add(txt_label_mandatory("Crop Name ($uom)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(product.toString()));

    listings.add(txt_label_mandatory("Variety", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(variety.toString()));

    listings.add(txt_label_mandatory(
        "Transferred Weight (kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(totalTransferredWeight.toString()));

    /* listings.add(
        txt_label_mandatory("Transfer Weight (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Transfer Weight (Kg)", transferWeightController, true, 60));*/

    listings.add(
        txt_label_mandatory("Received Weight (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Received Weight (Kg)", receivedWeightController, true, 60));

    listings.add(
        txt_label_mandatory("Loss Weight (kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(lossWeight.toString()));

    listings.add(receivedUnitLoaded
        ? txt_label_mandatory("Received Units", Colors.black, 16.0, false)
        : Container());
    listings.add(receivedUnitLoaded
        ? singlesearchDropdown(
            itemlist: receivedUnitDropdown,
            selecteditem: slcReceivedUnit,
            hint: "Select Received Units",
            onChanged: (value) {
              setState(() {
                slcReceivedUnit = value!;
                for (int i = 0; i < receivedUnitUiModel.length; i++) {
                  if (value == receivedUnitUiModel[i].name) {
                    valReceivedUnit = receivedUnitUiModel[i].value;
                  }
                }
              });
            },
          )
        : Container());

    listings
        .add(txt_label_mandatory("Number of Units", Colors.black, 16.0, false));
    listings.add(txtfield_digits_integer(
        "Number of Units", numberOfUnitController, true, 20));

    listings.add(btn_dynamic(
        label: "Add",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          bool blockAdded = false;
          bool blockPlantingAdded=false;
          if (incomingShipmentList.isNotEmpty) {
            for (int i = 0; i < incomingShipmentList.length; i++) {
              if (valPlanting == incomingShipmentList[i].plantingID &&
                  valSortingID == incomingShipmentList[i].sortingId) {
                setState(() {
                  blockAdded = true;
                });
              }
                  if (incomingShipmentList[i].blockId.contains(valBlock) &&
                      incomingShipmentList[i].plantingID.contains(valPlanting)) {
                       idGeneration=incomingShipmentList[i].qrIdValue;
                      setState(() {
                        blockPlantingAdded=true;
                      });
                  }
            }
          }


          bool validWeight = true;
          if (receivedWeightController.text.isNotEmpty) {
            if (receivedWeight <= 0) {
              validWeight = false;
            } else if (receivedWeightController.text.contains('.')) {
              List<String> value = receivedWeightController.text.split(".");
              if (value[1].isNotEmpty) {
                setState(() {
                  validWeight = true;
                });
              } else {
                validWeight = false;
              }
            } else {
              validWeight = true;
            }
          }

          if (slcBlock.isEmpty) {
            alertPopup(context, "Block Name should not be empty");
          } else if (slcPlanting.isEmpty) {
            alertPopup(context, "Planting ID should not be empty");
          } else if (slcSortingID.isEmpty) {
            alertPopup(context, "Sorting ID should not be empty");
          } else if (receivedWeightController.text.isEmpty) {
            alertPopup(context, "Received Weight (Kg) should not be empty");
          } else if (!validWeight) {
            alertPopup(context, "Invalid Received Weight (Kg)");
          } else if (receivedWeight > totalWtValue) {
            alertPopup(context,
                "Received Weight (Kg) should not be greater than Transfer Weight (Kg)");
          } else if (slcReceivedUnit.isEmpty) {
            alertPopup(context, "Received Units should not be empty");
          } else if (numberOfUnitController.text.isEmpty) {
            alertPopup(context, "Number of Units should not be empty");
          } else if (numberOfUnits <= 0) {
            alertPopup(context, "Number of Units should be greater than Zero");
          } else if (blockAdded) {
            alertPopup(
                context, "Planting ID already exists for this Sorting ID");
            setState(() {
              slcBlock = "";
              blockSelect = null;
              product = "";
              variety = "";
              totalTransferredWeight = "";
              receivedWeightController.text = "";
              slcReceivedUnit = "";
              numberOfUnitController.text = "";
              blockID = "";
              slctPlanting = null;
              slcPlanting = "";
              valPlanting = "";
              lossWeight = "";
              weightCalculated = false;
              selectSortingID = null;
              slcSortingID = "";
              valSortingID = "";


            });
          } else {
            if(!blockPlantingAdded){
              int countQR = incomingShipmentList.length;
              idGeneration = qrIdGeneration+ countQR.toString();
            }
            var shipmentList = IncomingShipmentList(
                valBlock,
                slcBlock,
                product,
                productID,
                variety,
                varietyID,
                totalTransferredWeight,
                receivedWeightController.text,
                slcReceivedUnit,
                valReceivedUnit,
                numberOfUnitController.text,
                farmerId,
                farmerName,
                farmId,
                farmName,
                receptionBatchNo,
                stateCode,
                stateName,
                getDateValue,
                valPlanting,
                lossWeight,
                valSortingID,
                idGeneration);
            setState(() {
              incomingShipmentList.add(shipmentList);
            });

            for (int i = 0; i < incomingShipmentList.length; i++) {
              double getTotalShipment =
                  double.parse(incomingShipmentList[i].recWeight);
              initialTotalWeight = getTotalShipment + initialTotalWeight;
              String totalVal = initialTotalWeight.toString();
              double num1 = double.parse((totalVal));
              String total = num1.toStringAsFixed(2).toString();
              setState(() {
                totalWeight = total;
              });
              print("KKKKKKKKKKKK"+incomingShipmentList[i].qrIdValue);



            }
            getIncomingData();
            setState(() {
              slcBlock = "";
              blockSelect = null;
              product = "";
              variety = "";
              totalTransferredWeight = "";
              receivedWeightController.text = "";
              transferWeightController.text = "";
              lossWeight = "";
              slcReceivedUnit = "";
              numberOfUnitController.text = "";
              initialTotalWeight = 0.0;
              blockID = "";
              slctPlanting = null;
              slcPlanting = "";
              selectSortingID = null;
              slcSortingID = "";
              valSortingID = "";
              weightCalculated = false;
            });

          }
        }));

    if (incomingShipmentList.isNotEmpty) {
      listings.add(incomingShipmentDataTable());
    }

    listings.add(
        txt_label_mandatory("Total Weight (Kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(totalWeight.toString()));

    listings.add(txt_label_mandatory("Truck Type", Colors.black, 16.0, false));
    listings.add(singlesearchDropdown(
      itemlist: truckDropdownItem,
      selecteditem: slctTruckTyp,
      hint: "Select Truck type",
      onChanged: (value) {
        setState(() {
          slctTruckTyp = value!;
          for (int i = 0; i < truckListUIModel.length; i++) {
            if (value == truckListUIModel[i].name) {
              valTruckTyp = truckListUIModel[i].value;
              truckTypeName = truckListUIModel[i].name;


            }
          }
          driverNote();
        });
      },
    ));
    listings
        .add(txt_label_mandatory("Number Plate", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Number Plate", truckNumberController, true, 20));

    listings.add(txt_label_mandatory("Driver Name", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Driver Name", driverNameController, true, 20));

    listings
        .add(txt_label_mandatory("Driver Contact", Colors.black, 16.0, false));
    listings.add(txtfield_digits_integer(
        "Driver Contact", driverContactController, true, 20));

    listings
        .add(txt_label_mandatory("Delivery Note", Colors.black, 16.0, false));
    listings.add(cardlable_dynamicLarge(deliveryNote.toString()));

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

  void getIncomingData(){
    if(incomingShipmentList.isNotEmpty) {
      double getWt= 0.0;
      for (int p = 0; p < incomingShipmentList.length; p++) {
        if (incomingShipmentList[p].plantingID.contains(valPlanting)) {
          if (incomingShipmentList[p].blockId.contains(valBlock)) {
            String  block =incomingShipmentList[p].blockId;
            String  blockName=incomingShipmentList[p].blockName;
            String product=incomingShipmentList[p].productId;
            String productName=incomingShipmentList[p].product;
            String variety=incomingShipmentList[p].variety;
            String varietyName=incomingShipmentList[p].varietyId;
            String totalTransferredWeight=incomingShipmentList[p].trfWeight;
            String receivedWeight=incomingShipmentList[p].recWeight;
            String receivedUnit=incomingShipmentList[p].recUnit;
            String receivedUnitValue=incomingShipmentList[p].valRecUnit;
            String numberOfUnit=incomingShipmentList[p].numberOfUnit;
            String farmerId=incomingShipmentList[p].farmerId;
            String farmerName=incomingShipmentList[p].farmerName;
            String farmId=incomingShipmentList[p].farmId;
            String farmName=incomingShipmentList[p].farmName;
            String receptionBatchNo=incomingShipmentList[p].batchNo;
            String stateCode=incomingShipmentList[p].stateCode;
            String stateName=incomingShipmentList[p].stateName;
            String getDateValue=incomingShipmentList[p].getDate;
            String plantingID=incomingShipmentList[p].plantingID;
            String lossWeight=incomingShipmentList[p].lossWeight;
            String valSortingID=incomingShipmentList[p].sortingId;
            String qrIDValue=incomingShipmentList[p].qrIdValue;

            getWt=double.parse(receivedWeight)+getWt;
            print("getWt_getWt"+getWt.toString());
            setState(() {
              existData=true;
            });
            getData(block,blockName,product,productName,variety,varietyName,totalTransferredWeight,getWt.toString(),receivedUnit,receivedUnitValue,numberOfUnit,
                farmerId,farmerName,farmId,farmName,receptionBatchNo,stateCode,stateName,getDateValue,plantingID,lossWeight,valSortingID,qrIDValue);
          }
        }
      }
    }
  }

  void getData(String block, String blockName, String product,String productName, String variety, String varietyName, String totalTransferredWeight,String receivedWeight, String receivedUnit, String receivedUnitValue, String numberOfUnit, String farmerId, String farmerName, String farmId, String farmName, String receptionBatchNo, String stateCode,String stateName, String getDateValue, String plantingID, String lossWeight, String valSortingID,String qrIDValue) {

    if (incomingQRList.isNotEmpty) {
      for (int t = 0; t < incomingQRList.length; t++) {
        if (incomingQRList[t].blockId.contains(block) &&
            incomingQRList[t].plantingID.contains(plantingID)) {
          incomingQRList.removeAt(t);
        }

      }
    }
    if (existData) {
  setState(() {
    var getValue=  IncomingShipmentList(block, blockName, productName, product, varietyName, variety, totalTransferredWeight, receivedWeight, receivedUnit, receivedUnitValue, numberOfUnit, farmerId, farmerName, farmId, farmName, batchNumber, stateCode, stateName, getDateValue, plantingID, lossWeight, valSortingID,qrIDValue);
    incomingQRList.add(getValue);
  });

    }
  }


  void incomingDateComparison(DateTime incomingDate) async {
    print("getDateValue_getDateValue" + getDateValue.toString());
    if (getDateValue != "") {
      String dateValue = getDateValue;
      String trimmedDate = dateValue.substring(0, 10);

      DateTime convertIncomingDate = incomingDate;
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
      print("convertIncomingDate" + convertIncomingDate.toString());

      DateTime valEnd = convertIncomingDate;
      bool valDate = convertDate.isBefore(valEnd);
      bool sameDate = convertIncomingDate.isAtSameMomentAs(convertDate);
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

  Future<void> getSortingDetail(String sortingValue) async {
    dataLoaded = true;
    try {
      List<String> splitList = sortingValue.split('~');
      print("splitList_splitList" + splitList.toString());
      print("splitList_length" + splitList.length.toString());
      String pCode = splitList[5].toString().trim();
      String uomCode =
          'select hsCode from varietyList where vName =\'' +
              pCode +
              '\'';

      print("uomCode" + uomCode.toString());

      List uomList = await db.RawQuery(uomCode);
      print("uomList" + uomList.toString());

      if (splitList.length == 18) {
        setState(() {
          stateCode = splitList[0].toString().trim();
          stateName = splitList[1].toString().trim();
          valBlock = splitList[2].toString().trim();
          blockID = splitList[2].toString().trim();
          slcBlock = splitList[3].toString().trim();
          productID = splitList[4].toString().trim();
          product = splitList[5].toString().trim();
          uom = uomList[0]['hsCode'].toString();
          varietyID = splitList[6].toString().trim();
          variety = splitList[7].toString().trim();
          totalTransferredWeight = splitList[8].toString().trim();
          farmerId = splitList[9].toString().trim();
          farmerName = splitList[10].toString().trim();
          farmId = splitList[11].toString().trim();
          farmName = splitList[12].toString().trim();
          stockID = splitList[13].toString().trim();

          qrExportedID = splitList[14].toString().trim();
          getDateValue = splitList[15].toString().trim();
          valPlanting = splitList[16].toString().trim();
          slcPlanting = splitList[16].toString().trim();
          slcSortingID = splitList[17].toString().trim();
          valSortingID = splitList[17].toString().trim();
          getBlockName = slcBlock;
          getBlockId = valBlock;
          blockSelect = DropdownModel(slcBlock, valBlock);
          slctPlanting = DropdownModel(slcPlanting, valPlanting);
          selectSortingID = DropdownModel(slcSortingID, valSortingID);
        });

        if (selectedDate.isNotEmpty) {
          incomingDateComparison(selectedDateTime!);
        }
        print("qrExportedID_qrExportedID" + qrExportedID.toString());
        print("exportedID" + exportedID.toString());
        print("valSortingID" + valSortingID.toString());
        if (qrExportedID == exportedID) {
          if (selectedDate.isNotEmpty) {
            if (validDate) {
              if (stockID == "1" && checkOrderList.contains(valSortingID) ) {
                blockNumberCheck();
                plantingIDValueCheck();
                sortingIdIDValueCheck();
              } else {
                alertPopup(context, "Invalid QR code");
                clearData();
              }
            } else {
              alertPopup(context, 'Invalid Offloading Date');
              clearData();
            }
          } else {
            alertPopup(context, "Select Offloading Date Before Scan");
            clearData();
          }
        } else {
          alertPopup(context,
              "The Crop Name belongs to another exporter so you are not allowed to scan");
          clearData();
        }
      } else {
        alertPopup(context, "Invalid QR code");
        clearData();
      }
    } catch (e) {
      alertPopup(context, "Invalid QR  code");
      clearData();
    }
  }

  void clearData() {
    setState(() {
      slcBlock = "";
      blockSelect = null;
      product = "";
      variety = "";
      totalTransferredWeight = "";
      receivedWeightController.text = "";
      slcReceivedUnit = "";
      numberOfUnitController.text = "";
      blockID = "";
      plantingItems = [];
      slcPlanting = "";
      valPlanting = "";
      slctPlanting = null;
    });
  }

  void btnSubmit() {
    if (selectedDate.isEmpty) {
      alertPopup(context, "Offloading Date should not be empty");
    } else if (incomingShipmentList.isEmpty) {
      alertPopup(context, "Add Atleast one PackHouse List");
    } else if (valTruckTyp.isEmpty) {
      alertPopup(context, "Truck Type should not be empty");
    } else if (truckNumberController.text.isEmpty) {
      alertPopup(context, "Number Plate should not be empty");
    } else if (driverNameController.text.isEmpty) {
      alertPopup(context, "Driver Name should not be empty");
    } else if (driverContactController.text.isEmpty) {
      alertPopup(context, "Driver Contact should not be empty");
    } else {
      confirmation();
    }
  }

  Widget incomingShipmentDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Block Id')));
    columns.add(DataColumn(label: Text('Planting ID ')));
    columns.add(DataColumn(label: Text('Sorting Id')));
    columns.add(DataColumn(label: Text('Received Weight (Kg)')));
    columns.add(DataColumn(label: Text('Loss Weight (kg)')));
    columns.add(DataColumn(label: Text('Received Units')));
    columns.add(DataColumn(label: Text('Number of Units')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < incomingShipmentList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(incomingShipmentList[i].blockId)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].plantingID)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].sortingId)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].recWeight)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].lossWeight)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].recUnit)));
      singlecell.add(DataCell(Text(incomingShipmentList[i].numberOfUnit)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            incomingShipmentList.removeAt(i);
            getIncomingData();
            countQR=countQR-1;

          });
          double initialTotalWeight = 0.0;
          if (incomingShipmentList.isNotEmpty) {
            for (int i = 0; i < incomingShipmentList.length; i++) {
              double getTotalShipment =
                  double.parse(incomingShipmentList[i].recWeight);
              initialTotalWeight = getTotalShipment + initialTotalWeight;
              String totalVal = initialTotalWeight.toString();
              double num1 = double.parse((totalVal));
              String total = num1.toStringAsFixed(2).toString();
              setState(() {
                totalWeight = total;
              });
            }
          } else {
            initialTotalWeight = 0.0;
            totalWeight = "0.0";
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
            saveIncomingShipment();
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

  Future<void> saveIncomingShipment() async {
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
        txntime, datas.txnIncomingShipment, revNo.toString(), '', '', '');

    int saveReception = await db.saveProductReception(
        formatDate,
        packHouseID,
        totalWeight,
        valTruckTyp,
        truckNumberController.text.toString(),
        driverNameController.text.toString(),
        driverContactController.text.toString(),
        deliveryNote,
        "1",
        seasonCode,
        revNo.toString(),
        receptionBatchNo);
    print(saveReception);

    if (incomingShipmentList.isNotEmpty) {
      for (int i = 0; i < incomingShipmentList.length; i++) {
        int position = i + 1;
        String idGeneration = revNo.toString() + position.toString();
        int saveReceptionDetail = await db.saveProductReceptionDetail(
            incomingShipmentList[i].blockId,
            incomingShipmentList[i].productId,
            incomingShipmentList[i].varietyId,
            incomingShipmentList[i].trfWeight,
            incomingShipmentList[i].recWeight,
            incomingShipmentList[i].valRecUnit,
            incomingShipmentList[i].numberOfUnit,
            revNo.toString(),
            incomingShipmentList[i].blockName,
            incomingShipmentList[i].product,
            incomingShipmentList[i].variety,
            incomingShipmentList[i].farmerId,
            incomingShipmentList[i].farmerName,
            incomingShipmentList[i].farmId,
            incomingShipmentList[i].farmName,
            incomingShipmentList[i].batchNo,
            incomingShipmentList[i].stateCode,
            incomingShipmentList[i].stateName,
            incomingShipmentList[i].plantingID,
            incomingShipmentList[i].lossWeight,
            incomingShipmentList[i].qrIdValue,
            incomingShipmentList[i].sortingId);
        print(saveReceptionDetail);
        print("Finally" +
            incomingShipmentList[i].qrIdValue);
      }
    }

    print("incomingShipmentListbatchNo" + incomingShipmentList[0].batchNo);

    await db.UpdateTableValue(
        'productReception', 'isSynched', '0', 'recNo', revNo.toString());

    print('revNo_revNo' + revNo.toString());

    TxnExecutor txnExecutor = TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();
    int count = 0;
    for (int i = 0; i < incomingQRList.length; i++) {
      int position = i + 1;
      String idGeneration = revNo.toString() + position.toString();
      count = i;

      Qrvalue =
          receptionBatchNo +
          "~" +
          incomingQRList[i].stateCode +
          "~" +
          incomingQRList[i].stateName +
          "~" +
          incomingQRList[i].blockId +
          "~" +
          incomingQRList[i].blockName +
          "~" +
          incomingQRList[i].productId +
          "~" +
          incomingQRList[i].product +
          "~" +
          incomingQRList[i].varietyId +
          "~" +
          incomingQRList[i].variety +
          "~" +
          incomingQRList[i].recWeight +
          "~" +
          incomingQRList[i].farmerId +
          "~" +
          incomingQRList[i].farmerName +
          "~" +
          incomingQRList[i].farmId +
          "~" +
          incomingQRList[i].farmName +
          "~" +
          "2" +
          "~" +
          exportedID +
          "~" +
          formatDate +
          "~" +
          packHouseID +
          "~" +
          incomingQRList[i].plantingID +
          "~" +
          incomingQRList[i].qrIdValue;
      print("Received" + incomingQRList[i].qrIdValue);

      Qr.add(Qrvalue);



    }

    int QrNum = count + 1;
    String get = Qr.toString();

    String Array = get.replaceAll("[", " ");
    String QrEdited = Array.replaceAll("]", " ");

    //get.replaceAll("[", " ");
    //get.replaceAll("]", " ");

    print("final" + QrEdited);

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Incoming Shipment done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {

            for (int k = 0; k < incomingQRList.length; k++) {
              var printList=[];
              List<PrintModel> printLists = [];
              printLists.add(PrintModel("Batch Number", receptionBatchNo));
              printLists
                  .add(PrintModel("Block ID", incomingQRList[k].blockId));
              printLists.add(PrintModel(
                  "Planting ID", incomingQRList[k].plantingID));
              printLists.add(
                  PrintModel("Crop Name", incomingQRList[k].product));
              printLists
                  .add(PrintModel("Variety", incomingQRList[k].varietyId));
              printLists.add(PrintModel(
                  "Received Qty(Kg)", incomingQRList[k].recWeight));
              printLists.add(PrintModel("Exporter Name", exporterName));
              printLists.add(PrintModel("Date and Time", txntime));
              printLists
                  .add(PrintModel("QR Unique Id", incomingQRList[k].qrIdValue));


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
                  '2',
                  txntime.split(' ')[0],
                  multipleprintLists[i].qrString.toString(),
                  removeBraces,
                    incomingQRList[k].product,
                    incomingQRList[k].plantingID
                );
              }


              if ((k + 1) == incomingQRList.length) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QrReader(multipleprintLists, 'Incoming Shipment','')));
              }
            }

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


}

class IncomingShipmentList {
  String blockId,
      blockName,
      product,
      productId,
      variety,
      varietyId,
      trfWeight,
      recWeight,
      recUnit,
      valRecUnit,
      numberOfUnit,
      farmerId,
      farmerName,
      farmId,
      farmName,
      batchNo,
      stateCode,
      stateName,
      getDate,
      plantingID,
      lossWeight,
      sortingId,
      qrIdValue;

  IncomingShipmentList(
      this.blockId,
      this.blockName,
      this.product,
      this.productId,
      this.variety,
      this.varietyId,
      this.trfWeight,
      this.recWeight,
      this.recUnit,
      this.valRecUnit,
      this.numberOfUnit,
      this.farmerId,
      this.farmerName,
      this.farmId,
      this.farmName,
      this.batchNo,
      this.stateCode,
      this.stateName,
      this.getDate,
      this.plantingID,
      this.lossWeight,
      this.sortingId,
      this.qrIdValue);
}


