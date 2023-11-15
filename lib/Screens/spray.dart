import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Database/Model/SprayInsert.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import '../main.dart';

class Spraying extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Spraying();
}

class _Spraying extends State<Spraying> {
  TextEditingController expectedyieldinvolumeController =
  new TextEditingController();
  TextEditingController harvestedyieldsController = new TextEditingController();
  TextEditingController quantityharvestedController =
  new TextEditingController();
  TextEditingController operatorReportController = new TextEditingController();
  TextEditingController noofstemsController = new TextEditingController();
  TextEditingController observationphiController = new TextEditingController();
  TextEditingController produceidController = new TextEditingController();
  TextEditingController noofunitsController = new TextEditingController();
  TextEditingController harvesternameController = new TextEditingController();
  TextEditingController diseasetargetController = new TextEditingController();
  TextEditingController activeIngController = new TextEditingController();
  TextEditingController cmnRecommendationController = new TextEditingController();
  TextEditingController agrovertController = new TextEditingController();

  String farmerTraceCode = "";

  String sprayDate = '',
      labelsprayDate = '';
  String maintenanceDate = '',
      labelMaintenanceDate = '';
  String endSprayDate = '',
      endDate = '';
  DateTime? expDate;

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Cancel';
  String no = 'No',
      yes = 'Yes';

  String valFarmer = "",
      valchemname = "",
      valuom = "",
      valequiptype = "",
      valapplimethod = "",
      valblock = "",
      plantingid = "",
      valFarm = "";
  String cropPlanted = "",
      cropVariety = "",
      plantedID = "",
      varietyID = "";
  String expctdDate = '';

  String slcFarmer = "",
      slcFarm = "",
      slcblock = "",
      slcmethod = "",
      slcchemical = "",
      slcuom = "",
      slcequip = "";

  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String plantingDate = "";
  String slcWard = "",
      slcVillage = "",
      valWard = "",
      valVillage = "";
  String slcPlanting = "",
      valPlanting = "";

  int curIdLim = 0,
      resId = 0,
      curIdLimited = 0,
      farmerId = 0;

  List<UImodel3> farmerUIModel = [];
  List<UImodel2> farmUIModel = [];
  List<UImodel> blockUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarms;

  List<DropdownModel> blockitems = [];
  DropdownModel? slctBlocks;

  List<DropdownMenuItem> agroChDropDownLists = [];
  List<DropdownMenuItem> trainingStatusDropDown = [];
  String slctAgroCh = '',
      valAgroCh = '',
      slctAgroChId = '';
  String slcTrainingStatus = "",
      valTrainingStatus = "";
  List<UImodel> agroChUIModel = [];
  List<UImodel> trainingStatusUIModel = [];
  List<UImodel> plantingUIModel = [];

  /*Farmer Name Dropdown*/
  bool isFarmerLoaded = false;
  List<DropdownMenuItem> farmerNameDropDownLists = [];
  String slctFarmerName = '',
      valFarmerName = '',
      slctFarmerNameId = '';
  List<UImodel3> farmerNameUIModel = [];

  /*Farm Name Dropdown*/
  bool isFarmLoaded = false;
  List<DropdownMenuItem> farmNameDropDownLists = [];
  String slctFarmName = '',
      valFarmName = '',
      slctFarmNameId = '';
  List<UImodel> farmNameUIModel = [];

  List<DropdownMenuItem> uomDropDownLists = [];
  List<UImodel> uomUIModel = [];
  List<DropdownMenuItem> namechemDropDownLists = [];

  List<UImodel> namechemUIModel = [];
  List<DropdownMenuItem> methodappliDropDownLists = [];

  String phDays = '';

