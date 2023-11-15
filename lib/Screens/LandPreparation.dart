import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Screens/transactionsummary.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/secure_storage.dart';


class LandPreparation extends StatefulWidget {
  const LandPreparation({Key? key}) : super(key: key);

  @override
  _LandPreparationState createState() => _LandPreparationState();
}

class _LandPreparationState extends State<LandPreparation> {
  String no = 'No', yes = 'Yes';
  String slcFarmer = "", slcFarm = "", slcBlock = "";
  String valFarmer = "", valFarm = "", valBlock = "";
  String lastHarvDate ='';

  String slcClearingActivity = "", slcActivity = "", slcMode = "";
  String valActivity = "", valMode = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String selectedDate = "", formatDate = "";
  String slcWard = "", slcVillage = "", valWard = "", valVillage = "";

  List<UImodel3> farmerUIModel = [];
  List<UImodel> farmUIModel = [];
  List<UImodel> blockUIModel = [];
  List<UImodel> activityUIModel = [];
  List<UImodel> modeUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];

  List<DropdownMenuItem> farmerDropdown = [];
  List<DropdownMenuItem> farmDropdown = [];
  List<DropdownMenuItem> blockDropdown = [];
  List<DropdownMenuItem> activityDropdown = [];
  List<DropdownMenuItem> modeDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];

  List<LandPreparationList> activityList = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel1> farmitems = [];
  DropdownModel1? slctFarms;

  List<DropdownModel1> blockitems = [];
  DropdownModel1? slctBlocks;

  TextEditingController noOfLabourTextEditController =
  new TextEditingController();

  bool farmLoaded = false;
  bool blockLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getClientData();
    initValues();
    ward();
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

  Future<void> village(String cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct fm.villageId as villCode ,fm.[villageName] as villName from [farmer_master] fm inner join [villageList] vl on fm.villageId = vl.[villCode] inner join blockDetails bL on fm.farmerId=bL.farmerId where vl.[gpCode]=\'' +
            cityCode +
            '\'');
    villageUIModel = [];
    villageDropdown = [];
    villageDropdown.clear();
    for (int i = 0; i < villageList.length; i++) {
      String propertyValue = villageList[i]["villName"].toString();
      String diSpSeq = villageList[i]["villCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      villageUIModel.add(uiModel);
      setState(() {
        villageDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  Future<void> ward() async {
    List wardList = await db.RawQuery(
        'select distinct vl.[gpCode] as cityCode,ct.[cityName] as cityName from [farmer_master] fm  inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode]  inner join blockDetails bL on fm.farmerId=bL.farmerId');

    wardUIModel = [];
    wardDropdown = [];
    wardDropdown.clear();
    for (int i = 0; i < wardList.length; i++) {
      String propertyValue = wardList[i]["cityName"].toString();
      String diSpSeq = wardList[i]["cityCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      wardUIModel.add(uiModel);
      setState(() {
        wardDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  void farmerSearch(String villageCode) async {
    String qryFarmerList =
        'select distinct fm.farmerId,fm.fName,fm.farmerCode,fm.idProofVal, fm.trader from farmer_master as fm inner join farm as f on fm.farmerId = f.farmerId inner join blockDetails bL on fm.farmerId=bL.farmerId where fm.villageId= \'' +
            villageCode +
            '\'';
    List farmersList = await db.RawQuery(qryFarmerList);

    farmerUIModel = [];
    farmerDropdown = [];
    farmeritems.clear();

    for (int i = 0; i < farmersList.length; i++) {
      String property_value = farmersList[i]["fName"].toString();
      String DISP_SEQ = farmersList[i]["farmerId"].toString();
      String idProofVal = farmersList[i]["idProofVal"].toString();
      String kraPin = farmersList[i]["trader"].toString();

      var uimodel = new UImodel3(
          property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin);
      farmerUIModel.add(uimodel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
  }

  void initValues() async {
    List activity = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'80\'');

    activityUIModel = [];
    activityDropdown = [];
    activityDropdown.clear();
    for (int i = 0; i < activity.length; i++) {
      String propertyValue = activity[i]["property_value"].toString();
      String diSpSeq = activity[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      activityUIModel.add(uiModel);
      setState(() {
        activityDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List modeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'79\'');
    modeUIModel = [];
    modeDropdown = [];
    modeDropdown.clear();
    for (int i = 0; i < modeList.length; i++) {
      String propertyValue = modeList[i]["property_value"].toString();
      String diSpSeq = modeList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      modeUIModel.add(uiModel);
      setState(() {
        modeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  farmSearch() async {
    String qryFarmList =
        'select distinct f.farmIDT,f.farmName from farm as f  inner join blockDetails bL on f.farmIDT=bL.farmId where f.farmerId = \'' +
            valFarmer +
            '\'';
    List farmList = await db.RawQuery(qryFarmList);

    farmUIModel = [];
    farmDropdown = [];
    farmitems.clear();
    for (int i = 0; i < farmList.length; i++) {
      String propertyValue = farmList[i]["farmName"].toString();
      String diSpSeq = farmList[i]["farmIDT"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      farmUIModel.add(uiModel);
      setState(() {
        farmitems.add(DropdownModel1(
            propertyValue,
            diSpSeq,
            ''
        ));
        //prooflist.add(property_value);
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        farmLoaded = true;
        slcFarm = "";
      });
    });
  }

  blockSearch(String farmCode) async {
    String qryBlock =
        'select distinct blockId,blockName  from blockDetails where farmId = \'' +
            farmCode +
            '\' and farmerId=\'' +
            valFarmer +
            '\'';

    print(qryBlock);
    List blockList = await db.RawQuery(qryBlock);

    blockDropdown = [];
    blockUIModel = [];
    blockitems.clear();
    for (int i = 0; i < blockList.length; i++) {
      String propertyValue = blockList[i]["blockName"].toString();
      String diSpSeq = blockList[i]["blockId"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      blockUIModel.add(uiModel);
      setState(() {
        blockitems.add(DropdownModel1(
            propertyValue,
            diSpSeq,
            ''
        ));
        //prooflist.add(property_value);
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        blockLoaded = true;
        slcBlock = "";
      });
    });
  }

  void rebuildScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                },
              ),
              title: Text('Land Preparation',
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

  Future<bool> _onBackPressed() async {
    return (await Alert(
      context: context,
      type: AlertType.warning,
      title: "Cancel",
      desc: "Are you sure want to cancel?",
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
        .add(txt_label_mandatory("Select the Ward", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: wardDropdown,
      selecteditem: slcWard,
      hint: "Select Ward",
      onChanged: (value) {
        setState(() {
          slcWard = value!;
          slcVillage = "";
          slcFarmer = "";
          slcFarm = "";
          slcBlock = "";
          valBlock = "";
          slctFarmers = null;
          slctFarms = null;
          slctBlocks = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          villageDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          for (int i = 0; i < wardUIModel.length; i++) {
            if (value == wardUIModel[i].name) {
              valWard = wardUIModel[i].value;
              village(valWard);
            }
          }
        });
      },
    ));

    listings.add(
        txt_label_mandatory("Select the Village", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: villageDropdown,
      selecteditem: slcVillage,
      hint: "Select Village",
      onChanged: (value) {
        setState(() {
          slcVillage = value!;
          slcFarm = "";
          slcFarmer = "";
          valFarm = "";
          slctFarmers = null;
          slctFarms = null;
          slctBlocks = null;
          slcBlock = "";
          valBlock = "";
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          for (int i = 0; i < villageUIModel.length; i++) {
            if (value == villageUIModel[i].name) {
              valVillage = villageUIModel[i].value;
              farmerSearch(valVillage);
            }
          }
        });
      },
    ));

    listings.add(
        txt_label_mandatory("Select the Farmer", Colors.black, 15.0, false));
    /* listings.add(singlesearchDropdown(
      itemlist: farmerDropdown,
      selecteditem: slcFarmer,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slcFarmer = value!;
          slcBlock = "";
          blockLoaded = false;
          blockDropdown.clear();
          slcFarm = "";
          farmLoaded = false;
          farmDropdown.clear();
          for (int i = 0; i < farmerUIModel.length; i++) {
            if (value == farmerUIModel[i].name) {
              valFarmer = farmerUIModel[i].value;
              farmSearch();
            }
          }
        });
      },
    )); */

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          slcBlock = "";
          valBlock = "";
          valFarm = "";
          blockLoaded = false;
          blockDropdown.clear();
          slcFarm = "";
          farmLoaded = false;
          farmDropdown.clear();
          slctFarms = null;
          slctBlocks = null;
          //toast(slctFarmers!.value);
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          farmSearch();
        });
        print('selectedvalue ' + slctFarmers!.value);
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Select the Farm", Colors.black, 15.0, false)
        : Container());

    listings.add(farmLoaded
        ? DropDownWithModel1(
        itemlist: farmitems,
        selecteditem: slctFarms,
        hint: "Select Farm",
        onChanged: (value) {
          setState(() {
            slctFarms = value!;
            slcBlock = "";
            valBlock = "";
            valFarm = "";
            blockLoaded = false;
            blockDropdown.clear();
            slctBlocks = null;
            //toast(slctFarms!.value);
            valFarm = slctFarms!.value;
            slcFarm = slctFarms!.name;
            print('selectedvalue ' + slctFarms!.value);
            print('harvestDate ' + slctFarms!.value1);

            blockSearch(valFarm);
          });

          print("Name" + slcFarmer);
          print("Code" + valFarmer);
        },
        onClear: () {
          setState(() {
            slcFarm = "";
          });
        })
        : Container());

    listings.add(valFarm.length > 0
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.length > 0
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Select the Block", Colors.black, 15.0, false)
        : Container());
    listings.add(blockLoaded
        ? DropDownWithModel1(
      itemlist: blockitems,
      selecteditem: slctBlocks,
      hint: "Select Block",
      onChanged: (value) {
        setState(() {
          slctBlocks = value!;
          valBlock = slctBlocks!.value;
          slcBlock = slctBlocks!.name;
          print('selectedvalue ' + slctBlocks!.value);
          print('lastharvestdate ' + slctBlocks!.value1);
          //  getMaxHarvestDate(valFarm ,valBlock );

        });
      },
    )
        : Container());

    listings
        .add(txt_label_mandatory("Date of Event", Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: selectedDate,
        onConfirm: (date) => setState(
              () {
            selectedDate = DateFormat('dd-MM-yyyy').format(date);
            formatDate = DateFormat('yyyy-MM-dd').format(date);

            // if(lastHarvDate.isNotEmpty){
            //   var difference = DateTime.parse(formatDate).difference(DateTime.parse(lastHarvDate)).inDays ;
            //   print('difference--- $difference');
            //   if(difference > 0){
            //     selectedDate='';
            //     formatDate='';
            //     alertPopup(
            //         context, "Date of event should be set before the harvest date($lastHarvDate) ");
            //   }else{
            //   }
            // }else{}
          },
        )));

    listings.add(txt_label_mandatory("Activity", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: activityDropdown,
      selecteditem: slcActivity,
      hint: "Select Activity",
      onChanged: (value) {
        setState(() {
          slcActivity = value!;
          for (int i = 0; i < activityUIModel.length; i++) {
            if (value == activityUIModel[i].name) {
              valActivity = activityUIModel[i].value;
            }
          }
        });
      },
    ));

/*    listings.add(
        txt_label_mandatory("Mode of Activity", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: modeDropdown,
      selecteditem: slcMode,
      hint: "Select Mode Activity",
      onChanged: (value) {
        setState(() {
          slcMode = value!;
          for (int i = 0; i < modeUIModel.length; i++) {
            if (value == modeUIModel[i].name) {
              valMode = modeUIModel[i].value;
            }
          }
        });
      },
    ));*/

    listings
        .add(txt_label_mandatory("No of Labourers", Colors.black, 15.0, false));

    listings.add(txtFieldOnlyIntegerWithoutLeadingZero(
        "No of Labourers", noOfLabourTextEditController, true, 50));

    listings.add(btn_dynamic(
        label: "Add",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          if (slcActivity.length == 0) {
            alertPopup(context, "Activity should not be empty");
          }
          /* else if (slcMode.length == 0) {
            alertPopup(context, "Mode of Activity should not be empty");
          }*/
          else if (noOfLabourTextEditController.text.length == 0) {
            alertPopup(context, "No. of Labourers should not be empty");
          } else {
            var clearing = new LandPreparationList(slcActivity,
                valActivity, noOfLabourTextEditController.text);
            activityList.add(clearing);

            setState(() {
              slcActivity = "";
              slcMode = "";
              noOfLabourTextEditController.text = "";
            });
          }
        }));

    if (activityList.length > 0) {
      listings.add(activityDataTableProduct());
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

    return listings;
  }

  Widget activityDataTableProduct() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(DataColumn(label: Text('Activity')));
    //columns.add(DataColumn(label: Text('Mode of Activity')));
    columns.add(DataColumn(label: Text('No of Labourers')));
    columns.add(DataColumn(label: Text('Delete')));

    for (int i = 0; i < activityList.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text(activityList[i].slcActivity)));
      //singlecell.add(DataCell(Text(activityList[i].slcMode)));
      singlecell.add(DataCell(Text(activityList[i].noOfLabourers)));

      singlecell.add(DataCell(InkWell(
        onTap: () {
          setState(() {
            activityList.removeAt(i);
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

  void btnSubmit() {
    if (slcWard.length == 0) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.length == 0) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer.length == 0) {
      alertPopup(context, "Farmer should not be empty");
    } else if (slcFarm.length == 0) {
      alertPopup(context, "Farm should not be empty");
    } else if (slcBlock.length == 0) {
      alertPopup(context, "Farm should not be empty");
    } else if (selectedDate.length == 0) {
      alertPopup(context, "Date of Event should not be empty");
    } else if (activityList.length == 0) {
      alertPopup(context, "Add Atleast one Activity List");
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
            landPreparation();
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

  Future<void> landPreparation() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    print('txnHeader ' + agentid! + "" + agentToken!);
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

    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnLandPreparation, revNo.toString(), '', '', '');

    int savelandPreparation = await db.saveLandPreparation(txntime,
        revNo.toString(), "1", valFarmer, valFarm, valBlock, formatDate);

    print('valFarm - $valFarm');
    print('valBlock - $valBlock');

    db.UpdateTableValue(
        'farmCrop', 'expWeek', formatDate, 'blockId', valBlock.trim());

    if (activityList.length > 0) {
      for (int i = 0; i < activityList.length; i++) {
        int saveClearing = await db.landPreparationList(
            revNo.toString(),
            activityList[i].valActivity,
            "",
            activityList[i].noOfLabourers);
        print("saveClearing" + saveClearing.toString());
      }
    }

    await db.UpdateTableValue(
        'landPreparation', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Land Preparation done Successfully",
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

  void getMaxHarvestDate(String valFarm, String valBlock) async{
    String qryBlock =
        'select distinct Max(lastHarDate) as harvestDate from villageWarehouse where farmId = \'' +
            valFarm +
            '\' and farmerId=\'' +
            valFarmer +
            '\' and blockId=\'' +
            valBlock +
            '\'';

    print('qryBlock --- $qryBlock');
    List blockList = await db.RawQuery(qryBlock);

    print(blockList);

    if(blockList.isNotEmpty){
      for (int i = 0; i < blockList.length; i++) {
        setState((){
          lastHarvDate = blockList[i]["harvestDate"].toString();
        });
        print('lastHarvDate--${lastHarvDate}');
      }
    }else{
      setState(() {
        lastHarvDate ='';
        print('lastHarvDate--${lastHarvDate}');
      });
    }
  }
}

class LandPreparationList {
  String slcActivity, valActivity, noOfLabourers;

  LandPreparationList(this.slcActivity, this.valActivity,
      this.noOfLabourers);
}
