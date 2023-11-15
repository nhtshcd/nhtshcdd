import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:intl/intl.dart';

import '../Model/UIModel.dart';
import '../Utils/secure_storage.dart';
import '../login.dart';

class ProductReception extends StatefulWidget {
  const ProductReception({Key? key}) : super(key: key);

  @override
  State<ProductReception> createState() => _ProductReceptionState();
}

class _ProductReceptionState extends State<ProductReception> {

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';

  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String transferFromID="",transferToID="";
  String selectedDate = "", formatDate = "";

  String productReceptionDate="",transferFrom="",transferTo="",truckNumber="",driverName="",licenseNumber="",productName="",
  productId="",varietyName="",varietyId="",transferWeight="",receiptId="";
  String valBatchID="",slcBlock="",valBlock="",valPlanting="";
  String farmerId="",farmerName="",farmID="",farmName="",stateCode="",stateName="";
  String batchNumber="";

  List<ProductReceptionModel> productReceptionList=[];

  double receivedWt=0.0;
  bool validWeight=true;
  double tWeight=0.0;

  List<UImodel> blockUiModel = [];
  List<UImodel3> plantingUiModel = [];
  List<UImodel> batchUiModel = [];
  List<UImodel> receiptUIModel = [];

  List<DropdownModel> receiptIdDropdown = [];
  DropdownModel? selectedReceipt;
  List<DropdownModel> batchDropdown = [];
  DropdownModel? selectedBatch;
  List<DropdownModel> blockDropdown = [];
  DropdownModel? selectedBlock;
  List<DropdownModel> plantingDropdown = [];
  DropdownModel? selectedPlanting;

  TextEditingController receivedWeightController=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
    getLocation();
    getReceiptId();



    final now = DateTime.now();
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    batchNumber = msgNo;


    receivedWeightController.addListener(() {
      setState(() {
        if(receivedWeightController.text.isNotEmpty){
           validWeight=textControllerValidation(receivedWeightController.text);
           receivedWt=double.parse(receivedWeightController.text);
        }
      });
    });
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];

  }


