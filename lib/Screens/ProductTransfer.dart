import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nhts/Screens/transactionsummary.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import '../Model/UIModel.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import '../Utils/dynamicfields.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nhts/Database/Databasehelper.dart';

import '../Utils/secure_storage.dart';



class ProductTransfer extends StatefulWidget {
  const ProductTransfer({Key? key}) : super(key: key);

  @override
  State<ProductTransfer> createState() => _ProductTransferState();
}




class _ProductTransferState extends State<ProductTransfer> {

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Exit';
  String no = 'No', yes = 'Yes';
  String selectedDate = "", formatDate = "";

  String slcTransferFrom="",valTransferFrom="",slcTransferTo="",valTransferTo="",productName="",varietyName="",
  availableWeight="",transferReceiptID="";
  String valBatchID="",slcBlock="",valBlock="",valPlanting="";
  String exporterName="",exporterId="";
  String transferFromID="";
  String productID="",varietyID="";
  String farmerId="",farmerName="",farmID="",farmName="",stateCode="",stateName="";

  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";

  double tWeight=0.0;
  double aWeight=0.0;
  bool validWeight=true;


  List<DropdownModel> transferFromDropdown = [];
  DropdownModel? selectedTransferFrom;
  List<DropdownModel> transferToDropdown = [];
  DropdownModel? selectedTransferTo;
  List<DropdownModel> batchDropdown = [];
  DropdownModel? selectedBatch;
  List<DropdownModel> blockDropdown = [];
  DropdownModel? selectedBlock;
  List<DropdownModel> plantingDropdown = [];
  DropdownModel? selectedPlanting;

  List<UImodel> blockUiModel = [];
  List<UImodel> plantingUiModel = [];
  List<UImodel> batchUiModel = [];
  List<UImodel> transferFromUiModel = [];
  List<UImodel> transferToUiModel = [];

  List<ProductTransferModel> productTransferList=[];
  TextEditingController transferWeightController= TextEditingController();
  TextEditingController truckNumberController= TextEditingController();
  TextEditingController driverNameController= TextEditingController();
  TextEditingController licenseNumberController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
    getLocation();
    transferTo();

    final now = DateTime.now();
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    transferReceiptID = msgNo;





