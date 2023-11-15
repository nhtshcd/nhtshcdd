import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Database/Databasehelper.dart';
import '../Model/UIModel.dart';
import '../Plugins/TxnExecutor.dart';
import '../Utils/MandatoryDatas.dart';
import '../Utils/secure_storage.dart';
import '../login.dart';
import 'geoplottingfarm.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({Key? key}) : super(key: key);

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  String ruexit = 'Are you sure want to cancel?';
  String cancel = 'Cancel', no = 'No', yes = 'Yes';

  String slcFarmer = "";
  String slcFarm = "";
  String valFarm = "";
  String valFarmer = "";
  String cropCount = "";
  String farmCount = "";
  String countValue = "";
  String blockId = "";
  String blockArea = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "",
      prosLand = "";

  int fCount = 0;
  int cCount = 0;
  double overallArea = 0.0;
  double farmAreaValue = 0.0;
  double getBlockAreaArea = 0.0;

  TextEditingController blockNameController = new TextEditingController();
  TextEditingController blockAreaTextEditController =
      new TextEditingController();

  List<DropdownModelFarmer> farmeritems = [];
  List<DropdownModel> farmitems = [];

  DropdownModel? slctFarms;
  DropdownModelFarmer? slctFarmers;

  List<UImodel3> farmerUIModel = [];
  List<UImodel2> farmUIModel = [];

  bool farmLoaded = false;
  bool farmerLoaded = false;
  bool blockIDAdded = false;
  bool areaPlotted = false;
  bool areaPlottingAdded = false;

  List<BlockDetail> blockDetail = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    farmer();
    getLocation();
    getClientData();
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

    //print("latitude_planting" + latitude.toString());
    //print("longitude_planting" + longitude.toString());
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
          title: Text('Block Registration',
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
          title: cancel,
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

  Future<void> farmer() async {
    List farmerList = await db.RawQuery(
        'select distinct fa.farmerId,fa.fName,fa.idProofVal,fa.trader from farmer_master as fa inner join farm as fr on fr.farmerId=fa.farmerId');
    //print("farmerList_farmerList" + farmerList.toString());

    farmerUIModel = [];
    farmeritems.clear();
    for (int i = 0; i < farmerList.length; i++) {
      String propertyValue = farmerList[i]["fName"].toString();
      String diSpSeq = farmerList[i]["farmerId"].toString();
      String idProofVal = farmerList[i]["idProofVal"].toString();
      String kraPin = farmerList[i]["trader"].toString();

      var uiModel = new UImodel3(
          propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin);
      farmerUIModel.add(uiModel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
  }

/*  void getBlockName(String farmCode) async {
    String blockNameQry =
        'select distinct fmcrp.farmcrpIDT,fmcrp.blockName,fmcrp.blockId from farmCrop as fmcrp where fmcrp.[farmCodeRef]=\'' +
            farmCode +
            '\';';

    List blockNameList = await db.RawQuery(blockNameQry);
    blockDetail.clear();
    for (int i = 0; i < blockNameList.length; i++) {
      String block_Name = blockNameList[i]["blockName"].toString();
      String blockID = blockNameList[i]["blockId"].toString();

      setState(() {
        var blockList = new BlockDetail(block_Name, blockID);
        blockDetail.add(blockList);
      });
    }
  }*/

  void getArea(String farmID) async {
    String qryArea =
        'select distinct fa.farmIDT,fa.prodLand,sum(bL.blockArea) as blockArea from farm fa inner join blockDetails bL where  bL.farmId=fa.farmIDT and fa.farmIDT  = \'' +
            farmID +
            '\'';
   // print("qryArea" + qryArea.toString());
    List farmAreaList = await db.RawQuery(qryArea);

    double fArea = 0.0, bLArea = 0.0;

    try {
      if (farmAreaList.isNotEmpty) {
        //print(" " + qryArea);
        for (int i = 0; i < farmAreaList.length; i++) {
          String farmArea = farmAreaList[i]["prodLand"].toString();
          String blockArea = farmAreaList[i]["blockArea"].toString();
          setState(() {
            fArea = double.parse(farmArea);
            bLArea = double.parse(blockArea);
            overallArea = bLArea;
            farmAreaValue = fArea;
          });
        }
      } else {
        String qryArea =
            'select distinct farmIDT,prodLand from farm  where farmIDT=\'' +
                farmID +
                '\'';
       // print("qrAreaElse" + qryArea.toString());
        List farmAreaList = await db.RawQuery(qryArea);
        for (int i = 0; i < farmAreaList.length; i++) {
          String blockArea = farmAreaList[i]["prodLand"].toString();
          setState(() {
            double area = double.parse(blockArea);
            farmAreaValue = area;
          });
        }
      }
    } catch (e) {
      String qryArea =
          'select distinct farmIDT,prodLand from farm  where farmIDT=\'' +
              farmID +
              '\'';
      //print("qrAreaCatch" + qryArea.toString());
      List farmAreaList = await db.RawQuery(qryArea);
      for (int i = 0; i < farmAreaList.length; i++) {
        String blockArea = farmAreaList[i]["prodLand"].toString();
        setState(() {
          double area = double.parse(blockArea);
          farmAreaValue = area;
        });
      }
    }
  }

  void getBlockName(String farmCode) async {
    String blockNameQry =
        'select distinct blockId,farmId,blockName from blockDetails where farmId=\'' +
            farmCode +
            '\';';
    //print("blockNameQry" + blockNameQry.toString());

    List blockNameList = await db.RawQuery(blockNameQry);
    blockDetail.clear();
    for (int i = 0; i < blockNameList.length; i++) {
      String block_Name = blockNameList[i]["blockName"].toString();
      String blockID = blockNameList[i]["blockId"].toString();

      setState(() {
        var blockList = new BlockDetail(block_Name, blockID);
        blockDetail.add(blockList);
      });
    }
  }

  getCropCount(String farmID) async {
    String countQry =
        'select MAX(CAST(blockCount AS Int)) as blockCount from farm where farmIDT =\'' +
            farmID +
            '\' and farmerId =\'' +
            valFarmer +
            '\'';
    //print("countQry_countQry" + countQry.toString());

    List cropCountList = await db.RawQuery(countQry);
    //print("farmCountList" + cropCountList.toString());
    try {
      if (cropCountList.length > 0) {
        String Count = cropCountList[0]["blockCount"].toString();
        countValue = Count;
      }
    } catch (e) {}
    blockCount();
  }

  blockCount() async {
    try {
      //print("firsttry");
      if (countValue.length > 0) {
        int convertCount = int.parse(countValue);
        //print("countValuetryif");
        setState(() {
          int cropMAxCount = 0;
          String value = "";
          try {
           // print("countValuetryifsecond");
            cropMAxCount = convertCount + 1;
            value = cropMAxCount.toString();
            cCount = cropMAxCount;
          } catch (e) {
           // print("countValuetryifCatch");
            cropMAxCount = cropMAxCount + 1;
            value = cropMAxCount.toString();
            cCount = cropMAxCount;
          }
          while (value.length < 3) {
            value = '0' + value;
            cropCount = value;
          }
        });
      } else {
        //print("countValuetryelse");
        cropCount = "001";
        cCount = 1;
      }
    } catch (e) {
      //print("countValuetrycatch");
      cropCount = "001";
      cCount = 1;
    }

    blockIDGenerated(valFarm, cropCount);
  }

  blockIDGenerated(String farmID, String cropCount) async {
    //print("asasasas");
    setState(() {
      String space = "_";
      blockId = farmID + space + cropCount.toString();
      blockIDAdded = true;
    });
  }

  void farmSearch(String farmerId) async {
    String qrrFarm =
        'select distinct farmIDT,farmName,farmerId,prodLand  from farm where farmerId = \'' +
            farmerId +
            '\'';
    //print("qrrFarm_qrrFarm" + qrrFarm);
    List farmList = await db.RawQuery(qrrFarm);
    farmUIModel = [];
    farmitems.clear();
    for (int i = 0; i < farmList.length; i++) {
      String farmIDT = farmList[i]["farmIDT"].toString();
      String farmName = farmList[i]["farmName"].toString();
      String land = farmList[i]["prodLand"].toString();
      var uiModel = new UImodel2(farmName, farmIDT, land);
      farmUIModel.add(uiModel);
      setState(() {
        farmitems.add(DropdownModel(
          farmName,
          farmIDT,
        ));
        //prooflist.add(property_value);
      });
    }
    if (farmList.length > 0) {
      farmLoaded = true;
    }
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];

    listings.add(
        txt_label_mandatory("Select the Farmer", Colors.black, 15.0, false));

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          farmLoaded = false;
          slcFarm = "";
          blockIDAdded = false;
          slctFarms = null;
          valFarm = "";
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          farmSearch(valFarmer);
        });
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Select the Farm", Colors.black, 15.0, false)
        : Container());

    listings.add(farmLoaded
        ? DropDownWithModel(
            itemlist: farmitems,
            selecteditem: slctFarms,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slctFarms = value!;
                blockIDAdded = false;
                valFarm = "";
                valFarm = slctFarms!.value;
                slcFarm = slctFarms!.name;
                overallArea = 0.0;
                getBlockAreaArea = 0.0;
                farmAreaValue = 0.0;
                getBlockName(valFarm);
                getArea(valFarm);
                getCropCount(valFarm);
                /*  for (int i = 0; i < farmUIModel.length; i++) {
                  if (valFarm == farmUIModel[i].value) {
                    prosLand = farmUIModel[i].value2;
                  }
                }*/
              });
            },
            onClear: () {
              setState(() {});
            })
        : Container());

    listings.add(valFarm.length > 0
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.length > 0
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(txt_label_mandatory("Block Name", Colors.black, 15.0, false));
    listings.add(txtfield_dynamic("Block Name", blockNameController, true, 20));

    listings.add(
        txt_label_mandatory("Block Area (Acre)", Colors.black, 15.0, false));
    listings.add(txtfieldAllowFourDecimal(
            "Block Area (Acre)", blockAreaTextEditController, false));

    listings.add(btn_dynamic(
        label: "Area",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          areaPlottingAdded = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => geoploattingFarm(3)));
          areaPlotted = true;
          if (areaPlottingAdded) {
            setState(() {
              blockArea = blockMenuAreaData!.Acre;
              double num1 = double.parse((blockArea));
              String block = num1.toStringAsFixed(3).toString();
              blockAreaTextEditController.text = block;
             /* if (blockAreaTextEditController.text.isNotEmpty) {
                double getArea = double.parse(blockAreaTextEditController.text);

                if (getArea > 0.00) {

                } else {
                  setState(() {
                    areaPlotted = false;
                    GeoploattingBlockMenuArealist.clear();
                  });
                }
              }*/
            });
          }
        }));

    listings.add(blockIDAdded
        ? txt_label_mandatory("Block ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockIDAdded ? cardlable_dynamic(blockId.toString()) : Container());

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
                  validation();
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

  void validation() {
    if (slcFarmer.isEmpty) {
      alertPopup(context, "Farmer should not be empty");
    } else if (slcFarm.isEmpty) {
      alertPopup(context, "Farm should not be empty");
    } else if (blockNameController.text.isEmpty) {
      alertPopup(context, "Block Name should not be empty");
    }
    else if(!areaPlotted){
      alertPopup(context, "Please plot the area for Block Area (Acre)");
    }
    else {
      blockNameValidation();
    }
  }

  void blockNameValidation() {
    bool blockNameExist = false;

    for (int a = 0; a < blockDetail.length; a++) {
      //print("blockTextEditControllertext" + blockNameController.text);
      if (blockDetail[a].blockName == blockNameController.text) {
        blockNameExist = true;
      }
    }

    if (blockNameExist) {
      alertPopup(context, "Block Name already exists");
    } else if (blockAreaTextEditController.text.length == 0) {
      alertPopup(context, "Block Area (Acre) should not be empty");
    } else {
      blockAreaValidation();
    }
  }

  void blockAreaValidation() {
    if (blockAreaTextEditController.text.length > 0) {
      var land;
      double area = double.parse(blockAreaTextEditController.text);
      getBlockAreaArea = overallArea + area;

      if (prosLand.length > 0) {
        land = num.parse(prosLand);
      }
      if (area < 0 || area == 0) {
        alertPopup(context, "Block Area (Acre)should be greater than zero");
      } else if (getBlockAreaArea > farmAreaValue) {
        alertPopup(context,
            "Block Area(Acre) should not be Greater than Proposed Planting Area (Acre)");
      } else {
        confirmation();
      }
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
            saveBlockRegistration();
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

  Future<void> saveBlockRegistration() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    //print('txnHeader ' + agentid! + "" + agentToken!);
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
    //print(txnsucc);

    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnBlockRegistration, revNo.toString(), '', '', '');

    int blockRegister = await db.saveBlockRegistration(
        valFarmer,
        valFarm,
        blockId,
        seasonCode,
        revNo.toString(),
        "1",
        blockAreaTextEditController.text,
        blockNameController.text,
        txntime);

    if (GeoploattingBlockMenuArealist.length > 0) {
      for (int i = 0; i < GeoploattingBlockMenuArealist.length; i++) {
        //print("geoplatinglistCrop" + GeoploattingBlockMenuArealist.toString());

        int blockAreaPlotting = await db.saveBlockAreaPlotting(
          valFarmer,
          valFarm,
          blockId,
          GeoploattingBlockMenuArealist[i].Longitude,
          GeoploattingBlockMenuArealist[i].orderofGps.toString(),
          GeoploattingBlockMenuArealist[i].Latitude,
          revNo.toString(),
        );

       // print("savefarmgpslocation" + revNo.toString());
      }
    }

    await db.UpdateTableValue(
        'blockDetails', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Block Registration done Successfully",
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

    GeoploattingBlockMenuArealist
        .clear(); // clear the plotting list once transaction done
  }
}

class BlockDetail {
  String? blockName;
  String? blockID;

  BlockDetail(this.blockName, this.blockID);
}