  List<UImodel> methodappliUIModel = [];
  List<DropdownMenuItem> farmerDropdown = [];
  List<DropdownMenuItem> farmDropdown = [];
  List<DropdownMenuItem> blockDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];
  List<DropdownMenuItem> plantingDropdown = [];

  List<DropdownModel> plantingItems = [];
  DropdownModel? selectPlanting;

  bool farmLoaded = false;
  bool blockLoaded = false;
  bool afterPlantingDate = false;
  bool validDate = false;
  bool plantingLoaded = false;
  bool phiEmpty = false;

  String uom="";

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
    ward();

    //New
    //farmerTraceCode = farmerId.toString();
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  Future<void> village(String cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct fm.villageId as villCode ,fm.[villageName] as villName from [farmer_master] fm inner join [farmCrop] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] where vl.[gpCode]=\'' +
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
        'select distinct vl.[gpCode] as cityCode,ct.[cityName] as cityName from [farmer_master] fm inner join [farmCrop] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode]');

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

  Future<void> initValue() async {
    String agroChQry =
        'select * from animalCatalog where catalog_code =\'' + "77" + '\'';
    List agroChList = await db.RawQuery(agroChQry);

    agroChDropDownLists = [];
    agroChUIModel.clear();

    if (agroChList.isNotEmpty) {
      for (int i = 0; i < agroChList.length; i++) {
        String agroChId = agroChList[i]["DISP_SEQ"].toString();
        String agroChName = agroChList[i]["property_value"].toString();
        var uiModel = new UImodel(agroChName, agroChId);
        agroChUIModel.add(uiModel);

        setState(() {
          agroChDropDownLists.add(DropdownMenuItem(
            child: Text(agroChName),
            value: agroChName,
          ));
        });
      }
    } else {
      print('There is no data From animalCatalogue Table - AgroChemical Data');
    }

    String uomQry =
        'select * from animalCatalog where catalog_code =\'' + "76" + '\'';
    List uomList = await db.RawQuery(uomQry);

    uomDropDownLists = [];
    uomUIModel.clear();

    if (uomList.isNotEmpty) {
      for (int i = 0; i < uomList.length; i++) {
        String agroChId = uomList[i]["DISP_SEQ"].toString();
        String agroChName = uomList[i]["property_value"].toString();
        var uiModel = new UImodel(agroChName, agroChId);
        uomUIModel.add(uiModel);

        setState(() {
          uomDropDownLists.add(DropdownMenuItem(
            child: Text(agroChName),
            value: agroChName,
          ));
        });
      }
    } else {
      print('There is no data From animalCatalogue Table - AgroChemical Data');
    }

    String methodappliQry =
        'select * from animalCatalog where catalog_code =\'' + "78" + '\'';
    List methodappliList = await db.RawQuery(methodappliQry);

    methodappliDropDownLists = [];
    methodappliUIModel.clear();

    if (methodappliList.isNotEmpty) {
      for (int i = 0; i < methodappliList.length; i++) {
        String agroChId = methodappliList[i]["DISP_SEQ"].toString();
        String agroChName = methodappliList[i]["property_value"].toString();
        var uiModel = new UImodel(agroChName, agroChId);
        methodappliUIModel.add(uiModel);

        setState(() {
          methodappliDropDownLists.add(DropdownMenuItem(
            child: Text(agroChName),
            value: agroChName,
          ));
        });
      }
    } else {
      print('There is no data From animalCatalogue Table - AgroChemical Data');
    }

    String trainingStatusQry =
        'select * from animalCatalog where catalog_code =\'' + "14" + '\'';
    List trainingStatusList = await db.RawQuery(trainingStatusQry);

    trainingStatusDropDown = [];
    trainingStatusUIModel.clear();

    if (trainingStatusList.isNotEmpty) {
      for (int i = 0; i < trainingStatusList.length; i++) {
        String DISP_SEQ = trainingStatusList[i]["DISP_SEQ"].toString();
        String propertyValue =
        trainingStatusList[i]["property_value"].toString();
        var uiModel = new UImodel(propertyValue, DISP_SEQ);
        trainingStatusUIModel.add(uiModel);

        setState(() {
          trainingStatusDropDown.add(DropdownMenuItem(
            child: Text(propertyValue),
            value: propertyValue,
          ));
        });
      }
    }
  }

  void farmerSearch(String villageCode) async {
    List farmerList = await db.RawQuery(
        'select distinct fm.fName,fm.farmerId,fm.farmerCode,fm.idProofVal,fm.trader from farmer_master as fm inner join farm as f on fm.farmerId = f.farmerId inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where fm.villageId= \'' +
            villageCode +
            '\'');
    print("farmerList_farmerList" + farmerList.toString());

    farmerUIModel = [];
    farmerDropdown = [];
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

  void farmSearch(String farmerId) async {
    String qryFarm =
        'select distinct f.farmIDT,f.farmName, f.prodLand  from farm as f inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where f.farmerId = \'' +
            farmerId +
            '\'';
    print("qrrFarm_qrrFarm" + qryFarm);
    List farmList = await db.RawQuery(qryFarm);
    farmUIModel = [];
    farmDropdown = [];
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

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmList.isNotEmpty) {
          farmLoaded = true;
          slcFarm = "";
        }
      });
    });
  }

  void blockidsearch(String farmCode) async {
    String blockidList =
        'select distinct blockId,blockName  from  farmCrop  where farmCodeRef=\'' +
            farmCode +
            '\';';
    List blockList = await db.RawQuery(blockidList);
    blockUIModel = [];
    blockDropdown = [];
    blockitems.clear();
    for (int i = 0; i < blockList.length; i++) {
      String blockId = blockList[i]["blockId"].toString();
      String blockName = blockList[i]["blockName"].toString();
      var uiModel = new UImodel(blockName, blockId);
      blockUIModel.add(uiModel);
      setState(() {
        blockitems.add(DropdownModel(
          blockName,
          blockId,
        ));
        //prooflist.add(property_value);
      });
    }
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (blockList.isNotEmpty) {
          blockLoaded = true;
          slcblock = "";
        }
      });
    });
  }

  void getCropVariety(String plantingID) async {
    String getProductQry =
        'select distinct v.hsCode, fc.commonRec, fc.seedLotNo,fc.cropVariety,fc.cropgrade,fc.dateOfSown, g.grade as gradeName,v.vName as varietyName from farmCrop as fc inner join varietyList v on v.vCode= fc.cropVariety  inner join procurementGrade g on gradeCode=fc.cropgrade where fc.farmcrpIDT=\'' +
            plantingID +
            '\'';
    print("getProductQry_getProductQry" + getProductQry.toString());

    List cropVarietyList = await db.RawQuery(getProductQry);

    //for (int i = 0; i < cropVarietyList.length; i++) {
    if (cropVarietyList.isNotEmpty) {
      String variety = cropVarietyList[0]["gradeName"].toString();
      String crop = cropVarietyList[0]["varietyName"].toString();
      String cropCode = cropVarietyList[0]["cropVariety"].toString();
      String varietyCode = cropVarietyList[0]["cropgrade"].toString();
      String dateOfSown = cropVarietyList[0]["dateOfSown"].toString();
      expctdDate = cropVarietyList[0]["seedLotNo"].toString();
      uom = cropVarietyList[0]["hsCode"].toString();


      setState(() {
        if(cropVarietyList[0]["commonRec"]!='' && cropVarietyList[0]["commonRec"]!=null &&cropVarietyList[0]["commonRec"]!='null'){
          cmnRecommendationController.text = cropVarietyList[0]["commonRec"].toString();
        }else{
          cmnRecommendationController.text ='';
        }
        cropVariety = variety;
        cropPlanted = crop;
        plantedID = cropCode;
        varietyID = varietyCode;
        plantingDate = dateOfSown;
        chemicalNameList(plantedID, varietyID);
      });
    }
  }

  Future<void> chemicalNameList(String plantedID, String varietyID) async {
    String namechemQry =
        'select distinct phiIn,phId,chemicalName from pcbpList where '
            'crop =\'' +
            plantedID +
            '\''
                ' and cropVariety =\'' +
            varietyID +
            '\'';
    print("namechemQry_namechemQry" + namechemQry.toString());
    List namechemList = await db.RawQuery(namechemQry);
    print("namechemList_namechemList" + namechemList.toString());

    namechemDropDownLists = [];
    namechemUIModel.clear();

    if (namechemList.isNotEmpty) {
      for (int i = 0; i < namechemList.length; i++) {
        String agroChId = namechemList[i]["phId"].toString();
        String agroChName = namechemList[i]["chemicalName"].toString();
        phDays = namechemList[i]["philn"].toString();

        print("phDays" + phDays.toString());

        var uiModel = new UImodel(agroChName, agroChId);
        namechemUIModel.add(uiModel);

        setState(() {
          namechemDropDownLists.add(DropdownMenuItem(
            child: Text(agroChName),
            value: agroChName,
          ));
        });
      }
    }
  }

  Future<void> getPcbpList(String valchemname) async {
    String pcbpQry =
        'select distinct uom,chemicalName,dosage,phiIn from pcbpList where phId in (\'' +
            valchemname +
            '\' ) and crop=\'' +
            plantedID +
            '\' and cropVariety=\'' +
            varietyID +
            '\'';
    print("pcbpQry_pcbpQry" + pcbpQry.toString());

    List pcbpList = await db.RawQuery(pcbpQry);
    print("pcbpList_pcbpList" + pcbpList.toString());
    if (pcbpList.isNotEmpty) {
      String dosage = pcbpList[0]["dosage"].toString();
      String phiIn = pcbpList[0]["phiIn"].toString();
      String uom = pcbpList[0]["uom"].toString();
      setState(() {
        noofstemsController.text = dosage;
        harvestedyieldsController.text = phiIn;
        int getValue = 0;
        if (phiIn.isNotEmpty) {
          getValue = int.parse(phiIn);
        }
        if (phiIn
            .trim()
            .toString()
            .isEmpty || phiIn.trim().toString() == "0") {
          setState(() {
            phiEmpty = true;
          });
        }
        else if (getValue <= 0) {
          setState(() {
            phiEmpty = true;
          });
        }
        else {
          setState(() {
            phiEmpty = false;
          });
        }
        if (uomUIModel.isNotEmpty) {
          for (int i = 0; i < uomUIModel.length; i++) {
            if (uom == uomUIModel[i].value) {
              slcuom = uomUIModel[i].name;
              valuom = uomUIModel[i].value;
            }
          }
        }
      });
    }
  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select farmcrpIDT from farmCrop where blockId=\'' + blockID + '\';';
    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUIModel = [];
    plantingItems = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["farmcrpIDT"].toString();

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
              title: Text('Spraying',
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
          slcblock = "";
          slcFarmer = "";
          valFarm = "";
          slcFarm = "";
          slctFarmers = null;
          slctBlocks = null;
          slctFarms = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          villageDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
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
          slcblock = "";
          slctFarmers = null;
          valFarm = "";
          slctBlocks = null;
          slctFarms = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
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
    /*  listings.add(singlesearchDropdown(
      itemlist: farmerDropdown,
      selecteditem: slcFarmer,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slcFarmer = value!;
          farmLoaded = false;
          slcFarm = "";
          blockLoaded = false;
          slcblock = "";
          plantingid = "";
          cropPlanted = "";
          cropVariety = "";
          valblock = "";
          slcchemical = "";
          slcuom = "";
          noofstemsController.text = "";
          harvestedyieldsController.text = "";
          for (int i = 0; i < farmerUIModel.length; i++) {
            if (value == farmerUIModel[i].name) {
              valFarmer = farmerUIModel[i].value;
              farmSearch(valFarmer);
            }
          }
        });
      },
    ));  */

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          farmLoaded = false;
          slcFarm = "";
          blockLoaded = false;
          slcblock = "";
          plantingid = "";
          cropPlanted = "";
          cropVariety = "";
          valFarm = "";
          valblock = "";
          slcchemical = "";
          slcuom = "";
          blockitems.clear();
          farmitems.clear();
          //slctFarms.clear();
          slctFarms = null;
          slctBlocks = null;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
          noofstemsController.text = "";
          harvestedyieldsController.text = "";
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          farmSearch(valFarmer);
        });
        print('selectedvalue ' + slctFarmers!.value);
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
            slcblock = "";
            valblock = "";
            plantingid = "";
            blockLoaded = false;
            cropPlanted = "";
            cropVariety = "";
            slcchemical = "";
            slcuom = "";
            blockitems.clear();
            valFarm = "";
            plantingLoaded = false;
            plantingItems = [];
            slcPlanting = "";
            valPlanting = "";
            selectPlanting = null;

            slctBlocks = null;
            noofstemsController.text = "";
            harvestedyieldsController.text = "";
            valFarm = slctFarms!.value;
            slcFarm = slctFarms!.name;
            print('selectedvalue ' + slctFarms!.value);
            blockidsearch(valFarm);
          });
        },
        onClear: () {
          setState(() {});
        })
        : Container());

    listings.add(valFarm.isNotEmpty
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.isNotEmpty
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory(
        "Select the Block Name", Colors.black, 15.0, false)
        : Container());

    /* listings.add(blockLoaded
        ? singlesearchDropdown(
            itemlist: blockDropdown,
            selecteditem: slcblock,
            hint: "Select Block Name",
            onChanged: (value) {
              setState(() {
                slcblock = value!;
                valblock = "";
                plantingid = "";
                cropPlanted = "";
                cropVariety = "";
                slcchemical = "";
                slcuom = "";
                noofstemsController.text = "";
                harvestedyieldsController.text = "";
                for (int i = 0; i < blockUIModel.length; i++) {
                  if (value == blockUIModel[i].name) {
                    valblock = blockUIModel[i].value;
                    plantingid = blockUIModel[i].value2;
                    plantingDate = blockUIModel[i].value3;
                    getCropVariety(valblock);
                  }
                }
              });
            },
          )
        : Container()); */

    listings.add(blockLoaded
        ? DropDownWithModel(
      itemlist: blockitems,
      selecteditem: slctBlocks,
      hint: "Select Block",
      onChanged: (value) {
        setState(() {
          slctBlocks = value!;
          plantingid = "";
          cropPlanted = "";
          cropVariety = "";
          slcchemical = "";
          slcuom = "";
          noofstemsController.text = "";
          harvestedyieldsController.text = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
          valblock = slctBlocks!.value;
          slcblock = slctBlocks!.name;
          plantingIdSearch(valblock);
          /*   for (int i = 0; i < blockUIModel.length; i++) {
                  if (valblock == blockUIModel[i].value) {
                    plantingid = blockUIModel[i].value2;
                    plantingDate = blockUIModel[i].value3;
                    getCropVariety(valblock);
                  }
                }*/
        });
      },
    )
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Block ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(valblock.toString()) : Container());

    /* listings.add(blockLoaded
        ? txt_label_mandatory("Crop-Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(plantingid.toString()) : Container());



*/

    listings.add(plantingLoaded
        ? txt_label_mandatory("Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? DropDownWithModel(
      itemlist: plantingItems,
      selecteditem: selectPlanting,
      hint: "Select Planting ID",
      onChanged: (value) {
        setState(() {
          selectPlanting = value!;
          valPlanting = selectPlanting!.value;
          slcPlanting = selectPlanting!.name;
          plantingid = valPlanting;
          cropPlanted = "";
          cropVariety = "";
          plantingDate = "";
          getCropVariety(valPlanting);
          //getrecommendation(valPlanting);
        });
      },
    )
        : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Planted", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? cardlable_dynamic(cropPlanted.toString())
        : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Variety ($uom)", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? cardlable_dynamic(cropVariety.toString())
        : Container());

    listings.add(
        txt_label_mandatory("Date of Spraying", Colors.black, 14.0, false));

    listings.add(selectDate(
        context1: context,
        slctdate: sprayDate,
        onConfirm: (date) =>
            setState(
                  () {
                sprayDate = DateFormat('dd-MM-yyyy').format(date);
                labelsprayDate = DateFormat('yyyy-MM-dd').format(date);
                sprayDateComparison(date);
                endDateComparison(endSprayDate);
                print('labelsprayDate' + labelsprayDate);
              },
            )));

    listings.add(txt_label("End Date of Spraying", Colors.black, 14.0, false));

    listings.add(selectDate(
        context1: context,
        slctdate: endDate,
        onConfirm: (date) =>
            setState(
                  () {
                endDate = DateFormat('dd-MM-yyyy').format(date);
                endSprayDate = DateFormat('yyyy-MM-dd').format(date);
                endDateComparison(endSprayDate);
              },
            )));

    listings.add(blockLoaded
        ? txt_label_mandatory("Name of Chemical", Colors.black, 15.0, false)
        : Container());

    listings.add(blockLoaded
        ? singlesearchDropdown(
      itemlist: namechemDropDownLists,
      selecteditem: slcchemical,
      hint: "Select Name of Chemical",
      onChanged: (value) {
        setState(() {
          slcchemical = value!;
          noofstemsController.text = "";
          harvestedyieldsController.text = "";
          for (int i = 0; i < namechemUIModel.length; i++) {
            if (value == namechemUIModel[i].name) {
              valchemname = namechemUIModel[i].value;
              getPcbpList(valchemname);
            }
          }
        });
      },
    )
        : Container());

    listings.add(txt_label_mandatory("Dosage", Colors.black, 14.0, false));
    listings
        .add(txtfield_digits_integer("Dosage", noofstemsController, true, 60));

    listings.add(txt_label_mandatory("UOM", Colors.black, 15.0, false));

    listings.add(singlesearchDropdown(
      itemlist: uomDropDownLists,
      selecteditem: slcuom,
      hint: "Select UOM",
      onChanged: (value) {
        setState(() {
          slcuom = value!;
          for (int i = 0; i < uomUIModel.length; i++) {
            if (value == uomUIModel[i].name) {
              valuom = uomUIModel[i].value;
            }
          }
        });
        print("UOM" + valuom);
      },
    ));

    listings.add(
        txt_label_mandatory("Name of the Operator", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Name of the Operator", harvesternameController, true, 60));

    listings.add(txt_label_mandatory(
        "Operator Mobile Number", Colors.black, 14.0, false));
    listings.add(txtfield_digits_integer(
        "Operator Mobile Number", quantityharvestedController, true, 11));

    listings
        .add(txt_label("Operator Medical Report", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Operator Medical Report", operatorReportController, true, 50));

    listings.add(txt_label_mandatory(
        "Type Application Equipment", Colors.black, 15.0, false));

    listings.add(singlesearchDropdown(
      itemlist: agroChDropDownLists,
      selecteditem: slcequip,
      hint: "Select Type Application Equipment",
      onChanged: (value) {
        setState(() {
          slcequip = value!;
          for (int i = 0; i < agroChUIModel.length; i++) {
            if (value == agroChUIModel[i].name) {
              valequiptype = agroChUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(txt_label_mandatory(
        "Method of Application", Colors.black, 15.0, false));

    listings.add(singlesearchDropdown(
      itemlist: methodappliDropDownLists,
      selecteditem: slcmethod,
      hint: "Select Method of Application",
      onChanged: (value) {
        setState(() {
          slcmethod = value!;
          for (int i = 0; i < methodappliUIModel.length; i++) {
            if (value == methodappliUIModel[i].name) {
              valapplimethod = methodappliUIModel[i].value;
            }
          }
        });
      },
    ));

    /*listings.add(
        txt_label_mandatory("PHI of the Chemical", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "PHI of the Chemical", harvestedyieldsController, true, 60));*/
    listings.add(txt_label("PHI of the Chemical", Colors.black, 14.0, false));
    if (phiEmpty) {
      listings.add(txtfield_digits_integer(
          "PHI of the Chemical", harvestedyieldsController, true, 10));
    }
    else {
      listings.add(txtfield_digits_integer(
          "PHI of the Chemical", harvestedyieldsController, false, 10));
    }

    listings.add(txt_label_mandatory(
        "Training Status of Spray Operator", Colors.black, 14.0, false));

    listings.add(singlesearchDropdown(
      itemlist: trainingStatusDropDown,
      selecteditem: slcTrainingStatus,
      hint: "Select Training Status",
      onChanged: (value) {
        setState(() {
          slcTrainingStatus = value!;
          for (int i = 0; i < trainingStatusUIModel.length; i++) {
            if (value == trainingStatusUIModel[i].name) {
              valTrainingStatus = trainingStatusUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(txt_label_mandatory(
        "Agrovet or Supplier of the Chemical", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Agrovet or Supplier of the Chemical", agrovertController, true, 60));

    /* listings.add(txt_label(
        "Last Date of Calibration & Maintenance of Spraying Equipment ",
        Colors.black,
        14.0,
        false));
    listings.add(txt_label_mandatory("Equipment", Colors.black, 14.0, false));*/

    listings.add(Container(
      padding: EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
            text: "Last Date of Calibration & Maintenance of",
            style: TextStyle(color: Colors.black, fontSize: 14.0),
            children: [
              TextSpan(
                  text: ' Spraying Equipment',
                  style: TextStyle(color: Colors.black, fontSize: 14.0)),
              TextSpan(
                  text: ' *', style: TextStyle(color: Colors.red, fontSize: 10))
            ]),
        maxLines: 4,
      ),
    ));
    listings.add(selectDate(
        context1: context,
        slctdate: maintenanceDate,
        onConfirm: (date) =>
            setState(
                  () {
                maintenanceDate = DateFormat('dd-MM-yyyy').format(date);
                labelMaintenanceDate = DateFormat('yyyy-MM-dd').format(date);
              },
            )));

    listings.add(txt_label_mandatory(
        "Disease/Insect Targeted", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Disease/Insect Targeted", diseasetargetController, true, 60));

    listings.add(txt_label(
        "Active Ingredient", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Active Ingredient", activeIngController, true, 60));

    listings.add( txt_label("Recommendation", Colors.black, 14.0, false));
    listings.add( txtFieldLargeDynamic(
        "Recommendation", cmnRecommendationController, false, 100));

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

  void endDateComparison(String endDate) async {
    if (labelsprayDate != "" && endDate != "") {
      String dateValue = labelsprayDate;
      String endDateValue = endDate;
      String trimmedDate = dateValue.substring(0, 10);

      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');
      List<String> splitEndDate = endDateValue.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertSprayDate = new DateTime(strYear, strMonths, strDate);

      String strYearE = splitEndDate[0];
      String strMonthE = splitEndDate[1];
      String strDateE = splitEndDate[2];

      int strYear1 = int.parse(strYearE);
      int strMonths1 = int.parse(strMonthE);
      int strDate1 = int.parse(strDateE);

      DateTime convertSprayEndDate =
      new DateTime(strYear1, strMonths1, strDate1);

      DateTime valEnd = convertSprayEndDate;
      bool valDate = convertSprayDate.isAfter(valEnd);
      print("convertSprayEndDate" + convertSprayEndDate.toString());
      print("convertSprayDate" + convertSprayDate.toString());
      print("valDateValue" + valDate.toString());
      if (valDate) {
        setState(() {
          validDate = true;
        });
      } else {
        setState(() {
          validDate = false;
        });
      }
    }
  }

  void sprayDateComparison(DateTime sprayDate) async {
    print("plantingDate_plantingDate" + plantingDate.toString());
    if (plantingDate != "") {
      String dateValue = plantingDate;
      String trimmedDate = dateValue.substring(0, 10);

      DateTime convertSprayDate = sprayDate;
      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertPlantingDate = new DateTime(strYear, strMonths, strDate);

      print("convertPlantingDate" + convertPlantingDate.toString());

      DateTime valEnd = convertSprayDate;
      bool valDate = convertPlantingDate.isAfter(valEnd);
      if (valDate) {
        setState(() {
          afterPlantingDate = true;
        });
      } else {
        setState(() {
          afterPlantingDate = false;
        });
      }
    }
  }

  void btnSubmit() {
    if (slcWard.isEmpty) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.isEmpty) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer.isEmpty) {
      alertPopup(context, "Farmer Name should not be empty");
    } else if (slcFarm.isEmpty) {
      alertPopup(context, "Farm Name should not be empty");
    } else if (slcblock.isEmpty) {
      alertPopup(context, "Block Name should not be empty");
    } else if (slcPlanting.isEmpty) {
      alertPopup(context, "Planting ID should not be empty");
    } else if (sprayDate.isEmpty) {
      alertPopup(context, "Spraying Date should not be empty");
    } else {
      if (afterPlantingDate) {
        alertPopup(
            context, "Spraying Date should be greater than Planting Date");
      } else {
        validation();
      }
    }
  }

  void validation() {
    print("validDate_validDate" + validDate.toString());
    if (endDate.isNotEmpty && validDate) {
      alertPopup(context,
          "End Date of Spraying should not be less than Spraying Date");
    } else if (slcchemical.isEmpty) {
      alertPopup(context, "Chemical Name should not be empty");
    } else if (noofstemsController.text.isEmpty) {
      alertPopup(context, "Dosage should not be empty");
    } else if (slcuom.isEmpty) {
      alertPopup(context, "UOM should not be empty");
    } else if (harvesternameController.text.isEmpty) {
      alertPopup(context, "Name of the Operator should not be empty");
    } else if (quantityharvestedController.text.isEmpty) {
      alertPopup(context, "Operator Mobile Number should not be empty");
    } else if (slcequip.isEmpty) {
      alertPopup(context, "Type Application Equipment should not be empty");
    } else if (slcmethod.isEmpty) {
      alertPopup(context, "Method of Application should not be empty");
    }
    /*else if (harvestedyieldsController.text.length == 0) {
      alertPopup(context, "PHI of the Chemical should not be empty");
    }*/
    else if (slcTrainingStatus.isEmpty) {
      alertPopup(context, "Training Status should not be empty");
    } else if (agrovertController.text.isEmpty) {
      alertPopup(
          context, "Agrovet or Supplier of the Chemical should not be empty");
    } else if (maintenanceDate.isEmpty) {
      alertPopup(context, "Last Date should not be empty");
    } else if (diseasetargetController.text.isEmpty) {
      alertPopup(context, "Disease/Insect Targeted should not be empty");
    }
    else {
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
            saveSprayData();
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

  Future<void> saveSprayData() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    //print('txnHeader ' + agentid + "" + agentToken);
    Random rnd = new Random();
    int revNo = 100000 + rnd.nextInt(999999 - 100000);

    calculateDate();


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
          txntime, appDatas.txn_spray, revNo.toString(), '', '', '');

      int saveSprayValues = await db.saveSpray(new SprayInsert(
          cmnRecommendationController.text,
          valFarmer,
          valFarm,
          plantingid,
          valblock,
          labelsprayDate,
          valchemname,
          noofstemsController.text,
          valuom,
          harvesternameController.text,
          quantityharvestedController.text,
          valequiptype,
          valapplimethod,
          harvestedyieldsController.text,
          valTrainingStatus,
          agrovertController.text,
          labelMaintenanceDate,
          1,
          revNo.toString(),
          diseasetargetController.text,
          activeIngController.text,
          endSprayDate,
          operatorReportController.text.toString()));

      db.UpdateTableValue('spray', 'isSynched', '0', 'recNo', revNo.toString());

      TxnExecutor txnExecutor = new TxnExecutor();
      txnExecutor.CheckCustTrasactionTable();

      Alert(
        context: context,
        type: AlertType.info,
        title: "Transaction Successful",
        desc: "Spraying done Successfully",
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

  void calculateDate() {
    DateTime dateFromDB;
    String recDate = '';

    if (labelsprayDate.isNotEmpty && harvestedyieldsController.text.isNotEmpty) {
      dateFromDB = DateTime.parse(labelsprayDate).add(Duration(days: int.parse(harvestedyieldsController.text)));
    } else {
      dateFromDB = DateTime.parse(labelsprayDate);
    }

    if (expctdDate.isNotEmpty && expctdDate != 'null' && expctdDate != null) {
      print('expctdDate--' + expctdDate);
      var parsedExpctDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(expctdDate));
      var difference = dateFromDB.difference(DateTime.parse(parsedExpctDate)).inDays;
      print('value exisdifference' + difference.toString());

      if (difference > 0) {
        setState(() {
          recDate = DateFormat('yyyy-MM-dd').format(dateFromDB);
          print('value rec1' + recDate.toString());
        });
      } else {
        setState(() {
          recDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(expctdDate));
          print('value rec2' + recDate.toString());
        });
      }
    }else{
      recDate =DateFormat('yyyy-MM-dd').format(dateFromDB);
      print('value rec3' + recDate.toString());

    }
    db.UpdateTableValue(
        'farmCrop', 'seedLotNo', recDate, 'farmcrpIDT', plantingid);
  }

  void getrecommendation(String valPlanting) async{
    String getProductQry =
        'select distinct  commonRec from farmCrop where farmcrpIDT=\'' +
            valPlanting +
            '\' and farmerId=\'' +
            valFarmer +
            '\' and scoutDate = (SELECT MAX(scoutDate) FROM farmCrop WHERE farmcrpIDT=\'' +
            valPlanting +
            '\' and farmerId=\'' +
            valFarmer +
            '\' ORDER BY scoutDate DESC LIMIT 1)';
    print("getProductQry_getProductQry" + getProductQry.toString());
    List cropVarietyList = await db.RawQuery(getProductQry);
    print("getProductQry_getPr" + cropVarietyList.toString());
    if (cropVarietyList.isNotEmpty){
      setState(() {
        cmnRecommendationController.text = cropVarietyList[0]["commonRec"].toString();
      });
    }

  }

}