    transferWeightController.addListener(() {
      setState(() {
        if(transferWeightController.text.isNotEmpty){
          tWeight=double.parse(transferWeightController.text);
          validWeight=textControllerValidation(transferWeightController.text);
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
    agentId = agents[0]['agentId'];
    exporterName = agents[0]['exporterName'];
    exporterId = agents[0]['exporterId'];
    transferFromID = agents[0]['packHouseCode'];
    transferFrom(transferFromID);
  }


  Future<void> transferFrom(String code) async {
    String qryTransferFrom = 'select distinct coCode,coName from coOperative where coCode=\''+code+'\'';
    print("qryBlockNumber" + qryTransferFrom.toString());
    List transferFromList = await db.RawQuery(qryTransferFrom);

    transferFromUiModel = [];
    transferFromDropdown = [];
    transferFromDropdown.clear();

    for (int i = 0; i < transferFromList.length; i++) {
      String packHouseName = transferFromList[i]["coName"].toString();
      String packHouseID = transferFromList[i]["coCode"].toString();
      var uimodel = UImodel(packHouseName, packHouseID);
      transferFromUiModel.add(uimodel);
      setState(() {
        transferFromDropdown.add(DropdownModel(
          packHouseName,
          packHouseID,
        ));
      });
    }
  }



  Future<void> transferTo() async {
    String qryTransferTo ='select distinct coCode,coName from coOperative';

    print("qryTransferTo" + qryTransferTo.toString());
    List transferToList = await db.RawQuery(qryTransferTo);

    transferToUiModel = [];
    transferToDropdown = [];

    for (int i = 0; i < transferToList.length; i++) {
      String packHouseName = transferToList[i]["coName"].toString();
      String packHouseID = transferToList[i]["coCode"].toString();
      var uimodel = UImodel(packHouseName, packHouseID);
      transferToUiModel.add(uimodel);
      setState(() {
        transferToDropdown.add(DropdownModel(
          packHouseName,
          packHouseID,
        ));
      });
    }
  }


  void batchNumber(String formatDate) async {
    String batchNumberQry =
        'select distinct batchNo from villageWarehouse where stockType=2 and lastHarDate<=\'' +
            formatDate +
            '\'';
    print("batchNumberQry" + batchNumberQry);
    List batchNumberList = await db.RawQuery(batchNumberQry);
    batchDropdown = [];
    batchUiModel = [];
    for (int i = 0; i < batchNumberList.length; i++) {
      String batchNo = batchNumberList[i]["batchNo"].toString();

      var uiModel = UImodel(batchNo, batchNo);
      batchUiModel.add(uiModel);
      setState(() {
        batchDropdown.add(DropdownModel(
          batchNo,
          batchNo,
        ));
      });
    }

  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select distinct plantingId,batchNo from villageWarehouse where stockType=2 and  blockId=\'' +
            blockID +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\' and batchNo=\''+valBatchID+'\'';
    print("plantingQry" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUiModel = [];
    plantingDropdown = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["plantingId"].toString();

      var uiModel = UImodel(plantingID, plantingID);
      plantingUiModel.add(uiModel);
      setState(() {
        plantingDropdown.add(DropdownModel(
          plantingID,
          plantingID,
        ));

      });
    }
  }

  Future<void> plantingDetail(String plantingId) async {
    String qryPlantingDetail =
        'select distinct plantingId,countyCode,countyName,stockType,batchNo,farmerId,farmId,farmerName,farmName,batchNo,actWt,pCode,pName,vCode,vName,blockId from villageWarehouse where actWt>0 and stockType=2 and plantingId=\'' +
            plantingId +
            '\' and blockId=\'' +
            valBlock +
            '\' and lastHarDate<=\'' +
            formatDate +
            '\' and batchNo=\'' +
            valBatchID +
            '\'';

    print("qryBlockDetail" + qryPlantingDetail.toString());

    List plantingDetail = await db.RawQuery(qryPlantingDetail);
    print("blockDetail_blockDetail" + plantingDetail.toString());

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
        productID = pCode;
        varietyID = vCode;
        availableWeight = actWt;
        aWeight=double.parse(availableWeight);
        farmerId=farmerVal;
        farmerName=farmer;
        farmID=farmVal;
        farmName=farm;
        stateName=countyName;
        stateCode=countyCode;
      });
    }
  }


  Future<void> blockNumber(String batchNo) async {
    String qryBlockNumber =
        'select distinct blockId,blockName from villageWarehouse where  blockName!="" and  stockType=2 and lastHarDate<=\'' +
            formatDate +
            '\' and batchNo=\''+batchNo+'\'';

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
              title: Text('Product Transfer',
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


  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];


    listings.add(txt_label_mandatory("Date", Colors.black, 14.0, false));
      listings.add(selectDate(
          context1: context,
          slctdate: selectedDate,
          onConfirm: (date) => setState(
                () {
              selectedDate = DateFormat('dd-MM-yyyy').format(date);
              formatDate = DateFormat('yyyy-MM-dd').format(date);
              transferWeightController.text="";
              productName="";
              varietyName="";
              availableWeight="";
              valPlanting="";
              selectedPlanting=null;
              plantingDropdown=[];
              valBlock="";
              slcBlock="";
              selectedBlock=null;
              blockDropdown=[];
              valBatchID="";
              selectedBatch=null;
              batchDropdown=[];
              batchNumber(formatDate);
            },
          )));

    listings.add(txt_label_mandatory("Exporter", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(exporterName.toString()));


    listings.add(txt_label_mandatory("Transfer From", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: transferFromDropdown,
      selecteditem: selectedTransferFrom,
      hint: "Select Transfer From",
      onChanged: (value) {
        setState(() {
          selectedTransferFrom = value!;
          slcTransferFrom=selectedTransferFrom!.name;
          valTransferFrom=selectedTransferFrom!.value;
        });
      },
    ));


    listings.add(txt_label_mandatory("Transfer To", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: transferToDropdown,
      selecteditem: selectedTransferTo,
      hint: "Select Transfer To",
      onChanged: (value) {
        setState(() {
          selectedTransferTo = value!;
          slcTransferTo=selectedTransferTo!.name;
          valTransferTo=selectedTransferTo!.value;
        });
      },
    ));

    listings.add(txt_label_mandatory("Incoming Shipment Batch ID", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: batchDropdown,
      selecteditem: selectedBatch,
      hint: "Select Incoming Shipment Batch ID",
      onChanged: (value) {
        setState(() {
          selectedBatch = value!;
          valBatchID=selectedBatch!.value;
          transferWeightController.text="";
          productName="";
          varietyName="";
          availableWeight="";
          valPlanting="";
          selectedPlanting=null;
          plantingDropdown=[];
          valBlock="";
          slcBlock="";
          selectedBlock=null;
          blockDropdown=[];
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
          transferWeightController.text="";
          productName="";
          varietyName="";
          availableWeight="";
          valPlanting="";
          selectedPlanting=null;
          plantingDropdown=[];
          plantingIdSearch(valBlock);
        });
      },
    ));

    listings.add(txt_label_mandatory("Planting ID", Colors.black, 16.0, false));
    listings.add(DropDownWithModel(
      itemlist: plantingDropdown,
      selecteditem: selectedPlanting,
      hint: "Select Planting ID",
      onChanged: (value) {
        setState(() {
          selectedPlanting = value!;
          valPlanting=selectedPlanting!.value;
          transferWeightController.text="";
          productName="";
          varietyName="";
          availableWeight="";
          plantingDetail(valPlanting);
        });
      },
    ));

    listings.add(txt_label_mandatory("Product", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(productName.toString()));

    listings.add(txt_label_mandatory("Variety", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(varietyName.toString()));

    listings.add(txt_label_mandatory("Available Weight (Kg)", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(availableWeight.toString()));

    listings.add(
        txt_label_mandatory("Transfer Weight (Kg)", Colors.black, 16.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Transfer Weight (Kg)", transferWeightController, true, 20));




    listings.add(btn_dynamic(
        label: "Add",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {

          bool productExist=false;

          for(int i=0;i<productTransferList.length;i++){
            if(valBatchID==productTransferList[i].batchID && valPlanting==productTransferList[i].plantingID
            && valBlock==productTransferList[i].blockID){
              productExist=true;
            }
          }

          if(valBatchID.isEmpty){
            alertPopup(context, "Select Incoming Shipment Batch ID");
          }
          else if(slcBlock.isEmpty){
            alertPopup(context, "Select Block");
          }
          else if(valPlanting.isEmpty){
            alertPopup(context, "Select Planting ID");
          }
          else if(transferWeightController.text.isEmpty){
            alertPopup(context, "Transfer Weight (Kg)  should not be Empty");
          }
          else if(!validWeight){
            alertPopup(context, "Invalid Transfer Weight (Kg)");
          }
          else if(tWeight>aWeight){
            alertPopup(context, "Transfer Weight (Kg)  should not be Greater than Available Weight (Kg)");
          }
          else if(productExist){
            alertPopup(context, "Product Already Exist");
            clearData();
          }

          else
            {
            setState(() {
              var productData= ProductTransferModel(transferWeightController.text,valBatchID,valBlock,slcBlock,valPlanting,productID,varietyID,productName,varietyName,farmerName,farmerId,farmName,farmID,stateCode,stateName,availableWeight);
              productTransferList.add(productData);
              clearData();
            });
            }
        }));

    if(productTransferList.isNotEmpty){
      listings.add(productTransferDataTable());
    }

    listings
        .add(txt_label_mandatory("Number Plate", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Number Plate", truckNumberController, true,30));


    listings.add(txt_label_mandatory("Driver Name", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Driver Name", driverNameController, true, 30));


    listings.add(txt_label_mandatory("Driver License Number", Colors.black, 16.0, false));
    listings
        .add(txtfield_digitswithoutdecimal("Driver License Number", licenseNumberController, true));


    listings.add(txt_label_mandatory("Transfer Receipt ID", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(transferReceiptID.toString()));


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

  void  btnSubmit(){
    if(selectedDate.isEmpty){
      alertPopup(context, "Date should not be Empty");
    }
    else if(slcTransferFrom.isEmpty){
      alertPopup(context, "Select Transfer From");
    }
    else if(slcTransferTo.isEmpty){
      alertPopup(context, "Select Transfer To");
    }
    else if(slcTransferTo.toString().trim()==slcTransferFrom.toString().trim()){
      alertPopup(context, "Transfer From and Transfer To Should not be Same");
    }
    else if(productTransferList.isEmpty){
      alertPopup(context, "Add Atleast One Product Transfer List");
    }
    else if(truckNumberController.text.isEmpty){
      alertPopup(context, "Number Plate Should not be Empty");
    }
    else if(driverNameController.text.isEmpty){
      alertPopup(context, "Driver Name Should not be Empty");
    }
    else if(licenseNumberController.text.isEmpty){
      alertPopup(context, "Driver License Number Should not be Empty");
    }
    else {
      confirmation();
    }
  }

  void clearData(){
    transferWeightController.text="";
    availableWeight="";
    slcBlock="";
    valBlock="";
    valBatchID="";
    valPlanting="";
    selectedPlanting=null;
    selectedBlock=null;
    selectedBatch=null;
    productID="";
    varietyID="";
    productName="";
    varietyName="";
    productID="";
    farmerId="";
    farmerName="";
    farmID="";
    farmName="";
    stateCode="";
    stateName="";
    batchNumber(formatDate);
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
            saveProductTransfer();
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


  Widget productTransferDataTable() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Incoming Shipment Batch ID')));
    columns.add(DataColumn(label: Text('Block ID')));
    columns.add(DataColumn(label: Text('Planting ID')));
    columns.add(DataColumn(label: Text('Transfered Weight')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < productTransferList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(productTransferList[i].batchID)));
      singlecell.add(DataCell(Text(productTransferList[i].blockID)));
      singlecell.add(DataCell(Text(productTransferList[i].plantingID)));
      singlecell.add(DataCell(Text(productTransferList[i].transferWeight)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            productTransferList.removeAt(i);
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



  Future<void> saveProductTransfer() async {
    var db = DatabaseHelper();
    final now = DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    print('txnHeader ' + agentid! + "" + agentToken!);
    Random rnd = Random();
    int revNo= 100000 + rnd.nextInt(999999 - 100000);


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
        txntime, datas.txnProductTransfer, revNo.toString(), '', '', '');


    int saveTransfer= await db.saveTransferProduct(
        formatDate,
        exporterId,
        valTransferFrom,
        valTransferTo,
        truckNumberController.text,
        driverNameController.text,
        licenseNumberController.text,
        transferReceiptID,
        "1",
        revNo.toString(),
    );

    if(productTransferList.isNotEmpty){
      for(int i=0;i<productTransferList.length;i++){
        int saveTransferDetail= await db.saveTransferProductDetail(
            revNo.toString(),
            productTransferList[i].batchID,
            productTransferList[i].blockID,
            productTransferList[i].plantingID,
            productTransferList[i].productID,
            productTransferList[i].varietyID,
            productTransferList[i].transferWeight,
            productTransferList[i].productName,
            productTransferList[i].blockName,
            productTransferList[i].varietyName,
            productTransferList[i].farmerName,
            productTransferList[i].farmerID,
            productTransferList[i].farmName,
            productTransferList[i].farmId,
            productTransferList[i].stateCode,
            productTransferList[i].stateName,
            productTransferList[i].availableWt,
        );
      }
    }

    await db.UpdateTableValue(
        'transferProduct', 'isSynched', '0', 'recNo', revNo.toString());

    print('revNo_revNo' + revNo.toString());

    TxnExecutor txnExecutor = TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();



    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Product Transfer done Successfully",
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


class ProductTransferModel{
  String transferWeight;
  String batchID;
  String blockID;
  String blockName;
  String plantingID;
  String productID;
  String varietyID;
  String productName;
  String varietyName;
  String farmerName;
  String farmerID;
  String farmName;
  String farmId;
  String stateCode;
  String stateName;
  String availableWt;

  ProductTransferModel(
      this.transferWeight,
      this.batchID,
      this.blockID,
      this.blockName,
      this.plantingID,
      this.productID,
      this.varietyID,
      this.productName,
      this.varietyName,
      this.farmerName,
      this.farmerID,
      this.farmName,
      this.farmId,
      this.stateCode,
      this.stateName,
      this.availableWt);
}