/*
  void batchNumber(String receiptId) async {
    String batchNumberQry =
        'select distinct batchNo from villageWarehouse where stockType=4';
    print("batchNumberQry" + batchNumberQry);
    List batchNumberList = await db.RawQuery(batchNumberQry);
    batchDropdown = [];
    batchUiModel = [];
    for (int i = 0; i < batchNumberList.length; i++) {
      String plantingID = batchNumberList[i]["batchNo"].toString();

      var uiModel = UImodel(plantingID, plantingID);
      batchUiModel.add(uiModel);
      setState(() {
        batchDropdown.add(DropdownModel(
          plantingID,
          plantingID,
        ));
      });
    }

  }
*/

  void plantingIdSearch(String receiptId) async {
    String plantingQry =
        'select distinct plantingId,blockId,blockName from villageWarehouse where stockType=4 and  batchNo=\'' +
            receiptId +
            '\'';
    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUiModel = [];
    plantingDropdown = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["plantingId"].toString();
      String blockId = plantingIDList[i]["blockId"].toString();
      String blockName = plantingIDList[i]["blockName"].toString();

      var uiModel = UImodel3(plantingID,plantingID,blockId,blockName);
      plantingUiModel.add(uiModel);
      setState(() {
        plantingDropdown.add(DropdownModel(
          plantingID,
          plantingID,
        ));
      });
    }

  }

 /* Future<void> blockNumber(String batchNo) async {
    String qryBlockNumber =
        'select distinct blockId,blockName from villageWarehouse where  blockName!="" and  stockType=4 and batchNo=\''+batchNo+'\'';

    print("qryBlockNumber" + qryBlockNumber.toString());
    List blockNumberList = await db.RawQuery(qryBlockNumber);

    blockUiModel = [];
    blockDropdown = [];
    blockDropdown.clear();

    for (int i = 0; i < blockNumberList.length; i++) {
      String blockName = blockNumberList[i]["blockName"].toString();
      String blockId = blockNumberList[i]["blockId"].toString();
      var uimodel = UImodel(blockName, blockId);
      blockUiModel.add(uimodel);
      setState(() {
        blockDropdown.add(DropdownModel(
          blockName,
          blockId,
        ));
      });
    }


  }*/
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
              title: Text('Product Reception',
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


  Future<void> getReceiptId() async {
    String qryReceiptID ='select distinct batchNo from villageWarehouse where stockType=4';

    print("qryReceiptID" + qryReceiptID.toString());
    List receiptList = await db.RawQuery(qryReceiptID);

    receiptUIModel = [];
    receiptIdDropdown = [];

    for (int i = 0; i < receiptList.length; i++) {
      String receiptName = receiptList[i]["batchNo"].toString();
      String receiptID = receiptList[i]["batchNo"].toString();
      var uimodel = UImodel(receiptName, receiptID);
      receiptUIModel.add(uimodel);
      setState(() {
        receiptIdDropdown.add(DropdownModel(
          receiptName,
          receiptID,
        ));
      });
    }
  }

  Future<void> getReceiptValue(String receiptId) async {
    String qryReceiptValue ='select distinct batchNo,lastHarDate,transferFrom,transferFromName,transferTo,truck,driver,licenseNo,transferToName from villageWarehouse where stockType=4 and batchNo=\''+receiptId+'\'';

    print("qryReceiptValue" + qryReceiptValue.toString());
    List receiptValueList = await db.RawQuery(qryReceiptValue);

    for (int i = 0; i < receiptValueList.length; i++) {
      String rDate = receiptValueList[i]["lastHarDate"].toString();
      String tFrom = receiptValueList[i]["transferFrom"].toString();
      String tTo = receiptValueList[i]["transferTo"].toString();
      String dName = receiptValueList[i]["driver"].toString();
      String licenseNo = receiptValueList[i]["licenseNo"].toString();
      String truckNo = receiptValueList[i]["truck"].toString();
      String transferToName = receiptValueList[i]["transferToName"].toString();
      String transferFromName = receiptValueList[i]["transferFromName"].toString();
      if(truckNo.trim()=="null"){
        truckNo="";
      }
      else if(dName.trim()=="null"){
        dName="";
      }
      else if(licenseNo.trim()=="null"){
        licenseNo="";
      }
      else if(truckNo.trim()=="null"){
        truckNo="";
      }
      else if(tFrom.trim()=="null"){
        tFrom="";
      }
      else if(transferFromName.trim()=="null"){
        transferFromName="";
      }
      else if(transferToName.trim()=="null"){
        transferToName="";
      }
      setState(() {
     productReceptionDate=rDate;
     transferToID=tTo;
     truckNumber=truckNo;
     driverName=dName;
     licenseNumber=licenseNo;
     transferTo=transferToName;
     transferFrom = transferFromName;
     transferFromID = tFrom;
   });

    }
  }

/*  getTransferToName(String transferId) async{
      String name ='select distinct coCode,coName from coOperative where coCode=\''+transferId+'\'';
      print("name_name"+name.toString());
      List nameDetail = await db.RawQuery(name);
      String codeName=nameDetail[0]["coName"].toString();
      setState(() {
        transferTo=codeName;
      });

  }*/

  Future<void> plantingDetail(String plantingId) async {
    String qryPlatingDetail =
        'select plantingId,countyCode,countyName,stockType,batchNo,farmerId,farmId,farmerName,farmName,batchNo,actWt,pCode,pName,vCode,vName,blockId from villageWarehouse where actWt>0 and stockType=4 and plantingId=\'' +
            plantingId +
            '\'';

    print("qryPlatingDetail" + qryPlatingDetail.toString());

    List plantingDetail = await db.RawQuery(qryPlatingDetail);
    print("qryPlatingDetailList" + plantingDetail.toString());

    for (int i = 0; i < plantingDetail.length; i++) {
      String actWt = plantingDetail[i]["actWt"].toString();
      String pCode = plantingDetail[i]["pCode"].toString();
      String pName = plantingDetail[i]["pName"].toString();
      String vCode = plantingDetail[i]["vCode"].toString();
      String vName = plantingDetail[i]["vName"].toString();
      String farmer = plantingDetail[i]["farmerName"].toString();
      String farm = plantingDetail[i]["farmName"].toString();
      String farmerVal = plantingDetail[i]["farmerId"].toString();
      String farmVal = plantingDetail[i]["farmId"].toString();
      String countyCode = plantingDetail[i]["countyCode"].toString();
      String countyName = plantingDetail[i]["countyName"].toString();
      setState(() {
        productName = pName;
        varietyName = vName;
        productId = pCode;
        varietyId = vCode;
        transferWeight = actWt;
        tWeight=double.parse(transferWeight);
        farmerId=farmerVal;
        farmerName=farmer;
        farmID=farmVal;
        farmName=farm;
        stateName=countyName;
        stateCode=countyCode;
      });
    }
  }



  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];


/*
    listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: selectedDate,
        onConfirm: (date) => setState(
              () {
            selectedDate = DateFormat('dd-MM-yyyy').format(date);
            formatDate = DateFormat('yyyy-MM-dd').format(date);
          },
        )));*/

    if(productReceptionList.isEmpty){
      listings.add(txt_label_mandatory("Transfer Receipt ID", Colors.black, 16.0, false));
      listings.add(DropDownWithModel(
        itemlist: receiptIdDropdown,
        selecteditem: selectedReceipt,
        hint: "Select Transfer Receipt ID",
        onChanged: (value) {
          setState(() {
            selectedReceipt = value!;
            receiptId=selectedReceipt!.name;
            receiptId=selectedReceipt!.value;
            productReceptionDate="";
            transferTo="";
            truckNumber="";
            driverName="";
            licenseNumber="";
            productName="";
            varietyName="";
            transferWeight="";
            receivedWeightController.text="";
            plantingDropdown=[];
            selectedPlanting=null;
            valPlanting="";
            blockDropdown=[];
            selectedBlock=null;
            slcBlock="";
            valBatchID="";
            batchDropdown=[];
            selectedBatch=null;
            valBatchID="";
            transferFrom="";
            transferTo="";
            transferFromID="";
            transferToID="";
            // batchNumber(receiptId);
            plantingIdSearch(receiptId);
            getReceiptValue(receiptId);
          });
        },
      ));
    }
    else {

      listings.add(txt_label_mandatory("Transfer Receipt ID", Colors.black, 16.0, false));
      listings.add(cardlable_dynamic(receiptId.toString()));
    }


    listings.add(txt_label_mandatory("Date", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(productReceptionDate.toString()));

    listings.add(txt_label_mandatory("Transfer From", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(transferFrom.toString()));

    listings.add(txt_label_mandatory("Transfer To", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(transferTo.toString()));

    listings.add(txt_label_mandatory("Number Plate", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(truckNumber.toString()));

    listings.add(txt_label_mandatory("Driver Name", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(driverName.toString()));

    listings.add(txt_label_mandatory("Driver License Number", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(licenseNumber.toString()));

/*    listings.add(txt_label_mandatory("Incoming Shipment Batch ID", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: batchDropdown,
      selecteditem: selectedBatch,
      hint: "Select Incoming Shipment Batch ID",
      onChanged: (value) {
        setState(() {
          selectedBatch = value!;
          valBatchID=selectedBatch!.value;
          productName="";
          varietyName="";
          transferWeight="";
          receivedWeightController.text="";
          plantingDropdown=[];
          selectedPlanting=null;
          valPlanting="";
          blockDropdown=[];
          selectedBlock=null;
          slcBlock="";
          valBatchID="";
          blockNumber(valBatchID);
        });
      },
    ));

    listings.add(txt_label_mandatory("Block ID", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: blockDropdown,
      selecteditem: selectedBlock,
      hint: "Select Block ID",
      onChanged: (value) {
        setState(() {
          selectedBlock = value!;
          slcBlock=selectedBlock!.name;
          valBlock=selectedBlock!.value;
          productName="";
          varietyName="";
          transferWeight="";
          receivedWeightController.text="";
          plantingDropdown=[];
          selectedPlanting=null;
          valPlanting="";
          plantingIdSearch(valBlock);

        });
      },
    ));*/

    listings.add(txt_label_mandatory("Planting ID", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: plantingDropdown,
      selecteditem: selectedPlanting,
      hint: "Select Planting ID",
      onChanged: (value) {
        setState(() {
          selectedPlanting = value!;
          valPlanting=selectedPlanting!.value;
          productName="";
          varietyName="";
          transferWeight="";
          receivedWeightController.text="";
          plantingDetail(valPlanting);

          for(int i=0;i<plantingUiModel.length;i++){
            if(plantingUiModel[i].value==valPlanting){
              slcBlock=plantingUiModel[i].value3;
              valBlock=plantingUiModel[i].value2;
            }
          }
        });
      },
    ));

    listings.add(txt_label_mandatory("Block Name", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(slcBlock.toString()));

    listings.add(txt_label_mandatory("Product", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(productName.toString()));

    listings.add(txt_label_mandatory("Variety", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(varietyName.toString()));

    listings.add(txt_label_mandatory("Transferred Weight (Kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(transferWeight.toString()));

    listings.add(txt_label_mandatory("Received Weight (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal("Received Weight (Kg)", receivedWeightController, true, 60));



    listings.add(btn_dynamic(
        label: "Add",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          bool alreadyExist=false;
          for(int i=0;i<productReceptionList.length;i++){
            if(receiptId==productReceptionList[i].receiptID && valPlanting==productReceptionList[i].plantingID){
              alreadyExist=true;
            }
          }

        /*  if(valBatchID.isEmpty){
            alertPopup(context, "Select Incoming Shipment Batch ID");
          }
          else if(slcBlock.isEmpty){
            alertPopup(context, "Select Block");
          }*/
          if(valPlanting.isEmpty){
            alertPopup(context, "Select Planting ID");
          }
          else if(receivedWeightController.text.isEmpty){
            alertPopup(context, "Received Weight (Kg) should not be Empty");
          }
          else if(!validWeight){
            alertPopup(context, "Invalid Received Weight (Kg)");
          }
          else if(receivedWt>tWeight){
            alertPopup(context, "Received Weight (Kg) should not be Greater than Transferred Weight (Kg)");
          }
          else if(alreadyExist){
            alertPopup(context, "Product Already Exist");
            clearData();
          }
          else
          {
            setState(() {
              var productData= ProductReceptionModel(productId,varietyId,transferWeight,receivedWeightController.text,valBatchID,valPlanting,valBlock,slcBlock,farmerName,farmerId,farmName,farmID,stateCode,stateName,receiptId,varietyName,productName);
              productReceptionList.add(productData);
              clearData();

            });
          }
        }));

    if(productReceptionList.isNotEmpty){
      listings.add(productReceptionDataTable());
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

  bool textControllerValidation(String controllerValue) {
    bool validValue = true;
    double receivedValue = 0.0;
    if (controllerValue.isNotEmpty) {
      receivedValue = double.parse(controllerValue);

      if (receivedValue <= 0) {
        validValue = false;
      } else if (controllerValue.contains('.')) {
        List<String> value = controllerValue.split(".");
        if (value[1].isNotEmpty) {
          setState(() {
            validValue = true;
          });
        } else {
          validValue = false;
        }
      } else {
        validValue = true;
      }
    }
    return validValue;
  }


  void   btnSubmit(){
   /* if(selectedDate.isEmpty){
      alertPopup(context, "Select Date");
    }*/
    if(receiptId.isEmpty){
      alertPopup(context, "Select Transfer Receipt ID");
    }
    else if(productReceptionList.isEmpty){
      alertPopup(context, "Add Atleast One Product Reception List");
    }
    else {
     confirmation();
    }
  }

  void clearData(){
    slcBlock="";
    valBlock="";
    valBatchID="";
    valPlanting="";
    selectedBatch=null;
    selectedPlanting=null;
    selectedBlock=null;
    blockDropdown=[];
    plantingDropdown=[];
    batchDropdown=[];
    productName="";
    productId="";
    varietyName="";
    varietyId="";
    transferWeight="";
    receivedWeightController.text="";
    plantingIdSearch(receiptId);
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
            saveProductReception();
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

  Widget productReceptionDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Transfer Receipt ID')));
    columns.add(DataColumn(label: Text('Planting ID')));
    columns.add(DataColumn(label: Text('Transfered Weight (Kg)')));
    columns.add(DataColumn(label: Text('Received Weight (Kg)')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < productReceptionList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(productReceptionList[i].receiptID)));
      singlecell.add(DataCell(Text(productReceptionList[i].plantingID)));
      singlecell.add(DataCell(Text(productReceptionList[i].transferWeight)));
      singlecell.add(DataCell(Text(productReceptionList[i].receivedWeight)));
      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            productReceptionList.removeAt(i);
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


  Future<void> saveProductReception() async {
    var db = DatabaseHelper();
    final now = DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String receptionDate = DateFormat('yyyy-MM-dd').format(now);
    formatDate=receptionDate;
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
        txntime, datas.txnProductReception, revNo.toString(), '', '', '');

    int saveTransfer= await db.saveReceptionProduct(
        receiptId,
        productReceptionDate,
        transferFromID,
        transferToID,
        truckNumber,
        driverName,
        licenseNumber,
        "1",
        revNo.toString(),
        formatDate,
        batchNumber
     );

    if(productReceptionList.isNotEmpty){
      for(int i=0;i<productReceptionList.length;i++){
        int saveTransferDetail= await db.saveReceptionProductDetail(
            batchNumber,
            productReceptionList[i].receiptID,
            productReceptionList[i].blockID,
            productReceptionList[i].plantingID,
            productReceptionList[i].productId,
            productReceptionList[i].varietyId,
            productReceptionList[i].transferWeight,
            productReceptionList[i].receivedWeight,
            productReceptionList[i].blockName,
            productReceptionList[i].farmerName,
            productReceptionList[i].farmerID,
            productReceptionList[i].farmName,
            productReceptionList[i].farmId,
            productReceptionList[i].stateCode,
            productReceptionList[i].stateName,
            productReceptionList[i].varietyName,
           productReceptionList[i].productName,
          revNo.toString()
        );
      }

      print("kkkkkkkkkkkkkkuuu");
    }

    await db.UpdateTableValue(
        'receptionProduct', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();



    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Product Reception done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
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


}

class ProductReceptionModel{
  String productId;
  String varietyId;
  String transferWeight;
  String receivedWeight;
  String batchId;
  String plantingID;
  String blockID;
  String blockName;
  String farmerName;
  String farmerID;
  String farmName;
  String farmId;
  String stateCode;
  String stateName;
  String receiptID;
  String varietyName;
  String productName;

  ProductReceptionModel(
      this.productId,
      this.varietyId,
      this.transferWeight,
      this.receivedWeight,
      this.batchId,
      this.plantingID,
      this.blockID,
      this.blockName,
      this.farmerName,
      this.farmerID,
      this.farmName,
      this.farmId,
      this.stateCode,
      this.stateName,
      this.receiptID,
      this.varietyName,
      this.productName);
}


